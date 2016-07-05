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
#import "MBProgressHUD.h"

@implementation FSTOpal
{
  int opalLogsCollected;
  MBProgressHUD *userActivityHud;

}

NSString * const FSTCharacteristicOpalStatus = @"097A2751-CA0D-432F-87B5-7D2F31E45551";
NSString * const FSTCharacteristicOpalMode = @"79994230-4B04-40CD-85C9-02DD1A8D4DD0";
NSString * const FSTCharacteristicOpalLight = @"37988F00-EA39-4A2D-9983-AFAD6535C02E";
NSString * const FSTCharacteristicOpalCleanCycle = @"EFE4BD77-0600-47D7-B3F6-DC81AF0D9AAF";
NSString * const FSTCharacteristicOpalTimeSync = @"ED9E0784-FBF1-47F4-AFE2-D439A6C207FC";
NSString * const FSTCharacteristicOpalEnableSchedule = @"B45163B3-1092-4725-95DC-1A43AC4A9B88";
NSString * const FSTCharacteristicOpalSchedule = @"9E1AE873-CB5E-4485-9884-5C5A3AD60E47";
NSString * const FSTCharacteristicOpalError = @"5BCBF6B1-DE80-94B6-0F4B-99FB984707B6";
NSString * const FSTCharacteristicOpalTemperature = @"BD205030-B5CE-4847-B78D-83BFF1450A6B";

NSString * const FSTCharacteristicOpalLogIndex = @"1F122C31-D1EA-447D-8409-56196DF130D2";
NSString * const FSTCharacteristicOpalLog0 = @"1CE417B2-5BE0-4D4F-99C6-4086F49AE901";
NSString * const FSTCharacteristicOpalLog1 = @"3E2D48C7-0336-40D7-B281-E5C5F70366B8";
NSString * const FSTCharacteristicOpalLog2 = @"21959717-F8D2-46ED-925E-FCDFEB666F65";
NSString * const FSTCharacteristicOpalLog3 = @"EC780A17-1E86-4633-8BB7-4AD614413942";
NSString * const FSTCharacteristicOpalLog4 = @"06124193-F87C-49F3-AB44-59AA1DBA82F1";
NSString * const FSTCharacteristicOpalLog5 = @"21D3FDBB-5C1D-4ACE-9578-7D3D3CEBA147";
NSString * const FSTCharacteristicOpalLog6 = @"352DDEA3-79F7-410F-B5B5-4D3F96DC510D";

