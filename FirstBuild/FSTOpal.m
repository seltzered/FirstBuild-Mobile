//
//  FSTOpal.m
//  FirstBuild
//
//  Created by Myles Caley on 3/22/16.
//  Copyright © 2016 FirstBuild. All rights reserved.
//

#import "FSTOpal.h"

@implementation FSTOpal
{
  NSMutableDictionary *requiredCharacteristics; // a dictionary of strings with booleans
 
}

NSString * const FSTCharacteristicOpalStatus = @"097A2751-CA0D-432F-87B5-7D2F31E45551";
NSString * const FSTCharacteristicOpalMode = @"79994230-4B04-40CD-85C9-02DD1A8D4DD0";
NSString * const FSTCharacteristicOpalLight = @"37988F00-EA39-4A2D-9983-AFAD6535C02E";
NSString * const FSTCharacteristicOpalCleanCycle = @"EFE4BD77-0600-47D7-B3F6-DC81AF0D9AAF";
//NSString * const FSTCharacteristicOpal
//NSString * const FSTCharacteristicOpal
//NSString * const FSTCharacteristicOpal

- (id)init
{
  self = [super init];
  
  if (self)
  {
    
    // booleans for all the required characteristics, tell us whether or not the characteristic loaded
    requiredCharacteristics = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                               [[NSNumber alloc] initWithBool:0], FSTCharacteristicOpalStatus,
                               [[NSNumber alloc] initWithBool:0], FSTCharacteristicOpalMode,
                               [[NSNumber alloc] initWithBool:0], FSTCharacteristicOpalLight,
                               [[NSNumber alloc] initWithBool:0], FSTCharacteristicOpalCleanCycle,
                              
                               nil];
    self.status = @0;
  }
  
  return self;
}

#pragma mark - write

-(void)writeHandler: (CBCharacteristic*)characteristic error:(NSError *)error
{
  [super writeHandler:characteristic error:error];
  
  if([[[characteristic UUID] UUIDString] isEqualToString: FSTCharacteristicOpalLight])
  {
      DLog(@"successfully wrote handleWriteNightLight");
      [self handleWriteNightLight:error];
  }
  else if([[[characteristic UUID] UUIDString] isEqualToString: FSTCharacteristicOpalMode])
  {
    DLog(@"successfully wrote handleWriteNightLight");
    [self handleWriteMode:error];
  }
}

-(void)writeNightLight: (BOOL)on
{
  CBCharacteristic* characteristic = [self.characteristics objectForKey:FSTCharacteristicOpalLight];
  
  Byte bytes[1];
  bytes[0] = on;
  
  NSData *data = [[NSData alloc]initWithBytes:bytes length:sizeof(bytes)];
  if (characteristic)
  {
    [self.peripheral writeValue:data forCharacteristic:characteristic type:CBCharacteristicWriteWithResponse];
  }
}

-(void)writeMode: (BOOL)on
{
  CBCharacteristic* characteristic = [self.characteristics objectForKey:FSTCharacteristicOpalMode];
  
  Byte bytes[1];
  bytes[0] = on;
  
  NSData *data = [[NSData alloc]initWithBytes:bytes length:sizeof(bytes)];
  if (characteristic)
  {
    [self.peripheral writeValue:data forCharacteristic:characteristic type:CBCharacteristicWriteWithResponse];
  }
}

-(void)handleWriteNightLight: (NSError *)error
{
  NSLog(@"handleWriteNightLight written");
//  if ([self.delegate respondsToSelector:@selector(nextStageSet:)])
//  {
//    [self.delegate nextStageSet:error];
//  }
//  
//  if (!error)
//  {
//    CBCharacteristic* characteristic = [self.characteristics objectForKey:FSTCharacteristicCurrentCookStage];
//    [self.peripheral readValueForCharacteristic:characteristic];
//  }
}

-(void)handleWriteMode: (NSError *)error
{
  NSLog(@"handleWriteMode written");
}

#pragma mark - read

