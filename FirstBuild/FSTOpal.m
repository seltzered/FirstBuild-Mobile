//
//  FSTOpal.m
//  FirstBuild
//
//  Created by Myles Caley on 3/22/16.
//  Copyright © 2016 FirstBuild. All rights reserved.
//

#import "FSTOpal.h"
#import "UIAlertView+Blocks.h"
#import "Ota.h"

@implementation FSTOpal
{ 
}

NSString * const FSTCharacteristicOpalStatus = @"097A2751-CA0D-432F-87B5-7D2F31E45551";
NSString * const FSTCharacteristicOpalMode = @"79994230-4B04-40CD-85C9-02DD1A8D4DD0";
NSString * const FSTCharacteristicOpalLight = @"37988F00-EA39-4A2D-9983-AFAD6535C02E";
NSString * const FSTCharacteristicOpalCleanCycle = @"EFE4BD77-0600-47D7-B3F6-DC81AF0D9AAF";
NSString * const FSTCharacteristicOpalTime = @"ED9E0784-FBF1-47F4-AFE2-D439A6C207FC";
NSString * const FSTCharacteristicOpalEnableSchedule = @"B45163B3-1092-4725-95DC-1A43AC4A9B88";
NSString * const FSTCharacteristicOpalSchedule = @"9E1AE873-CB5E-4485-9884-5C5A3AD60E47";
NSString * const FSTCharacteristicOpalError = @"5BCBF6B1-DE80-94B6-0F4B-99FB984707B6";

NSString * const FSTCharacteristicOpalLogIndex = @"1F122C31-D1EA-447D-8409-56196DF130D2";
NSString * const FSTCharacteristicOpalLog0 = @"1CE417B2-5BE0-4D4F-99C6-4086F49AE901";
NSString * const FSTCharacteristicOpalLog6 = @"352DDEA3-79F7-410F-B5B5-4D3F96DC510D";

- (id)init
{
  self = [super init];

  if (self)
  {
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
    
    self.availableBleVersion = OPAL_BLE_AVAILABLE_VERSION;
    self.availableAppVersion = OPAL_APP_AVAILABLE_VERSION;
 
  }
  
  return self;
}

#pragma mark - write

-(void)writeScheduleEnable: (BOOL)on {
  FSTBleCharacteristic* characteristic = [self.characteristics objectForKey:FSTCharacteristicOpalEnableSchedule];
  Byte bytes[1];
  bytes[0] = on;
  
  NSData *data = [[NSData alloc]initWithBytes:bytes length:sizeof(bytes)];
  if (characteristic)
  {
    [self writeFstBleCharacteristic:characteristic withValue:data];
  }
}

-(void)writeSchedule: (NSArray*) schedule {
  FSTBleCharacteristic* characteristic = [self.characteristics objectForKey:FSTCharacteristicOpalSchedule];
  
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
    [self writeFstBleCharacteristic:characteristic withValue:data];
  }
}

-(void)writeCurrentTime {
  
  FSTBleCharacteristic* characteristic = [self.characteristics objectForKey:FSTCharacteristicOpalTime];
  
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
    [self writeFstBleCharacteristic:characteristic withValue:data];
  }
  
}

-(void)writeNightLight: (BOOL)on
{
  FSTBleCharacteristic* characteristic = [self.characteristics objectForKey:FSTCharacteristicOpalLight];
  
  Byte bytes[1];
  bytes[0] = on;
  
  NSData *data = [[NSData alloc]initWithBytes:bytes length:sizeof(bytes)];
  if (characteristic)
  {
    [self writeFstBleCharacteristic:characteristic withValue:data];
  }
}

-(void)writeMode: (BOOL)on
{
  FSTBleCharacteristic* characteristic = [self.characteristics objectForKey:FSTCharacteristicOpalMode];
  
  Byte bytes[1];
  bytes[0] = on;
  
  NSData *data = [[NSData alloc]initWithBytes:bytes length:sizeof(bytes)];
  if (characteristic)
  {
    [self writeFstBleCharacteristic:characteristic withValue:data];
  }
}

#pragma mark - write handlers

