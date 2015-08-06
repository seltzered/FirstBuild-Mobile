//
//  FSTBleProduct.h
//  FirstBuild
//
//  Created by Myles Caley on 6/25/15.
//  Copyright (c) 2015 FirstBuild. All rights reserved.
//

#import "FSTProduct.h"
#import <CoreBluetooth/CoreBluetooth.h>

@interface FSTBleProduct : FSTProduct <CBPeripheralDelegate>

extern NSString * const FSTDeviceReadyNotification;

@property (strong,nonatomic) CBPeripheral* peripheral;
@property (strong,nonatomic) NSUUID* savedUuid;
@property (strong,nonatomic) NSMutableDictionary* characteristics;
@property (atomic) BOOL initialCharacteristicValuesRead;

- (void) notifyDeviceReady;

@end
