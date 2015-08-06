//
//  FSTBleProduct.m
//  FirstBuild
//
//  Created by Myles Caley on 6/25/15.
//  Copyright (c) 2015 FirstBuild. All rights reserved.
//

#import "FSTBleProduct.h"

@implementation FSTBleProduct

NSString * const FSTDeviceReadyNotification                 = @"FSTDeviceReadyNotification";

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

@end