-(void)readHandler: (CBCharacteristic*)characteristic
{
  [super readHandler:characteristic];
  
  if ([[[characteristic UUID] UUIDString] isEqualToString: FSTCharacteristicOpalStatus])
  {
    NSLog(@"char: FSTCharacteristicOpalStatus, data: %@", characteristic.value);
    [requiredCharacteristics setObject:[NSNumber numberWithBool:1] forKey:FSTCharacteristicOpalStatus];
    [self handleStatus:characteristic];
  }
  else if ([[[characteristic UUID] UUIDString] isEqualToString: FSTCharacteristicOpalMode])
  {
    NSLog(@"char: FSTCharacteristicOpalMode, data: %@", characteristic.value);
    [requiredCharacteristics setObject:[NSNumber numberWithBool:1] forKey:FSTCharacteristicOpalMode];
    [self handleMode:characteristic];
  }
  else if ([[[characteristic UUID] UUIDString] isEqualToString: FSTCharacteristicOpalLight])
  {
    NSLog(@"char: FSTCharacteristicOpalLight, data: %@", characteristic.value);
    [requiredCharacteristics setObject:[NSNumber numberWithBool:1] forKey:FSTCharacteristicOpalLight];
    [self handleLight:characteristic];
  }
  else if ([[[characteristic UUID] UUIDString] isEqualToString: FSTCharacteristicOpalCleanCycle])
  {
    NSLog(@"char: FSTCharacteristicOpalCleanCycle, data: %@", characteristic.value);
    [requiredCharacteristics setObject:[NSNumber numberWithBool:1] forKey:FSTCharacteristicOpalCleanCycle];
    [self handleCleanCycle:characteristic];
  }
  
  NSEnumerator* requiredEnum = [requiredCharacteristics keyEnumerator]; // count how many characteristics are ready
  NSInteger requiredCount = 0; // count the number of discovered characteristics
  for (NSString* characteristic in requiredEnum) {
    requiredCount += [(NSNumber*)[requiredCharacteristics objectForKey:characteristic] integerValue];
  }
  
  if (requiredCount == [requiredCharacteristics count] && self.initialCharacteristicValuesRead == NO) // found all required characteristics
  {
    //we havent informed the application that the device is completely loaded, but we have
    //all the data we need
    self.initialCharacteristicValuesRead = YES;
    
    [self notifyDeviceReady]; // logic contained in notification center
    for (NSString* requiredCharacteristic in requiredCharacteristics)
    {
      CBCharacteristic* c =[self.characteristics objectForKey:requiredCharacteristic];
      if (c.properties & CBCharacteristicPropertyNotify)
      {
        [self.peripheral setNotifyValue:YES forCharacteristic:c ];
      }
    }
  }
  else if(self.initialCharacteristicValuesRead == NO)
  {
    //we dont have all the data yet...
    // calculate fraction
    double progressCount = [[NSNumber numberWithInt:(int)requiredCount] doubleValue];
    double progressTotal = [[NSNumber numberWithInt:(int)[requiredCharacteristics count]] doubleValue];
    self.loadingProgress = [NSNumber numberWithDouble: progressCount/progressTotal];
    
    [self notifyDeviceLoadProgressUpdated];
  }
}

-(void)handleStatus: (CBCharacteristic*)characteristic
{
  if (characteristic.value.length != 1)
  {
    DLog(@"handleStatus length of %lu not what was expected, %d", (unsigned long)characteristic.value.length, 1);
    return;
  }
  
  NSData *data = characteristic.value;
  Byte bytes[characteristic.value.length] ;
  [data getBytes:bytes length:characteristic.value.length];
  self.status = [NSNumber numberWithInt:bytes[0]];
  
  if ([self.delegate respondsToSelector:@selector(iceMakerStatusChanged:)])
  {
    [self.delegate iceMakerStatusChanged:self.status];
  }
}

