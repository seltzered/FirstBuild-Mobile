//
//  FSTBleProduct.m
//  FirstBuild
//
//  Created by Myles Caley on 6/25/15.
//  Copyright (c) 2015 FirstBuild. All rights reserved.
//

#import "FSTBleProduct.h"

@implementation FSTBleProduct
{
  uint8_t numberOfServicesFullyDiscovered;
}

NSString * const FSTDeviceReadyNotification                 = @"FSTDeviceReadyNotification";
NSString * const FSTDeviceOtaReadyNotification              = @"FSTDeviceOtaReadyNotification";
NSString * const FSTDeviceLoadProgressUpdated               = @"FSTDeviceLoadProgressUpdated";
NSString * const FSTDeviceEssentialDataChangedNotification  = @"FSTDeviceEssentialDataChangedNotification";
NSString * const FSTBatteryLevelChangedNotification         = @"FSTBatteryLevelChangedNotification";

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.batteryLevel = [NSNumber numberWithInt:0];
        self.loadingProgress = [NSNumber numberWithInt:0];
        self.characteristics = [[NSMutableDictionary alloc]init];
        numberOfServicesFullyDiscovered = 0;
    }
    return self;
}

- (void) deviceReady
{
  for (id key in self.characteristics)
  {
    FSTBleCharacteristic* c = [self.characteristics objectForKey:key];
    if (c.bleCharacteristic.properties & CBCharacteristicPropertyNotify && c.wantNotification) {
      [self.peripheral setNotifyValue:YES forCharacteristic:c.bleCharacteristic];
    }
  }
//  [self readNonRequiredCharacteristicValues];
  [[NSNotificationCenter defaultCenter] postNotificationName:FSTDeviceReadyNotification  object:self.peripheral];
}

- (void) notifyDeviceLoadProgressUpdated
{
    [[NSNotificationCenter defaultCenter] postNotificationName:FSTDeviceLoadProgressUpdated  object:self.peripheral];
}

- (void) notifyDeviceEssentialDataChanged
{
    [[NSNotificationCenter defaultCenter] postNotificationName:FSTDeviceEssentialDataChangedNotification  object:self.peripheral];
}

#pragma mark - Interface Selectors
- (void) writeHandler: (FSTBleCharacteristic*)characteristic error:(NSError *)error;
{
}

-(void)readHandler: (FSTBleCharacteristic*)characteristic
{
}

- (void)readNonRequiredCharacteristicValues
{
  for (id key in self.characteristics)
  {
    FSTBleCharacteristic* c = [self.characteristics objectForKey:key];
    if (!c.requiresValue && (c.bleCharacteristic.properties & CBCharacteristicPropertyRead)) {
      [self readFstBleCharacteristic:c];
      NSLog(@"reading initial value for non required... %@", c.UUID);
    }
  }
}


- (void)readRequiredCharacteristicValues
{
  for (id key in self.characteristics)
  {
    FSTBleCharacteristic* c = [self.characteristics objectForKey:key];
    if (c.requiresValue) {
      [self readFstBleCharacteristic:c];
      NSLog(@"reading initial value... %@", c.UUID);
    }
  }
}

-(void)handleDiscoverCharacteristics: (NSArray*)characteristics
{
  
  NSLog(@"========================== SERVICE DISCOVERY ==========================");
  for (CBCharacteristic* characteristic in characteristics)
  {
    NSLog(@"    CHARACTERISTIC %@", [characteristic.UUID UUIDString]);
    
    FSTBleCharacteristic* c = [[FSTBleCharacteristic alloc] initWithCBCharacteristic:characteristic onPeripheral: self.peripheral];
    
    [self.characteristics setObject:c forKey:[c.bleCharacteristic.UUID UUIDString]];

    if (c.bleCharacteristic.properties & CBCharacteristicPropertyWrite)
    {
      NSLog(@"        CAN WRITE");
    }
    
    if (c.bleCharacteristic.properties & CBCharacteristicPropertyRead)
    {
      NSLog(@"        CAN READ");
    }
    
    if (c.bleCharacteristic.properties & CBCharacteristicPropertyNotify)
    {
      NSLog(@"        CAN NOTIFY");
    }
    
    if (c.bleCharacteristic.properties & CBCharacteristicPropertyWriteWithoutResponse)
    {
      NSLog(@"        CAN WRITE WITHOUT RESPONSE");
      
    }
  }
  
  NSLog(@"characteristic discovery complete for this service");
}

