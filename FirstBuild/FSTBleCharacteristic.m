//
//  FSTBleCharacteristic.m
//  FirstBuild
//
//  Created by Myles Caley on 4/25/16.
//  Copyright (c) 2015 FirstBuild. All rights reserved.
//

#import "FSTBleCharacteristic.h"

@implementation FSTBleCharacteristic

- (instancetype)initWithCBCharacteristic: (CBCharacteristic*)characteristic
{
  self = [super init];
  if (self) {
    self.bleCharacteristic = characteristic;
    self.value = characteristic.value;
    self.requiresValue = NO;
    self.wantNotification = NO;
    self.UUID = [characteristic.UUID UUIDString];
  }
  return self;
}



@end