- (id)init
{
  self = [super init];

  if (self)
  {
    self.status = @0;
    
    self.availableBleVersion = OPAL_BLE_AVAILABLE_VERSION;
    self.availableAppVersion = OPAL_APP_AVAILABLE_VERSION;
    self.opalErrorCode = 0;
    self.temperature = 0;
    self.temperatureHistory = [[NSMutableArray alloc]init];
    self.temperatureHistoryDates = [[NSMutableArray alloc]init];
    opalLogsCollected = 0;
    
    self.schedules = [[NSMutableArray alloc] init];
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
  
  NSMutableString *string = [[NSMutableString alloc] init];
  
  for(NSString *binary in schedule) {
    NSUInteger value = 0;
    
    for(int i=0; i<[binary length]; i++){
      
      NSString *indexed = [binary substringWithRange:NSMakeRange(i, 1)];
      value = value + ([indexed integerValue] << i);
    }
    
    NSString *hex = [NSString stringWithFormat:@"%02lX", value];
    [string appendString:hex];
  }

  NSData *data = [self hexToBytes:string];
  NSLog(@"send scedule %@", data);

  if (characteristic)
  {
    [self writeFstBleCharacteristic:characteristic withValue:data];
  }
}

-(NSData*)hexToBytes:(NSString *)string {
  NSMutableData* data = [NSMutableData data];
  
  for (int i = 0; i+2 <= string.length; i+=2) {
    NSRange range = NSMakeRange(i, 2);
    NSString* hexStr = [string substringWithRange:range];
    NSScanner* scanner = [NSScanner scannerWithString:hexStr];
    unsigned int intValue;
    [scanner scanHexInt:&intValue];
    [data appendBytes:&intValue length:1];
  }
  return data;
}

-(void)writeCurrentTime {
  
  FSTBleCharacteristic* characteristic = [self.characteristics objectForKey:FSTCharacteristicOpalTimeSync];
  
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

  
  uint32_t secondsSince1970 = (uint32_t)[[NSDate date]timeIntervalSince1970];
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
  else if([characteristic.UUID isEqualToString: FSTCharacteristicOpalTimeSync])
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
  NSLog(@"handleWriteSchedule written");
  if ([self.delegate respondsToSelector:@selector(iceMakerScheduleWritten:)])
  {
    [self.delegate iceMakerScheduleWritten:error];
  }
  
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
  FSTBleCharacteristic* timeCharacteristic = [self.characteristics objectForKey:FSTCharacteristicOpalTimeSync];
  [self readFstBleCharacteristic:timeCharacteristic];
}

#pragma mark - read handlers

-(void)readHandler: (FSTBleCharacteristic*)characteristic
{
  [super readHandler:characteristic];
  
  NSLog(@"readHandler: %@", characteristic);
  
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
  else if ([characteristic.UUID isEqualToString: FSTCharacteristicOpalTimeSync])
  {
    NSLog(@"char: FSTCharacteristicOpalTime, data: %@", characteristic.value);
    [self handleTimeSyncRead:characteristic];
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
  else if ([characteristic.UUID isEqualToString: FSTCharacteristicOpalTemperature])
  {
    NSLog(@"char: FSTCharacteristicOpalTemperature, data: %@", characteristic.value);
    [self handleTemperatureRead:characteristic];
  }
  else if ([characteristic.UUID isEqualToString: FSTCharacteristicOpalLogIndex])
  {
    [self checkCompileOpalLogComplete];
    NSLog(@"char: FSTCharacteristicOpalLogIndex, data: %@", characteristic.value);
  }
  else if ([characteristic.UUID isEqualToString: FSTCharacteristicOpalLog0])
  {
    [self checkCompileOpalLogComplete];
    NSLog(@"char: FSTCharacteristicOpalLog0, data: %@", characteristic.value);
  }
  else if ([characteristic.UUID isEqualToString: FSTCharacteristicOpalLog1])
  {
    [self checkCompileOpalLogComplete];
    NSLog(@"char: FSTCharacteristicOpalLog1, data: %@", characteristic.value);
  }
  else if ([characteristic.UUID isEqualToString: FSTCharacteristicOpalLog2])
  {
    [self checkCompileOpalLogComplete];
    NSLog(@"char: FSTCharacteristicOpalLog2, data: %@", characteristic.value);
  }
  else if ([characteristic.UUID isEqualToString: FSTCharacteristicOpalLog3])
  {
    [self checkCompileOpalLogComplete];
    NSLog(@"char: FSTCharacteristicOpalLog3, data: %@", characteristic.value);
  }
  else if ([characteristic.UUID isEqualToString: FSTCharacteristicOpalLog4])
  {
    [self checkCompileOpalLogComplete];
    NSLog(@"char: FSTCharacteristicOpalLog4, data: %@", characteristic.value);
  }
  else if ([characteristic.UUID isEqualToString: FSTCharacteristicOpalLog5])
  {
    [self checkCompileOpalLogComplete];
    NSLog(@"char: FSTCharacteristicOpalLog5, data: %@", characteristic.value);
  }
  else if ([characteristic.UUID isEqualToString: FSTCharacteristicOpalLog6])
  {
    [self checkCompileOpalLogComplete];
    NSLog(@"char: FSTCharacteristicOpalLog6, data: %@", characteristic.value);
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
  if (characteristic.value.length != 24)
  {
    DLog(@"handleSchedule length of %lu not what was expected, %d", (unsigned long)characteristic.value.length, 24);
    return;
  }
  
  NSData *data = characteristic.value;
  NSUInteger len = [data length];
  Byte *byteData = (Byte *)malloc(len);
  memcpy(byteData, [data bytes], len);
  
  if(self.schedules.count > 0) {
    [self.schedules removeAllObjects];
  }
  
  for(int i =0; i<len; i++){
    
    uint8_t data = byteData[i];
    
    NSString *binary = [self getBinary:data];
    [self.schedules addObject:binary];
  }
  
  free(byteData);
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
  if (self.opalErrorCode != bytes[0])
  {
    self.opalErrorCode = bytes[0];
    if ([self.delegate respondsToSelector:@selector(iceMakerErrorChanged)])
    {
      [self.delegate iceMakerErrorChanged];
    }
  }
  
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

-(void)handleTemperatureRead: (FSTBleCharacteristic*)characteristic
{
  if (characteristic.value.length != 1)
  {
    DLog(@"handleTemperatureRead length of %lu not what was expected, %d", (unsigned long)characteristic.value.length, 1);
    return;
  }
  
  NSData *data = characteristic.value;
  Byte bytes[characteristic.value.length] ;
  [data getBytes:bytes length:characteristic.value.length];
  self.temperature = (char)bytes[0];
  [self.temperatureHistory addObject:[NSNumber numberWithInt:self.temperature]];
  [self.temperatureHistoryDates addObject:[[NSDate alloc] init] ] ;
  
  if ([self.delegate respondsToSelector:@selector(iceMakerTemperatureChanged:)])
  {
    [self.delegate iceMakerTemperatureChanged:self.temperature];
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

-(void)handleTimeSyncRead: (FSTBleCharacteristic*)characteristic
{
  if (characteristic.value.length != 4)
  {
    DLog(@"handleTimeSync length of %lu not what was expected, %d", (unsigned long)characteristic.value.length, 4);
    return;
  }
  
  NSData *data = characteristic.value;
  NSUInteger len = [data length];
  Byte *byteData = (Byte *)malloc(len);
  memcpy(byteData, [data bytes], len);
  
  uint32_t value = 0;
  
  for(int i =0; i<len; i++){
    
    if(i == 0) {
      value = value + byteData[0];
    }
    else if (i == 1) {
      value = value + (byteData[1] << 8);
    }
    else if (i == 2) {
      value = value + (byteData[2] << 16);
    }
    else if (i == 3) {
      value = value + (byteData[3] << 24);
    }
    
  }
  free(byteData);
  
  NSDate *time = [NSDate dateWithTimeIntervalSince1970:value];
  self.timeSync = time;
  
  if([self.delegate respondsToSelector:@selector(iceMakerTimeSyncChanged:)])
  {
    [self.delegate iceMakerTimeSyncChanged:self.timeSync];
  }
}

#pragma mark - Characteristic Discovery Handler
- (void) deviceReady
{
  [super deviceReady];
  [self writeCurrentTime];
  [self abortOta];
  
//  [((FSTBleCharacteristic*)[self.characteristics objectForKey:FSTCharacteristicOpalError]) pollWithInterval:2.0];
}



/**
 *  call method called when characteristics are discovered
 *
 *  @param characteristics an array of the characteristics
 */
-(void) handleDiscoverCharacteristics: (NSMutableArray*)characteristics
{
  
  //IMPORTANT: With some of the BLE devices its required to read the value before the notification
  [super handleDiscoverCharacteristics:characteristics];
  
  ((FSTBleCharacteristic*)[self.characteristics objectForKey:FSTCharacteristicOpalStatus]).requiresValue = YES;
  ((FSTBleCharacteristic*)[self.characteristics objectForKey:FSTCharacteristicOpalMode]).requiresValue = YES;
  ((FSTBleCharacteristic*)[self.characteristics objectForKey:FSTCharacteristicOpalLight]).requiresValue = YES;
  ((FSTBleCharacteristic*)[self.characteristics objectForKey:FSTCharacteristicOpalTimeSync]).requiresValue = YES;
  ((FSTBleCharacteristic*)[self.characteristics objectForKey:FSTCharacteristicOpalTemperature]).requiresValue = YES;
  ((FSTBleCharacteristic*)[self.characteristics objectForKey:FSTCharacteristicOpalEnableSchedule]).requiresValue = YES;
  ((FSTBleCharacteristic*)[self.characteristics objectForKey:FSTCharacteristicOpalSchedule]).requiresValue = YES;
  ((FSTBleCharacteristic*)[self.characteristics objectForKey:FSTCharacteristicOpalError]).requiresValue = YES;
//  ((FSTBleCharacteristic*)[self.characteristics objectForKey:FSTCharacteristicOpalLog0]).requiresValue = YES;
//  ((FSTBleCharacteristic*)[self.characteristics objectForKey:FSTCharacteristicOpalLog6]).requiresValue = YES;
//  ((FSTBleCharacteristic*)[self.characteristics objectForKey:FSTCharacteristicOpalLogIndex]).requiresValue = YES;
//  ((FSTBleCharacteristic*)[self.characteristics objectForKey:FSTCharacteristicOpalCleanCycle]).requiresValue = YES;

  
  ((FSTBleCharacteristic*)[self.characteristics objectForKey:FSTCharacteristicOpalStatus]).wantNotification = YES;
  ((FSTBleCharacteristic*)[self.characteristics objectForKey:FSTCharacteristicOpalMode]).wantNotification = YES;
  ((FSTBleCharacteristic*)[self.characteristics objectForKey:FSTCharacteristicOpalLight]).wantNotification = YES;
  ((FSTBleCharacteristic*)[self.characteristics objectForKey:FSTCharacteristicOpalTemperature]).wantNotification = YES;
  ((FSTBleCharacteristic*)[self.characteristics objectForKey:FSTCharacteristicOpalError]).wantNotification = YES;
  ((FSTBleCharacteristic*)[self.characteristics objectForKey:FSTCharacteristicOpalSchedule]).wantNotification = YES;
  
}

#pragma mark - external
-(void) checkForAndUpdateFirmware {
  
  if ([self.status intValue] != 0)
  {
    [UIAlertView showWithTitle:@"Please ensure Opal is not on"
                       message:@"Opal needs to be off in order to make ice. Please ensure the unit is plugged in, but not making ice or in cleaning mode."
     
             cancelButtonTitle:@"OK"
             otherButtonTitles:nil
                      tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
                        // do nothing
                      }];
  }
  else if (OPAL_BLE_AVAILABLE_VERSION > self.currentBleVersion)
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
  else
  {
    [UIAlertView showWithTitle:@"No Updates Available"
                       message:@"Your Opal's Bluetooth and application firmware are up-to-date. Also make sure you have the latest version of this app from the Apple App Store."
     
             cancelButtonTitle:@"OK"
             otherButtonTitles:nil
                      tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
                        // do nothing
                      }];
  }
  
}

- (void) turnIceMakerOn: (BOOL) on {
  [self writeMode:on];
}

- (void) turnNightLightOn: (BOOL)on  {
  [self writeNightLight:on];
}

- (void) turnIceMakerScheduleOn: (BOOL)on  {
  [self writeScheduleEnable:on];
}

- (void) configureSchedule: (NSArray*) schedule {
  [self writeSchedule:schedule];
}

- (void) compileOpalLog {
  
  UIWindow *window = [[UIApplication sharedApplication] keyWindow];
  UIView *view = window.rootViewController.view;
  [MBProgressHUD hideAllHUDsForView:view animated:YES];
  userActivityHud = [MBProgressHUD showHUDAddedTo:view animated:YES];
  opalLogsCollected = 0;
  
  FSTBleCharacteristic* characteristic = [self.characteristics objectForKey:FSTCharacteristicOpalLog0];
  [self readFstBleCharacteristic:characteristic];
  
  characteristic = [self.characteristics objectForKey:FSTCharacteristicOpalLog1];
  [self readFstBleCharacteristic:characteristic];

  characteristic = [self.characteristics objectForKey:FSTCharacteristicOpalLog2];
  [self readFstBleCharacteristic:characteristic];

  characteristic = [self.characteristics objectForKey:FSTCharacteristicOpalLog3];
  [self readFstBleCharacteristic:characteristic];

  characteristic = [self.characteristics objectForKey:FSTCharacteristicOpalLog4];
  [self readFstBleCharacteristic:characteristic];

  characteristic = [self.characteristics objectForKey:FSTCharacteristicOpalLog5];
  [self readFstBleCharacteristic:characteristic];

  characteristic = [self.characteristics objectForKey:FSTCharacteristicOpalLog6];
  [self readFstBleCharacteristic:characteristic];
  
  characteristic = [self.characteristics objectForKey:FSTCharacteristicOpalLogIndex];
  [self readFstBleCharacteristic:characteristic];
}

- (void)checkCompileOpalLogComplete {
  opalLogsCollected++;
  
  NSMutableString* data = [[NSMutableString alloc]init];
  
  if (opalLogsCollected==8)
  {
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    UIView *view = window.rootViewController.view;
    [MBProgressHUD hideAllHUDsForView:view animated:YES];

    FSTBleCharacteristic* characteristic = [self.characteristics objectForKey:FSTCharacteristicOpalLogIndex];
    NSString* header = [NSString stringWithFormat:@"------------ DATA DUMP (index: %@) ------------------",characteristic.value ];
    data = (NSMutableString*)[data stringByAppendingString:header];
    characteristic = [self.characteristics objectForKey:FSTCharacteristicOpalLog1];
    data = (NSMutableString*)[data stringByAppendingString:[self getStringValueForCharacteristic:characteristic] ];
   
    characteristic = [self.characteristics objectForKey:FSTCharacteristicOpalLog1];
    data = (NSMutableString*)[data stringByAppendingString:[self getStringValueForCharacteristic:characteristic] ];
    characteristic = [self.characteristics objectForKey:FSTCharacteristicOpalLog2];
    data = (NSMutableString*)[data stringByAppendingString:[self getStringValueForCharacteristic:characteristic] ];
    characteristic = [self.characteristics objectForKey:FSTCharacteristicOpalLog3];
    data = (NSMutableString*)[data stringByAppendingString:[self getStringValueForCharacteristic:characteristic] ];
    characteristic = [self.characteristics objectForKey:FSTCharacteristicOpalLog4];
    data = (NSMutableString*)[data stringByAppendingString:[self getStringValueForCharacteristic:characteristic] ];
    characteristic = [self.characteristics objectForKey:FSTCharacteristicOpalLog5];
    data = (NSMutableString*)[data stringByAppendingString:[self getStringValueForCharacteristic:characteristic] ];
    characteristic = [self.characteristics objectForKey:FSTCharacteristicOpalLog6];
    data = (NSMutableString*)[data stringByAppendingString:[self getStringValueForCharacteristic:characteristic] ];
    
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    
    data= (NSMutableString*)[data stringByAppendingString:@"\n\n TEMP DATA \n\n"];
    for (int i = 0; i< self.temperatureHistoryDates.count; i++) {
      NSString* value = [NSString stringWithFormat:@"%@", self.temperatureHistory[i]];
      NSString* date = [dateFormatter stringFromDate:self.temperatureHistoryDates[i]];
      NSString* logEntry = [NSString stringWithFormat:@"%@:%@,",date, value];
      data = (NSMutableString*)[data stringByAppendingString:logEntry];
    }
    
    self.temperatureHistory = [[NSMutableArray alloc]init];
    self.temperatureHistoryDates = [[NSMutableArray alloc]init];
    NSLog(@"contents: %@", data);
    NSString *subject = [NSString stringWithFormat:@"Opal Logfile Diagnostics"];
    NSString *mail = [NSString stringWithFormat:@"scott@firstbuild.com"];
    NSURL *url = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"mailto:?to=%@&subject=%@&body=%@",
                                                [mail stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding],
                                                [subject stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding],
                                                [data stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding]]];
    [[UIApplication sharedApplication] openURL:url];

  }
}

- (NSString*)getStringValueForCharacteristic: (FSTBleCharacteristic*) characteristic {
  NSData *data = characteristic.value;
  NSUInteger capacity = data.length * 2;
  NSMutableString *sbuf = [NSMutableString stringWithCapacity:capacity];
  const unsigned char *buf = data.bytes;
  NSInteger i;
  for (i=0; i<data.length; ++i) {
    [sbuf appendFormat:@"%02lX,", (unsigned long)buf[i]];
  }
  return [sbuf stringByAppendingString:@"::::::"];
}

- (NSString *)getBinary: (int)byte {
  
  NSMutableString *binary = [[NSMutableString alloc] init];
  NSInteger numberCopy = byte;
  
  for(NSInteger i = 0; i < 8 ; i++) {
    
    [binary appendString:((numberCopy & 1) ? @"1" : @"0")];
    numberCopy >>= 1;
  }
  
  return binary;
}
@end
