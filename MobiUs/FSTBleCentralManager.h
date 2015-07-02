//
//  FSTBleCentralManager.h
//  FirstBuild
//
//  Created by Myles Caley on 6/19/15.
//  Copyright (c) 2015 FirstBuild. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>

//TODO: temporarily need CBPeripheralManagerDelegate
@interface FSTBleCentralManager : NSObject <CBCentralManagerDelegate, CBPeripheralManagerDelegate>

extern NSString * const FSTBleCentralManagerDeviceFound;
extern NSString * const FSTBleCentralManagerDeviceUnFound;
extern NSString * const FSTBleCentralManagerPoweredOn;
extern NSString * const FSTBleCentralManagerPoweredOff;
extern NSString * const FSTBleCentralManagerDeviceConnected;
extern NSString * const FSTBleCentralManagerNewDeviceBound;
extern NSString * const FSTBleCentralManagerDeviceNameChanged;
extern NSString * const FSTBleCentralManagerDeviceDisconnected;

-(void)scanForDevicesWithServiceUUIDString: (NSString*)uuid;
-(void)stopScanning;
-(void)savePeripheral: (CBPeripheral*)peripheral havingUUIDString: (NSString*)uuid withName: (NSString*)name;
-(NSDictionary*)getSavedPeripherals;
-(CBPeripheral*) connectToSavedPeripheralWithUUID: (NSUUID*) uuid;
-(void)connectToNewPeripheral: (CBPeripheral*) peripheral;
-(void)deleteSavedPeripheralWithUUIDString: (NSString*) uuidString;
-(void)disconnectPeripheral: (CBPeripheral*)peripheral;
@property BOOL isPoweredOn;

+(id) sharedInstance;

@end