-(void)writeFstBleCharacteristic: (FSTBleCharacteristic*)characteristic withValue: (NSData*)data
{
  if (characteristic && characteristic.bleCharacteristic)
  {
    //note... this only handle withResponse for simplicity, if there is a use case that we need to handle
    //without response will need to update the selector signature to add type
    [self.peripheral writeValue:data forCharacteristic:characteristic.bleCharacteristic type:CBCharacteristicWriteWithResponse];
  }
  else
  {
    NSLog(@"writeFstBleCharacteristic: no characteristic to write");
  }
}

-(void) readFstBleCharacteristic: (FSTBleCharacteristic*)characteristic
{
  if (characteristic && characteristic.bleCharacteristic)
  {
    [self.peripheral readValueForCharacteristic:characteristic.bleCharacteristic];
  }
  else
  {
    NSLog(@"readFstBleCharacteristic: no characteristic to read");
  }
}

-(void)updateRequiredCharacteristicProgressWithCharacteristic: (FSTBleCharacteristic*)characteristic
{
  if (!characteristic.hasInitialValue && characteristic.requiresValue)
  {
    characteristic.hasInitialValue = YES;
    float requiredCharacteristicsCount = 0;
    float requiredCharacteristicsWithValueCount = 0;
    
    for (id key in self.characteristics)
    {
      FSTBleCharacteristic* c = [self.characteristics objectForKey:key];
      if (c.requiresValue) {
        requiredCharacteristicsCount++;
      }
      if (c.requiresValue && c.hasInitialValue) {
        requiredCharacteristicsWithValueCount++;
      }
    }
    
    self.loadingProgress = [NSNumber numberWithFloat:requiredCharacteristicsWithValueCount/requiredCharacteristicsCount];
    [self notifyDeviceLoadProgressUpdated];
    
    if ([self.loadingProgress floatValue]==1) {
      [self deviceReady];
    }
  }
}

#pragma mark - <CBPeripheralDelegate>

-(void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
  FSTBleCharacteristic* _characteristic = [self.characteristics objectForKey:[characteristic.UUID UUIDString]];
  
  if ([self.loadingProgress intValue] < 1) {
    NSLog(@"loading progress for %@ is %@ complete", self.friendlyName, self.loadingProgress);
    [self updateRequiredCharacteristicProgressWithCharacteristic:_characteristic];
  }
  
  [self readHandler:_characteristic];
}

-(void)peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    if (error)
    {
        DLog(@"error %@, writing characteristic %@", characteristic.UUID, error);
    }
    
    [self writeHandler:[self.characteristics objectForKey:[characteristic.UUID UUIDString]] error:error];
}

-(void)peripheral:(CBPeripheral *)peripheral didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    if (error)
    {
        NSLog(@"characteristic %@ notification failed %@", characteristic.UUID, error);
        return;
    }
    
    NSLog(@"characteristic %@ , notifying: %s", characteristic.UUID, characteristic.isNotifying ? "true" : "false");
    
}

-(void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error
{
    DLog("discovered services for peripheral %@", peripheral.identifier);
    numberOfServicesFullyDiscovered = 0;
    _loadingProgress = @0;
    NSArray * services = [self.peripheral services];
    for (CBService *service in services)
    {
        [self.peripheral discoverCharacteristics:nil forService:service];
    }
}

-(void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error
{
  [self handleDiscoverCharacteristics: service.characteristics];
  numberOfServicesFullyDiscovered++;
  
  if (numberOfServicesFullyDiscovered == self.peripheral.services.count) {
    NSLog(@"all discovery is completed");
    [self readRequiredCharacteristicValues];
  }
}


@end
