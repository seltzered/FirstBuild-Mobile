//
//  FSTOpal.m
//  FirstBuild
//
//  Created by Myles Caley on 3/22/16.
//  Copyright © 2016 FirstBuild. All rights reserved.
//

#import "FSTOpal.h"

@implementation FSTOpal
{
  NSMutableDictionary *requiredCharacteristics; // a dictionary of strings with booleans
 
}

NSString * const FSTCharacteristicOpalStatus = @"097A2751-CA0D-432F-87B5-7D2F31E45551";
NSString * const FSTCharacteristicOpalMode = @"79994230-4B04-40CD-85C9-02DD1A8D4DD0";
NSString * const FSTCharacteristicOpalLight = @"37988F00-EA39-4A2D-9983-AFAD6535C02E";
NSString * const FSTCharacteristicOpalCleanCycle = @"EFE4BD77-0600-47D7-B3F6-DC81AF0D9AAF";
NSString * const FSTCharacteristicOpalTime = @"ED9E0784-FBF1-47F4-AFE2-D439A6C207FC";
NSString * const FSTCharacteristicOpalEnableSchedule = @"B45163B3-1092-4725-95DC-1A43AC4A9B88";
NSString * const FSTCharacteristicOpalSchedule = @"9E1AE873-CB5E-4485-9884-5C5A3AD60E47";
NSString * const FSTCharacteristicOpalError = @"5BCBF6B1-DE80-94B6-0F4B-99FB984707B6";

- (id)init
{
  self = [super init];

  if (self)
  {
    
    // booleans for all the required characteristics, tell us whether or not the characteristic loaded
    requiredCharacteristics = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                               [[NSNumber alloc] initWithBool:0], FSTCharacteristicOpalStatus,
                               [[NSNumber alloc] initWithBool:0], FSTCharacteristicOpalMode,
                               [[NSNumber alloc] initWithBool:0], FSTCharacteristicOpalLight,
                               [[NSNumber alloc] initWithBool:0], FSTCharacteristicOpalCleanCycle,
                               [[NSNumber alloc] initWithBool:0], FSTCharacteristicOpalTime,
                               [[NSNumber alloc] initWithBool:0], FSTCharacteristicOpalEnableSchedule,
                               [[NSNumber alloc] initWithBool:0], FSTCharacteristicOpalSchedule,
                               [[NSNumber alloc] initWithBool:0], FSTCharacteristicOpalError,

                               nil];
    self.status = @0;
    
    NSMutableDictionary *_1 = [@{ kTitleKey : @"Sunday",
                                  kDateKey : [NSDate date] } mutableCopy];
    NSMutableDictionary *_2 = [@{ kTitleKey : @"Monday",
                                  kDateKey : [NSDate date] } mutableCopy];
    NSMutableDictionary *_3 = [@{ kTitleKey : @"Tuesday",
                                  kDateKey : [NSDate date] } mutableCopy];
    NSMutableDictionary *_4 = [@{ kTitleKey : @"Wednesday",
                                  kDateKey : [NSDate date] } mutableCopy];
    NSMutableDictionary *_5 = [@{ kTitleKey : @"Thursday",
                                  kDateKey : [NSDate date] } mutableCopy];
    NSMutableDictionary *_6 = [@{ kTitleKey : @"Friday",
                                  kDateKey : [NSDate date] } mutableCopy];
    NSMutableDictionary *_7 = [@{ kTitleKey : @"Saturday",
                                  kDateKey : [NSDate date] } mutableCopy];
    
    self.schedule = @[_1, _2, _3, _4, _5, _6, _7];
 
  }
  
  return self;
}

#pragma mark - write

-(void)writeScheduleEnable: (BOOL)on {
  CBCharacteristic* characteristic = [self.characteristics objectForKey:FSTCharacteristicOpalEnableSchedule];
  Byte bytes[1];
  bytes[0] = on;
  
  NSData *data = [[NSData alloc]initWithBytes:bytes length:sizeof(bytes)];
  if (characteristic)
  {
    [self.peripheral writeValue:data forCharacteristic:characteristic type:CBCharacteristicWriteWithResponse];
  }
}

