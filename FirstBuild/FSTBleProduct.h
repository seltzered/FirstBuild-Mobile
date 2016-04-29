//
//  FSTBleProduct.h
//  FirstBuild
//
//  Created by Myles Caley on 6/25/15.
//  Copyright (c) 2015 FirstBuild. All rights reserved.
//

#import "FSTProduct.h"
#import "FSTBleCharacteristic.h"
#import <CoreBluetooth/CoreBluetooth.h>

@interface FSTBleProduct : FSTProduct <CBPeripheralDelegate>

extern NSString * const FSTDeviceReadyNotification;
extern NSString * const FSTDeviceLoadProgressUpdated;
extern NSString * const FSTDeviceEssentialDataChangedNotification;
extern NSString * const FSTBatteryLevelChangedNotification;

@property (strong,nonatomic) CBPeripheral* peripheral;
@property (strong,nonatomic) NSUUID* savedUuid;
@property (strong,nonatomic) NSMutableDictionary* characteristics;
@property (nonatomic, strong) NSNumber* batteryLevel;
@property (nonatomic, strong) NSNumber* loadingProgress;
@property (nonatomic, strong) NSString* serialNumber;
@property (nonatomic, strong) NSString* modelNumber;


- (void) deviceReady;
- (void) notifyDeviceLoadProgressUpdated;
- (void) notifyDeviceEssentialDataChanged;
- (void) writeHandler: (FSTBleCharacteristic*)characteristic error:(NSError *)error;
- (void) readHandler: (FSTBleCharacteristic*)characteristic;
- (void) handleDiscoverCharacteristics: (NSArray*)characteristics;
- (void) writeFstBleCharacteristic: (FSTBleCharacteristic*)characteristic withValue: (NSData*)data;
- (void) readFstBleCharacteristic: (FSTBleCharacteristic*)characteristic;


@end
