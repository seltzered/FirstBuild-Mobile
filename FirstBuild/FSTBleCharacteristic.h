//
//  FSTBleCharacteristic.h
//  FirstBuild
//
//  Created by John Nolan on 8/5/15.
//  Copyright (c) 2015 FirstBuild. All rights reserved.
//

#import <CoreBluetooth/CoreBluetooth.h>

@interface FSTBleCharacteristic : NSObject

@property (nonatomic, strong) CBCharacteristic* bleCharacteristic;
@property BOOL requiresValue;
@property BOOL hasValue;
@property BOOL wantNotification;

- (instancetype)initWithCBCharacteristic: (CBCharacteristic*)characteristic;


@end
