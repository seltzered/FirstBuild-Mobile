//
//  FSTBleCharacteristic.h
//  FirstBuild
//
//  simple wrapper for ble characteristic with some additional annotations to facilite
//  state of the characteristic
//
//  Created by Myles Caley on 4/25/16.
//  Copyright (c) 2015 FirstBuild. All rights reserved.
//


#import <CoreBluetooth/CoreBluetooth.h>

@interface FSTBleCharacteristic : NSObject

@property (nonatomic, strong) CBCharacteristic* bleCharacteristic;

// helper to save the hassle of calling the UUIDString method
@property (nonatomic, strong) NSString* UUID;

// is the characteristic required in order for the app to be functional
@property BOOL requiresValue;

// if required does it have its initial value
@property BOOL hasInitialValue;

// characteristics value pointer
@property (nonatomic, strong) NSData* value;

// should the characteristic be auto subscribed
@property BOOL wantNotification;

// method to force a reading of a characteristic at a set interval. this can be used in lieu of notifications in case you want
// to restrict how often the data is read or if the characteristic doesnt support notifications
-(void) pollWithInterval: (NSTimeInterval) interval;
-(void) unpoll;


- (instancetype)initWithCBCharacteristic: (CBCharacteristic*)characteristic onPeripheral: (CBPeripheral*) peripheral;

@end