-(void)writeHandler: (FSTBleCharacteristic*)characteristic error:(NSError *)error
{
  [super writeHandler:characteristic error:error];
  
  if([characteristic.UUID isEqualToString: FSTCharacteristicOpalLight])
  {
      DLog(@"wrote FSTCharacteristicOpalLight");
      [self handleNightLightWrite:error];
  }
  else if([characteristic.UUID isEqualToString: FSTCharacteristicOpalMode])
  {
    DLog(@"wrote FSTCharacteristicOpalMode");
    [self handleModeWrite:error];
  }
  else if([characteristic.UUID isEqualToString: FSTCharacteristicOpalTime])
  {
    DLog(@"wrote FSTCharacteristicOpalTime");
    [self handleTimeWrite:error];
  }
  else if([characteristic.UUID isEqualToString: FSTCharacteristicOpalEnableSchedule])
  {
    DLog(@"wrote FSTCharacteristicOpalEnableSchedule");
    [self handleScheduleEnabledWrite:error];
  }
  else if([characteristic.UUID isEqualToString: FSTCharacteristicOpalSchedule])
  {
    DLog(@"wrote FSTCharacteristicOpalSchedule");
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
  FSTBleCharacteristic* characteristic = [self.characteristics objectForKey:FSTCharacteristicOpalLight];
  [self readFstBleCharacteristic:characteristic];
  
  
}

-(void)handleModeWrite: (NSError *)error
{
  NSLog(@"handleWriteMode written");
}

-(void)handleScheduleWrite: (NSError *)error
{
  NSLog(@"handleWriteMode written");
  FSTBleCharacteristic* characteristic = [self.characteristics objectForKey:FSTCharacteristicOpalSchedule];
  [self readFstBleCharacteristic:characteristic];
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
  FSTBleCharacteristic* characteristic = [self.characteristics objectForKey:FSTCharacteristicOpalEnableSchedule];
  [self readFstBleCharacteristic:characteristic];
}

-(void)handleTimeWrite: (NSError *)error
{
  NSLog(@"handleWriteTime written");
  FSTBleCharacteristic* timeCharacteristic = [self.characteristics objectForKey:FSTCharacteristicOpalTime];
  [self readFstBleCharacteristic:timeCharacteristic];
}

#pragma mark - read handlers

-(void)readHandler: (FSTBleCharacteristic*)characteristic
{
  [super readHandler:characteristic];
  
  if ([characteristic.UUID isEqualToString: FSTCharacteristicOpalStatus])
  {
    NSLog(@"char: FSTCharacteristicOpalStatus, data: %@", characteristic.value);
    [self handleStatusRead:characteristic];
  }
  else if ([characteristic.UUID isEqualToString: FSTCharacteristicOpalMode])
  {
    NSLog(@"char: FSTCharacteristicOpalMode, data: %@", characteristic.value);
    [self handleModeRead:characteristic];
  }
  else if ([characteristic.UUID isEqualToString: FSTCharacteristicOpalLight])
  {
    NSLog(@"char: FSTCharacteristicOpalLight, data: %@", characteristic.value);
    [self handleLightRead:characteristic];
  }
  else if ([characteristic.UUID isEqualToString: FSTCharacteristicOpalCleanCycle])
  {
    NSLog(@"char: FSTCharacteristicOpalCleanCycle, data: %@", characteristic.value);
    [self handleCleanCycleRead:characteristic];
  }
  else if ([characteristic.UUID isEqualToString: FSTCharacteristicOpalTime])
  {
    NSLog(@"char: FSTCharacteristicOpalTime, data: %@", characteristic.value);
    [self handleTimeRead:characteristic];
  }
  else if ([characteristic.UUID isEqualToString: FSTCharacteristicOpalEnableSchedule])
  {
    NSLog(@"char: FSTCharacteristicOpalEnableSchedule, data: %@", characteristic.value);
    [self handleScheduleEnableRead:characteristic];
  }
  else if ([characteristic.UUID isEqualToString: FSTCharacteristicOpalSchedule])
  {
    NSLog(@"char: FSTCharacteristicOpalSchedule, data: %@", characteristic.value);
    [self handleScheduleRead:characteristic];
  }
  else if ([characteristic.UUID isEqualToString: FSTCharacteristicOpalError])
  {
    NSLog(@"char: FSTCharacteristicOpalError, data: %@", characteristic.value);
    [self handleErrorRead:characteristic];
  }
  else if ([characteristic.UUID isEqualToString: FSTCharacteristicOpalLogIndex])
  {
    NSLog(@"char: FSTCharacteristicOpalLogIndex, data: %@", characteristic.value);
  }
  else if ([characteristic.UUID isEqualToString: FSTCharacteristicOpalLog0])
  {
    NSLog(@"char: FSTCharacteristicOpalLog0, data: %@", characteristic.value);
  }
  else if ([characteristic.UUID isEqualToString: FSTCharacteristicOpalLog6])
  {
    NSLog(@"char: FSTCharacteristicOpalLog6, data: %@", characteristic.value);
  }

}

-(void)handleTimeRead: (FSTBleCharacteristic*)characteristic
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

-(void)handleScheduleRead: (FSTBleCharacteristic*)characteristic
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

-(void)handleScheduleEnableRead: (FSTBleCharacteristic*)characteristic
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

-(void)handleErrorRead: (FSTBleCharacteristic*)characteristic
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

-(void)handleStatusRead: (FSTBleCharacteristic*)characteristic
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

-(void)handleModeRead: (FSTBleCharacteristic*)characteristic
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

-(void)handleCleanCycleRead: (FSTBleCharacteristic*)characteristic
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

-(void)handleLightRead: (FSTBleCharacteristic*)characteristic
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
- (void) deviceReady
{
  [super deviceReady];
  [self writeCurrentTime];
  [self abortOta];
//  [self startOta];
}



/**
 *  call method called when characteristics are discovered
 *
 *  @param characteristics an array of the characteristics
 */
-(void) handleDiscoverCharacteristics: (NSMutableArray*)characteristics
{
  [super handleDiscoverCharacteristics:characteristics];
  
  ((FSTBleCharacteristic*)[self.characteristics objectForKey:FSTCharacteristicOpalStatus]).requiresValue = YES;
  ((FSTBleCharacteristic*)[self.characteristics objectForKey:FSTCharacteristicOpalMode]).requiresValue = YES;
  ((FSTBleCharacteristic*)[self.characteristics objectForKey:FSTCharacteristicOpalLight]).requiresValue = YES;
  ((FSTBleCharacteristic*)[self.characteristics objectForKey:FSTCharacteristicOpalCleanCycle]).requiresValue = YES;
  ((FSTBleCharacteristic*)[self.characteristics objectForKey:FSTCharacteristicOpalTime]).requiresValue = YES;
  ((FSTBleCharacteristic*)[self.characteristics objectForKey:FSTCharacteristicOpalEnableSchedule]).requiresValue = YES;
  ((FSTBleCharacteristic*)[self.characteristics objectForKey:FSTCharacteristicOpalSchedule]).requiresValue = YES;
  ((FSTBleCharacteristic*)[self.characteristics objectForKey:FSTCharacteristicOpalError]).requiresValue = YES;
  ((FSTBleCharacteristic*)[self.characteristics objectForKey:FSTCharacteristicOpalLog0]).requiresValue = YES;
  ((FSTBleCharacteristic*)[self.characteristics objectForKey:FSTCharacteristicOpalLog6]).requiresValue = YES;
  ((FSTBleCharacteristic*)[self.characteristics objectForKey:FSTCharacteristicOpalLogIndex]).requiresValue = YES;

  
  ((FSTBleCharacteristic*)[self.characteristics objectForKey:FSTCharacteristicOpalStatus]).wantNotification = YES;
  ((FSTBleCharacteristic*)[self.characteristics objectForKey:FSTCharacteristicOpalMode]).wantNotification = YES;
  
//  [((FSTBleCharacteristic*)[self.characteristics objectForKey:FSTCharacteristicOpalError]) pollWithInterval:0.5];
  
//  ((FSTBleCharacteristic*)[self.characteristics objectForKey:FSTCharacteristicOpalError]).wantNotification = YES;
  
}

#pragma mark - external
-(void) checkForAndUpdateFirmware {
  
  if (OPAL_BLE_AVAILABLE_VERSION > self.currentBleVersion)
  {
    [UIAlertView showWithTitle:@"Bluetooth Update Available"
                       message:@"There is a bluetooth update available for your Opal, would you like to update now? It will take about 1 minute and you will need to keep the app open and nearby your Opal."
     
             cancelButtonTitle:@"Cancel Update"
             otherButtonTitles:@[@"Update Now"]
                      tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
                        if (buttonIndex == [alertView cancelButtonIndex])
                        {
                          NSLog(@"ble update cancelled");
                        }
                        else if ([[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:@"Update Now"])
                        {
                          NSLog(@"continue update");
                          [self startOtaType:OtaImageTypeBle forFileName:OPAL_BLE_FIRMWARE_FILE_NAME];
                        }
                      }];

    
  }
  else if (OPAL_APP_AVAILABLE_VERSION > self.currentAppVersion)
  {
    [UIAlertView showWithTitle:@"Opal Update Available"
                      message:@"There is an Opal update available, would you like to update now? It will take about 6 minutes and you will need to keep the app open and nearby your Opal."
    
            cancelButtonTitle:@"Cancel Update"
            otherButtonTitles:@[@"Update Now"]
                     tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
                       if (buttonIndex == [alertView cancelButtonIndex])
                       {
                         NSLog(@"ble update cancelled");
                       }
                       else if ([[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:@"Update Now"])
                       {
                         NSLog(@"continue update");
                         [self startOtaType:OtaImageTypeApplication forFileName:OPAL_APP_FIRMWARE_FILE_NAME];
                       }
                     }];
    
  }
  else {
    [UIAlertView showWithTitle:@"No Updates Available"
                       message:@"Your Opal's Bluetooth and application firmware are up-to-date!"
     
             cancelButtonTitle:@"Cancel Update"
             otherButtonTitles:nil
                      tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
                        // do nothing
                      }];
  }
  
}

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