-(void)writeSchedule: (NSArray*) schedule {
  CBCharacteristic* characteristic = [self.characteristics objectForKey:FSTCharacteristicOpalSchedule];
  
  // written in local time
  Byte bytes[14];
  memset(bytes,0,sizeof(bytes));
  
  NSDateFormatter* hourFormatter = [[NSDateFormatter alloc] init];
  [hourFormatter setDateFormat:@"HH"];
  NSDateFormatter* minuteFormatter = [[NSDateFormatter alloc] init];
  [minuteFormatter setDateFormat:@"mm"];
  
  for (uint8_t i=0; i<=6; i++) {
    if (schedule[i]) {
      NSDictionary* element = (NSDictionary*)schedule[i];
      NSDate* time = element[@"date"];
      uint8_t hour;
      uint8_t minute;
    
      if (time) {
        hour = [[hourFormatter stringFromDate:time] intValue];
        minute = [[minuteFormatter stringFromDate:time] intValue];
      }
      else {
        hour = 0;
        minute = 0;
      }
      
      bytes[i*2] = hour;
      bytes[i*2 + 1] = minute;
      NSLog(@"element %d %d : %d", i, hour, minute);
    }
  }
  
  NSData *data = [[NSData alloc]initWithBytes:bytes length:sizeof(bytes)];
  
  if (characteristic)
  {
    [self.peripheral writeValue:data forCharacteristic:characteristic type:CBCharacteristicWriteWithResponse];
  }
}

-(void)writeCurrentTime {
  
  CBCharacteristic* characteristic = [self.characteristics objectForKey:FSTCharacteristicOpalTime];
  
  //
  //  Need to write in the following format...
  //
  //  bytes[0] = 0x32;
  //  bytes[1] = 0xe3;
  //  bytes[2] = 0xf3;
  //  bytes[3] = 0x56;
    
  //  result = 196519986
  //  
  //  56f3e332 = 1458823986
  //  
  //  1458823986 - 1262304000 (40 years) = 196519986
  //  uint32_t val = ((bytes[3] << 24) + (bytes[2] << 16) + (bytes[1] << 8) + bytes[0]) - 1262304000;
  //  
  //  NSLog(@"time that should match broadcom print %d", val);
  //  GMT: Thu, 24 Mar 2016 12:53:06 GMT <<<< 12:53
  //  Your time zone: 3/24/2016, 8:53:06 AM GMT-4:00 DST

  
  uint32_t secondsSince1970 = (uint32_t)[[NSDate date]timeIntervalSince1970] + (int32_t)[[NSTimeZone systemTimeZone] secondsFromGMT];
  NSLog(@"current date: %d", secondsSince1970);
  
  NSMutableData *data = [[NSMutableData alloc] initWithBytes:&secondsSince1970 length:sizeof(uint32_t)];
  if (characteristic)
  {
    [self.peripheral writeValue:data forCharacteristic:characteristic type:CBCharacteristicWriteWithResponse];
  }
  
}

-(void)writeNightLight: (BOOL)on
{
  CBCharacteristic* characteristic = [self.characteristics objectForKey:FSTCharacteristicOpalLight];
  
  Byte bytes[1];
  bytes[0] = on;
  
  NSData *data = [[NSData alloc]initWithBytes:bytes length:sizeof(bytes)];
  if (characteristic)
  {
    [self.peripheral writeValue:data forCharacteristic:characteristic type:CBCharacteristicWriteWithResponse];
  }
}

-(void)writeMode: (BOOL)on
{
  CBCharacteristic* characteristic = [self.characteristics objectForKey:FSTCharacteristicOpalMode];
  
  Byte bytes[1];
  bytes[0] = on;
  
  NSData *data = [[NSData alloc]initWithBytes:bytes length:sizeof(bytes)];
  if (characteristic)
  {
    [self.peripheral writeValue:data forCharacteristic:characteristic type:CBCharacteristicWriteWithResponse];
  }
}

#pragma mark - write handlers

-(void)writeHandler: (CBCharacteristic*)characteristic error:(NSError *)error
{
  [super writeHandler:characteristic error:error];
  
  if([[[characteristic UUID] UUIDString] isEqualToString: FSTCharacteristicOpalLight])
  {
      DLog(@"successfully wrote FSTCharacteristicOpalLight");
      [self handleNightLightWrite:error];
  }
  else if([[[characteristic UUID] UUIDString] isEqualToString: FSTCharacteristicOpalMode])
  {
    DLog(@"successfully wrote FSTCharacteristicOpalMode");
    [self handleModeWrite:error];
  }
  else if([[[characteristic UUID] UUIDString] isEqualToString: FSTCharacteristicOpalTime])
  {
    DLog(@"successfully wrote FSTCharacteristicOpalTime");
    [self handleTimeWrite:error];
  }
  else if([[[characteristic UUID] UUIDString] isEqualToString: FSTCharacteristicOpalEnableSchedule])
  {
    DLog(@"successfully wrote FSTCharacteristicOpalEnableSchedule");
    [self handleScheduleEnabledWrite:error];
  }
  else if([[[characteristic UUID] UUIDString] isEqualToString: FSTCharacteristicOpalSchedule])
  {
    DLog(@"successfully wrote FSTCharacteristicOpalSchedule");
    [self handleScheduleWrite:error];
  }

}


