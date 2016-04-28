//
//  FSTBleCharacteristic.m
//  FirstBuild
//
//  Created by Myles Caley on 4/25/16.
//  Copyright (c) 2015 FirstBuild. All rights reserved.
//

#import "FSTBleCharacteristic.h"

@implementation FSTBleCharacteristic
{
  NSMutableDictionary* _timers;
  CBPeripheral* _peripheral;
}

- (instancetype)initWithCBCharacteristic: (CBCharacteristic*)characteristic onPeripheral: (CBPeripheral*) peripheral
{
  self = [super init];
  if (self) {
    self.bleCharacteristic = characteristic;
    self.value = characteristic.value;
    self.requiresValue = NO;
    self.wantNotification = NO;
    self.UUID = [characteristic.UUID UUIDString];
    _timers = [[NSMutableDictionary alloc]init];
    _peripheral = peripheral;
  }
  return self;
}

-(void) pollWithInterval: (NSTimeInterval) interval
{
  if ([_timers objectForKey:self.UUID] != nil) {
    [self unpoll];
  }
  NSTimer* timer = [NSTimer scheduledTimerWithTimeInterval:interval target:self selector:@selector(readCharacteristic:) userInfo:self repeats:YES];
  
  [_timers setObject:timer forKey:self.UUID];
}

-(void) unpoll
{
  NSTimer* timer  = [_timers objectForKey:self.UUID];
  [timer invalidate];
  timer = nil;
  [_timers removeObjectForKey:self.UUID];
}

-(void)readCharacteristic: (NSTimer*)timer
{
  CBCharacteristic* characteristic = ((FSTBleCharacteristic*)timer.userInfo).bleCharacteristic;
  [_peripheral readValueForCharacteristic:characteristic];
}


@end
