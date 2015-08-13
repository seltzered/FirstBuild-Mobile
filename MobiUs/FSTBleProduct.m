//
//  FSTBleProduct.m
//  FirstBuild
//
//  Created by Myles Caley on 6/25/15.
//  Copyright (c) 2015 FirstBuild. All rights reserved.
//

#import "FSTBleProduct.h"

@implementation FSTBleProduct

NSString * const FSTDeviceReadyNotification    = @"FSTDeviceReadyNotification";
NSString * const FSTDeviceLoadProgressUpdated  = @"FSTDeviceLoadProgressUpdated";

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.initialCharacteristicValuesRead = NO;
        self.characteristics = [[NSMutableDictionary alloc]init];
    }
    return self;
}

- (void) notifyDeviceReady
{
    [[NSNotificationCenter defaultCenter] postNotificationName:FSTDeviceReadyNotification  object:self.peripheral];
}

- (void) notifyDeviceLoadProgressUpdated
{
    [[NSNotificationCenter defaultCenter] postNotificationName:FSTDeviceLoadProgressUpdated  object:self.peripheral];
}

#pragma mark - Stub Interface Selectors
-(void)writeHandler: (CBCharacteristic*)characteristic
{
}

-(void)readHandler: (CBCharacteristic*)characteristic
{
}

-(void)handleDiscoverCharacteristics: (NSArray*)characteristics
{
}

#pragma mark - <CBPeripheralDelegate>

-(void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    [self readHandler:characteristic];
}

-(void)peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    if (error)
    {
        //TODO: what do we do if error writing characteristic?
        DLog(@"error %@, writing characteristic %@", characteristic.UUID, error);
        return;
    }
    
    [self writeHandler:characteristic];
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
    NSArray * services;
    services = [self.peripheral services];
    for (CBService *service in services)
    {
        [self.peripheral discoverCharacteristics:nil forService:service];
    }
}

-(void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error
{
    [self handleDiscoverCharacteristics: service.characteristics];
}


@end