-(void)handleNightLightWrite: (NSError *)error
{
  NSLog(@"handleWriteNightLight written");
  if ([self.delegate respondsToSelector:@selector(iceMakerNightLightWritten:)])
  {
    [self.delegate iceMakerNightLightWritten:error];
  }
 
  // read the characteristic again, even if there is an error, this will force the correct state for app
  // and in particular the ui switch in the opal views... too tight of coupling, yes.
  CBCharacteristic* characteristic = [self.characteristics objectForKey:FSTCharacteristicOpalLight];
  [self.peripheral readValueForCharacteristic:characteristic];
  
}

-(void)handleModeWrite: (NSError *)error
{
  NSLog(@"handleWriteMode written");
}

-(void)handleScheduleWrite: (NSError *)error
{
  NSLog(@"handleWriteMode written");
  CBCharacteristic* characteristic = [self.characteristics objectForKey:FSTCharacteristicOpalSchedule];
  [self.peripheral readValueForCharacteristic:characteristic];
}

-(void)handleScheduleEnabledWrite: (NSError *)error
{
  NSLog(@"handleWriteScheduleEnabled written");
  if ([self.delegate respondsToSelector:@selector(iceMakerScheduleEnabledWritten:)])
  {
    [self.delegate iceMakerScheduleEnabledWritten:error];
  }
  
  // read the characteristic again, even if there is an error, this will force the correct state for app
  // and in particular the ui switch in the opal views... too tight of coupling, yes.
  CBCharacteristic* characteristic = [self.characteristics objectForKey:FSTCharacteristicOpalEnableSchedule];
  [self.peripheral readValueForCharacteristic:characteristic];
}

-(void)handleTimeWrite: (NSError *)error
{
  NSLog(@"handleWriteTime written");
  CBCharacteristic* timeCharacteristic = [self.characteristics objectForKey:FSTCharacteristicOpalTime];
  [self.peripheral readValueForCharacteristic:timeCharacteristic];
  
}

#pragma mark - read handlers


