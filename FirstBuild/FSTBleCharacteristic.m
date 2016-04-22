//
//  FSTBleCharacteristic.m
//  FirstBuild
//
//  Created by John Nolan on 8/5/15.
//  Copyright (c) 2015 FirstBuild. All rights reserved.
//

#import "FSTBleCharacteristic.h"

@implementation FSTBleCharacteristic

- (instancetype)initWithCBCharacteristic: (CBCharacteristic*)characteristic
{
  self = [super init];
  if (self) {
    self.bleCharacteristic = characteristic;
    self.hasValue = NO;
    self.requiresValue = NO;
    self.wantNotification = NO;
  }
  return self;
}



@end
