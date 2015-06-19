//
//  FSTBleCentralManager.m
//  FirstBuild
//
//  Created by Myles Caley on 6/19/15.
//  Copyright (c) 2015 FirstBuild. All rights reserved.
//

#import "FSTBleCentralManager.h"

@implementation FSTBleCentralManager

CBCentralManager* _centralManager;
CBPeripheralManager * _peripheralManager; //temporary

- (instancetype)init
{
    self = [super init];
    if (self) {
        //TODO
        //temporary hack for BLE ACM
        //this startup then triggers the central manager initialization. once the service
        //callback check is removed we need to start the central manager here instead of in peripheralManagerDidUpdateState
       
        _peripheralManager = [[CBPeripheralManager alloc] initWithDelegate:self queue:nil];
    }
    return self;
}

#pragma mark - External Methods

-(void)connectToSavedPeripheralWithName: (NSString*)name
{
    if (name && name.length > 0)
    {
        NSString *keyname =[NSString stringWithFormat:@"%@%@", @"ble-devices-", name];
        
        if (_centralManager.state == CBCentralManagerStatePoweredOn)
        {
            NSUUID * identifier = [[NSUUID alloc] initWithUUIDString:[[NSUserDefaults standardUserDefaults] objectForKey:keyname]];
            NSArray* results = [_centralManager retrievePeripheralsWithIdentifiers:[[NSArray alloc] initWithObjects:identifier, nil]];
            if (results[0])
            {
                [_centralManager connectPeripheral:results[0] options:nil];
            }
        }
    }
}

-(void)savePeripheralHavingUUID: (NSUUID*)uuid withName: (NSString*)name
{
    if (name && name.length > 0)
    {
        NSString *keyname =[NSString stringWithFormat:@"%@%@", @"ble-devices-", name];
        [[NSUserDefaults standardUserDefaults] setObject:[uuid UUIDString] forKey:keyname];
    }
}

-(void)scanForDevicesWithServiceUUID: (NSUUID*)uuid
{
    if (_centralManager.state == CBCentralManagerStatePoweredOn)
    {
        [_centralManager scanForPeripheralsWithServices:[NSArray arrayWithObject:uuid] options:nil];
    }
}

#pragma mark - Central Delegate

- (void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    if (central.state != CBCentralManagerStatePoweredOn) {
        DLog("central state changed, nothing to do %ld", (long)central.state);
        return;
    }
    
    if (central.state == CBCentralManagerStatePoweredOn) {
        DLog(@"central powered on");
    }
}

- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    
}

-(void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    
}

-(void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI
{
    
}

-(void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
{
    
}

-(void)centralManager:(CBCentralManager *)central didRetrieveConnectedPeripherals:(NSArray *)peripherals
{
    
}

-(void)centralManager:(CBCentralManager *)central didRetrievePeripherals:(NSArray *)peripherals
{
    
}

#pragma mark - Peripheral Delegate - temporary
- (void)peripheralManagerDidUpdateState:(CBPeripheralManager *)peripheral {
    DLog(@"peripheralManagerDidUpdateState : %@", peripheral);
    if (peripheral.state != CBPeripheralManagerStatePoweredOn) {
                return;
    }
    
    if (peripheral.state == CBPeripheralManagerStatePoweredOn) {
        _centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
        
        CBMutableService *service = [[CBMutableService alloc] initWithType:[CBUUID UUIDWithString:@"0db95663-c52e-2fac-2040-c276b2b63090"] primary:YES];
        
        [_peripheralManager addService:service];
        [_peripheralManager startAdvertising:nil];
    }
}


@end