-(void)readHandler: (CBCharacteristic*)characteristic
{
  [super readHandler:characteristic];
  
  if ([[[characteristic UUID] UUIDString] isEqualToString: FSTCharacteristicOpalStatus])
  {
    NSLog(@"char: FSTCharacteristicOpalStatus, data: %@", characteristic.value);
    [requiredCharacteristics setObject:[NSNumber numberWithBool:1] forKey:FSTCharacteristicOpalStatus];
    [self handleStatusRead:characteristic];
  }
  else if ([[[characteristic UUID] UUIDString] isEqualToString: FSTCharacteristicOpalMode])
  {
    NSLog(@"char: FSTCharacteristicOpalMode, data: %@", characteristic.value);
    [requiredCharacteristics setObject:[NSNumber numberWithBool:1] forKey:FSTCharacteristicOpalMode];
    [self handleModeRead:characteristic];
  }
  else if ([[[characteristic UUID] UUIDString] isEqualToString: FSTCharacteristicOpalLight])
  {
    NSLog(@"char: FSTCharacteristicOpalLight, data: %@", characteristic.value);
    [requiredCharacteristics setObject:[NSNumber numberWithBool:1] forKey:FSTCharacteristicOpalLight];
    [self handleLightRead:characteristic];
  }
  else if ([[[characteristic UUID] UUIDString] isEqualToString: FSTCharacteristicOpalCleanCycle])
  {
    NSLog(@"char: FSTCharacteristicOpalCleanCycle, data: %@", characteristic.value);
    [requiredCharacteristics setObject:[NSNumber numberWithBool:1] forKey:FSTCharacteristicOpalCleanCycle];
    [self handleCleanCycleRead:characteristic];
  }
  else if ([[[characteristic UUID] UUIDString] isEqualToString: FSTCharacteristicOpalTime])
  {
    NSLog(@"char: FSTCharacteristicOpalTime, data: %@", characteristic.value);
    [requiredCharacteristics setObject:[NSNumber numberWithBool:1] forKey:FSTCharacteristicOpalTime];
    [self handleTimeRead:characteristic];
  }
  else if ([[[characteristic UUID] UUIDString] isEqualToString: FSTCharacteristicOpalEnableSchedule])
  {
    NSLog(@"char: FSTCharacteristicOpalEnableSchedule, data: %@", characteristic.value);
    [requiredCharacteristics setObject:[NSNumber numberWithBool:1] forKey:FSTCharacteristicOpalEnableSchedule];
    [self handleScheduleEnableRead:characteristic];
  }
  else if ([[[characteristic UUID] UUIDString] isEqualToString: FSTCharacteristicOpalSchedule])
  {
    NSLog(@"char: FSTCharacteristicOpalSchedule, data: %@", characteristic.value);
    [requiredCharacteristics setObject:[NSNumber numberWithBool:1] forKey:FSTCharacteristicOpalSchedule];
    [self handleScheduleRead:characteristic];
  }
  else if ([[[characteristic UUID] UUIDString] isEqualToString: FSTCharacteristicOpalError])
  {
//    NSLog(@"char: FSTCharacteristicOpalError, data: %@", characteristic.value);
    [requiredCharacteristics setObject:[NSNumber numberWithBool:1] forKey:FSTCharacteristicOpalError];
    [self handleErrorRead:characteristic];
  }
  
  NSEnumerator* requiredEnum = [requiredCharacteristics keyEnumerator]; // count how many characteristics are ready
  NSInteger requiredCount = 0; // count the number of discovered characteristics
  for (NSString* characteristic in requiredEnum) {
    requiredCount += [(NSNumber*)[requiredCharacteristics objectForKey:characteristic] integerValue];
  }
  
  if (requiredCount == [requiredCharacteristics count] && self.initialCharacteristicValuesRead == NO) // found all required characteristics
  {
    //we havent informed the application that the device is completely loaded, but we have
    //all the data we need
    self.initialCharacteristicValuesRead = YES;
    
    [self notifyDeviceReady]; // logic contained in notification center
    
    //TEMP
    [self startOta];
    
    for (NSString* requiredCharacteristic in requiredCharacteristics)
    {
      CBCharacteristic* c =[self.characteristics objectForKey:requiredCharacteristic];
      if (c.properties & CBCharacteristicPropertyNotify)
      {
        [self.peripheral setNotifyValue:YES forCharacteristic:c ];
      }
    }
  }
  else if(self.initialCharacteristicValuesRead == NO)
  {
    //we dont have all the data yet...
    // calculate fraction
    double progressCount = [[NSNumber numberWithInt:(int)requiredCount] doubleValue];
    double progressTotal = [[NSNumber numberWithInt:(int)[requiredCharacteristics count]] doubleValue];
    self.loadingProgress = [NSNumber numberWithDouble: progressCount/progressTotal];
    
    [self notifyDeviceLoadProgressUpdated];
  }
}

-(void)handleTimeRead: (CBCharacteristic*)characteristic
{
  if (characteristic.value.length != 4)
  {
    DLog(@"handleTime length of %lu not what was expected, %d", (unsigned long)characteristic.value.length, 4);
    return;
  }
}

// TODO: make this a component
-(NSDate *) dateWithHour:(NSInteger)hour
                  minute:(NSInteger)minute
                  second:(NSInteger)second
{
  NSCalendar *calendar = [NSCalendar currentCalendar];
  NSDateComponents *components = [calendar components: NSCalendarUnitYear|
                                  NSCalendarUnitMonth|
                                  NSCalendarUnitDay
                                             fromDate:[NSDate date]];
  [components setHour:hour];
  [components setMinute:minute];
  [components setSecond:second];
  NSDate *newDate = [calendar dateFromComponents:components];
  return newDate;
}