-(void)handleMode: (CBCharacteristic*)characteristic
{
  if (characteristic.value.length != 1)
  {
    DLog(@"handleMode length of %lu not what was expected, %d", (unsigned long)characteristic.value.length, 1);
    return;
  }
  
  NSData *data = characteristic.value;
  Byte bytes[characteristic.value.length] ;
  [data getBytes:bytes length:characteristic.value.length];
  
  self.iceMakerOn = [NSNumber numberWithInt:bytes[0]].intValue;
  
  if ([self.delegate respondsToSelector:@selector(iceMakerModeChanged:)])
  {
    [self.delegate iceMakerModeChanged:_iceMakerOn];
  }
}

-(void)handleCleanCycle: (CBCharacteristic*)characteristic
{
  if (characteristic.value.length != 1)
  {
    DLog(@"handleMode length of %lu not what was expected, %d", (unsigned long)characteristic.value.length, 1);
    return;
  }
  
  NSData *data = characteristic.value;
  Byte bytes[characteristic.value.length] ;
  [data getBytes:bytes length:characteristic.value.length];
  _cleanCycle = [NSNumber numberWithInt:bytes[0]];
  
  if ([self.delegate respondsToSelector:@selector(iceMakerCleanCycleChanged:)])
  {
    [self.delegate iceMakerCleanCycleChanged:_cleanCycle];
  }
}

-(void)handleLight: (CBCharacteristic*)characteristic
{
  if (characteristic.value.length != 1)
  {
    DLog(@"handleLight length of %lu not what was expected, %d", (unsigned long)characteristic.value.length, 1);
    return;
  }
  
  NSData *data = characteristic.value;
  Byte bytes[characteristic.value.length] ;
  [data getBytes:bytes length:characteristic.value.length];
  self.nightLightOn = [NSNumber numberWithInt:bytes[0]].intValue;
  
  
  if ([self.delegate respondsToSelector:@selector(iceMakerLightChanged:)])
  {
    [self.delegate iceMakerLightChanged:_nightLightOn];
  }
}


#pragma mark - Characteristic Discovery Handler


/**
 *  call method called when characteristics are discovered
 *
 *  @param characteristics an array of the characteristics
 */
-(void) handleDiscoverCharacteristics: (NSArray*)characteristics
{
  [super handleDiscoverCharacteristics:characteristics];
  
  self.initialCharacteristicValuesRead = NO;
  [requiredCharacteristics setObject:[NSNumber numberWithBool:0] forKey:FSTCharacteristicOpalStatus];

  NSLog(@"=======================================================================");
  //  NSLog(@"SERVICE %@", [service.UUID UUIDString]);
  
  for (CBCharacteristic *characteristic in characteristics)
  {
    [self.characteristics setObject:characteristic forKey:[characteristic.UUID UUIDString]];
    NSLog(@"    CHARACTERISTIC %@", [characteristic.UUID UUIDString]);
    
    if (characteristic.properties & CBCharacteristicPropertyWrite)
    {
      NSLog(@"        CAN WRITE");
    }
    
    if (characteristic.properties & CBCharacteristicPropertyNotify)
    {
      if  (
           [[[characteristic UUID] UUIDString] isEqualToString: FSTCharacteristicOpalStatus] ||
           [[[characteristic UUID] UUIDString] isEqualToString: FSTCharacteristicOpalMode] ||
           [[[characteristic UUID] UUIDString] isEqualToString: FSTCharacteristicOpalLight] ||
           [[[characteristic UUID] UUIDString] isEqualToString: FSTCharacteristicOpalCleanCycle]
           )
      {
        NSLog(@"reading initial value... %@", characteristic.UUID);
        [self.peripheral readValueForCharacteristic:characteristic];
      }
      NSLog(@"        CAN NOTIFY");
    }
    
    if (characteristic.properties & CBCharacteristicPropertyRead)
    {
      NSLog(@"        CAN READ");
    }
    
    if (characteristic.properties & CBCharacteristicPropertyWriteWithoutResponse)
    {
      NSLog(@"        CAN WRITE WITHOUT RESPONSE");
    }
  }
  
  NSLog(@"Characteristic discovery complete.");
}

#pragma mark - external
- (void) turnIceMakerOn: (BOOL) on {
  [self writeMode:on];
  
}

- (void) turnNightLightOn:(BOOL)on  {
  [self writeNightLight:on];
}

@end