-(void)handleScheduleRead: (CBCharacteristic*)characteristic
{
  if (characteristic.value.length != 14)
  {
    DLog(@"handleSchedule length of %lu not what was expected, %d", (unsigned long)characteristic.value.length, 14);
    return;
  }
  
  NSData *data = characteristic.value;
  Byte bytes[characteristic.value.length] ;
  [data getBytes:bytes length:characteristic.value.length];
  
  for (uint8_t i=0; i<=6; i++) {
    //if (bytes[i]) {
      NSMutableDictionary* element = (NSMutableDictionary*)self.schedule[i];
      uint8_t hour = bytes[i*2];
      uint8_t minute = bytes[i*2 + 1];
      
      NSDate* date = [self dateWithHour:hour minute:minute second:0];
      element[kDateKey] = date;
      
      switch (i) {
        case 0 :
          [element setValue:@"Sunday" forKey:kTitleKey];
          break;
        case 1 :
          [element setValue:@"Monday" forKey:kTitleKey];
          break;
        case 2 :
          [element setValue:@"Tuesday" forKey:kTitleKey];
          break;
        case 3 :
          [element setValue:@"Wednesday" forKey:kTitleKey];
          break;
        case 4:
          [element setValue:@"Thursday" forKey:kTitleKey];
          break;
        case 5:
          [element setValue:@"Friday" forKey:kTitleKey];
          break;
        case 6:
          [element setValue:@"Saturday" forKey:kTitleKey];
          break;
      }
      
      NSLog(@"schedule read %d %@ : %@", i, element[kTitleKey], element[kDateKey]);
    //}
  }
  
}

-(void)handleScheduleEnableRead: (CBCharacteristic*)characteristic
{
  if (characteristic.value.length != 1)
  {
    DLog(@"handleScheduleEnable length of %lu not what was expected, %d", (unsigned long)characteristic.value.length, 1);
    return;
  }
  
  NSData *data = characteristic.value;
  Byte bytes[characteristic.value.length] ;
  [data getBytes:bytes length:characteristic.value.length];
  
  self.scheduleEnabled = [NSNumber numberWithInt:bytes[0]].intValue;
  
  if ([self.delegate respondsToSelector:@selector(iceMakerScheduleEnabledChanged:)])
  {
    [self.delegate iceMakerScheduleEnabledChanged:_scheduleEnabled];
  }
}

-(void)handleErrorRead: (CBCharacteristic*)characteristic
{
  if (characteristic.value.length != 1)
  {
    DLog(@"handleError length of %lu not what was expected, %d", (unsigned long)characteristic.value.length, 1);
    return;
  }
  
  NSData *data = characteristic.value;
  Byte bytes[characteristic.value.length] ;
  [data getBytes:bytes length:characteristic.value.length];
}

-(void)handleStatusRead: (CBCharacteristic*)characteristic
{
  if (characteristic.value.length != 1)
  {
    DLog(@"handleStatus length of %lu not what was expected, %d", (unsigned long)characteristic.value.length, 1);
    return;
  }
  
  NSData *data = characteristic.value;
  Byte bytes[characteristic.value.length] ;
  [data getBytes:bytes length:characteristic.value.length];
  self.status = [NSNumber numberWithInt:bytes[0]];
  self.statusLabel = [self getLabelForStatus:bytes[0]];
  
  if ([self.delegate respondsToSelector:@selector(iceMakerStatusChanged:withLabel:)])
  {
    [self.delegate iceMakerStatusChanged:self.status withLabel:self.statusLabel];
  }
}


- (NSString*) getLabelForStatus: (uint8_t)status {
  switch (status) {
    case 0:
      return @"idle";
      break;
      
    case 1:
      return @"ice making";
      break;
      
    case 2:
      return @"add water";
      break;
      
    case 3:
      return @"ice full";
      break;
      
    case 4:
      return @"cleaning";
      break;
      
    default:
      return @"...";
      break;
  }
}

-(void)handleModeRead: (CBCharacteristic*)characteristic
{
  if (characteristic.value.length != 1)
  {
    DLog(@"handleMode length of %lu not what was expected, %d", (unsigned long)characteristic.value.length, 1);
    return;
  }
  
  NSData *data = characteristic.value;
  Byte bytes[characteristic.value.length] ;
  [data getBytes:bytes length:characteristic.value.length];
  
  self.iceMakerOn = [NSNumber numberWithInt:bytes[0]].intValue;
  
  if ([self.delegate respondsToSelector:@selector(iceMakerModeChanged:)])
  {
    [self.delegate iceMakerModeChanged:_iceMakerOn];
  }
}

-(void)handleCleanCycleRead: (CBCharacteristic*)characteristic
{
  if (characteristic.value.length != 1)
  {
    DLog(@"handleMode length of %lu not what was expected, %d", (unsigned long)characteristic.value.length, 1);
    return;
  }
  
  NSData *data = characteristic.value;
  Byte bytes[characteristic.value.length] ;
  [data getBytes:bytes length:characteristic.value.length];
  _cleanCycle = [NSNumber numberWithInt:bytes[0]];
  
  if ([self.delegate respondsToSelector:@selector(iceMakerCleanCycleChanged:)])
  {
    [self.delegate iceMakerCleanCycleChanged:_cleanCycle];
  }
}

-(void)handleLightRead: (CBCharacteristic*)characteristic
{
  if (characteristic.value.length != 1)
  {
    DLog(@"handleLight length of %lu not what was expected, %d", (unsigned long)characteristic.value.length, 1);
    return;
  }
  
  NSData *data = characteristic.value;
  Byte bytes[characteristic.value.length] ;
  [data getBytes:bytes length:characteristic.value.length];
  self.nightLightOn = [NSNumber numberWithInt:bytes[0]].intValue;
  
  
  if ([self.delegate respondsToSelector:@selector(iceMakerLightChanged:)])
  {
    [self.delegate iceMakerLightChanged:_nightLightOn];
  }
}


#pragma mark - Characteristic Discovery Handler


/**
 *  call method called when characteristics are discovered
 *
 *  @param characteristics an array of the characteristics
 */
-(void) handleDiscoverCharacteristics: (NSArray*)characteristics
{
  [super handleDiscoverCharacteristics:characteristics];
  
  self.initialCharacteristicValuesRead = NO;
  [requiredCharacteristics setObject:[NSNumber numberWithBool:0] forKey:FSTCharacteristicOpalStatus];

  NSLog(@"=======================================================================");
  //  NSLog(@"SERVICE %@", [service.UUID UUIDString]);
  
  for (CBCharacteristic *characteristic in characteristics)
  {
    [self.characteristics setObject:characteristic forKey:[characteristic.UUID UUIDString]];
    NSLog(@"    CHARACTERISTIC %@", [characteristic.UUID UUIDString]);
    
    if (characteristic.properties & CBCharacteristicPropertyWrite)
    {
      NSLog(@"        CAN WRITE");
    }
    
    if (characteristic.properties & CBCharacteristicPropertyNotify)
    {
      if  (
           [[[characteristic UUID] UUIDString] isEqualToString: FSTCharacteristicOpalStatus] ||
           [[[characteristic UUID] UUIDString] isEqualToString: FSTCharacteristicOpalMode] ||
           [[[characteristic UUID] UUIDString] isEqualToString: FSTCharacteristicOpalLight] ||
           [[[characteristic UUID] UUIDString] isEqualToString: FSTCharacteristicOpalCleanCycle]
           )
      {
        NSLog(@"reading initial value ... %@", characteristic.UUID);
        [self.peripheral readValueForCharacteristic:characteristic];
      }
      NSLog(@"        CAN NOTIFY");
    }
    
    if (characteristic.properties & CBCharacteristicPropertyRead)
    {
      if ([[[characteristic UUID] UUIDString] isEqualToString: FSTCharacteristicOpalTime])
      {
        // whenever we first connect send the current time
        [self writeCurrentTime];
      }
      else if ([[[characteristic UUID] UUIDString] isEqualToString: FSTCharacteristicOpalSchedule] ||
               [[[characteristic UUID] UUIDString] isEqualToString: FSTCharacteristicOpalEnableSchedule] ||
               [[[characteristic UUID] UUIDString] isEqualToString: FSTCharacteristicOpalError])
      {
        NSLog(@"reading initial value. (no subscribe).. %@", characteristic.UUID);
        [self.peripheral readValueForCharacteristic:characteristic];
      }
      NSLog(@"        CAN READ");
    }
    
    if (characteristic.properties & CBCharacteristicPropertyWriteWithoutResponse)
    {
      NSLog(@"        CAN WRITE WITHOUT RESPONSE");
    }
  }
  
  NSLog(@"Characteristic discovery complete.");
}

#pragma mark - external
- (void) turnIceMakerOn: (BOOL) on {
  [self writeMode:on];
  
}

- (void) turnNightLightOn:(BOOL)on  {
  [self writeNightLight:on];
}

- (void) turnIceMakerScheduleOn:(BOOL)on  {
  [self writeScheduleEnable:on];
}

- (void) configureSchedule: (NSArray*) schedule {
  [self writeSchedule:schedule];
}

@end
