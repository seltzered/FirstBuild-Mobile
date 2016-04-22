//
//  FSTGeBleProduct.m
//  FirstBuild
//
//  Created by Myles Caley on 4/18/16.
//  Copyright © 2016 FirstBuild. All rights reserved.
//

#import <TransitionKit.h>
#import "MBProgressHUD.h"
#import "FSTGeBleProduct.h"

typedef enum {
  OtaImageTypeBle = 0x00,
  OtaImageTypeApplication = 0x01,
  OtaImageTypeNone = 0xFF,
  OtaImageTypeUnknown = 0xFE
} OtaImageType;

//firmware
NSString * const FSTCharacteristicOtaControlCommand     = @"4FB34AB1-6207-E5A0-484F-E24A7F638FFF"; //write,notify
NSString * const FSTCharacteristicOtaImageData          = @"78282AE5-3060-C3B6-7D49-EC74702414E5"; //write
NSString * const FSTCharacteristicOtaImageType          = @"5EA370C7-2059-41DB-9999-36527B43A4B4"; //read,write
NSString * const FSTCharacteristicOtaAppUpdateStatus    = @"14FF6DFB-36FA-4456-927D-759E1A9A8446"; //read,notify

@implementation FSTGeBleProduct
{
  
  NSData* otaImage;
  NSUInteger otaBytesWritten;
  NSUInteger otaBytesWriteRequested;
  NSUInteger applicationFlashPercent;
  
  uint otaBytesWrittenInTrailer;
  
  NSMutableData* _debugPayload;
  
  TKStateMachine* stateMachine;
  TKState* otaStateIdle;
  TKState* otaStateStart;
  TKState* otaStateStartRequested;
  TKState* otaStateDownloadBleStart;
  TKState* otaStateDownloadApplicationStart;
  TKState* otaStateDownloading;
  TKState* otaStateVerifyImageRequest;
  TKState* otaStateAbortRequested;
  TKState* otaStateFailed;
  
  TKEvent *otaEventInitialize;
  TKEvent *otaEventStart;
  TKEvent *otaEventFailed;
  TKEvent *otaEventImageTypeSet;
  TKEvent *otaEventStartApplicationOta;
  TKEvent *otaEventStartBleOta;
  TKEvent *otaEventDownloadReady;
  TKEvent *otaEventDownloadCompleted;
  
  //the value of the actual image type from the BLE module
  OtaImageType actualOtaImageType;
  
  //the value the user has requested for the image type
  OtaImageType requestedOtaImageType;
  
  MBProgressHUD *hud;
}

- (instancetype)init
{
  self = [super init];
  if (self) {
    
    [self initializeStateMachine];
    
    actualOtaImageType = OtaImageTypeUnknown;
    applicationFlashPercent = 0;
    
  }
  return self;
}

#pragma mark - state machine setup

-(void)initializeStateMachine {
  
  stateMachine = [TKStateMachine new];
  
  stateMachine.initialState = otaStateIdle;
  
  [self configureStateMachineStates];
  [self configureStateMachineEvents];
  [stateMachine activate];
}

-(void)configureStateMachineStates {
  __weak FSTGeBleProduct* weakSelf = self;
  
  otaStateIdle = [TKState stateWithName:@"otaStateIdle"];
  otaStateStart = [TKState stateWithName:@"otaStateStart"];
  
  otaStateStartRequested = [TKState stateWithName:@"otaStateStartRequested"];
  otaStateDownloadBleStart = [TKState stateWithName:@"otaStateDownloadBleStart"];
  otaStateDownloadApplicationStart = [TKState stateWithName:@"otaStateDownloadApplicationStart"];
  otaStateDownloading = [TKState stateWithName:@"otaStateDownloading"];
  otaStateVerifyImageRequest = [TKState stateWithName:@"otaStateVerifyImageRequest"];
  otaStateAbortRequested = [TKState stateWithName:@"otaStateAbortRequested"];
  otaStateFailed = [TKState stateWithName:@"otaStateFailed"];
  
  [stateMachine addStates:@[ otaStateIdle, otaStateStart,  otaStateStartRequested,otaStateDownloadApplicationStart , otaStateDownloadBleStart, otaStateDownloading , otaStateVerifyImageRequest, otaStateAbortRequested, otaStateFailed]];
  
  [otaStateIdle setDidEnterStateBlock:^(TKState *state, TKTransition *transition) {
    NSLog(@"<<otaStateIdle>>");
    _debugPayload = [NSMutableData new];
    otaBytesWritten = 0;
    otaBytesWrittenInTrailer = 0;
    otaBytesWriteRequested = 0;
    requestedOtaImageType = OtaImageTypeUnknown;
  }];
  
  [otaStateStart setDidEnterStateBlock:^(TKState *state, TKTransition *transition) {
    NSLog(@"<<otaStateStart>>");
    if (actualOtaImageType == requestedOtaImageType)
    {
      NSLog(@"image type already set");
      FSTGeBleProduct* strongSelf = weakSelf;
      [strongSelf->stateMachine fireEvent:strongSelf->otaEventImageTypeSet userInfo:nil error:nil];
    }
    else if(actualOtaImageType == OtaImageTypeUnknown)
    {
      FSTGeBleProduct* strongSelf = weakSelf;
      [strongSelf->stateMachine fireEvent:strongSelf->otaEventFailed userInfo:@{@"error":@"otaStateStart,setDidEnterStateBlock: actualOtaImageType not set"} error:nil];
    }
    else if(requestedOtaImageType == OtaImageTypeUnknown)
    {
      FSTGeBleProduct* strongSelf = weakSelf;
      [strongSelf->stateMachine fireEvent:strongSelf->otaEventFailed userInfo:@{@"error":@"otaStateStart,setDidEnterStateBlock: requestedOtaImageType not set"} error:nil];
    }
    else
    {
      [weakSelf writeImageType];
    }
    
  }];
  
  [otaStateStartRequested setDidEnterStateBlock:^(TKState *state, TKTransition *transition) {
    NSLog(@"<<otaStateStartRequested>>");
    [weakSelf writeStartOta];
  }];
  
  [otaStateDownloadApplicationStart setDidEnterStateBlock:^(TKState *state, TKTransition *transition) {
    NSLog(@"<<otaStateDownloadApplicationStart>>");
    [weakSelf readOtaFileFromBundle];
    [weakSelf writeOtaStartDownloadApplicationCommand];
  }];
  
  [otaStateDownloadBleStart setDidEnterStateBlock:^(TKState *state, TKTransition *transition) {
    NSLog(@"<<otaStateDownloadBleStart>>");
    [weakSelf readOtaFileFromBundle];
    [weakSelf writeOtaStartDownloadBleCommand];
  }];
  
  [otaStateDownloading setDidEnterStateBlock:^(TKState *state, TKTransition *transition) {
    NSLog(@"<<otaStateDownloading>>");
    
    FSTGeBleProduct* strongSelf = weakSelf;
    
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    UIView *view = window.rootViewController.view;
    [MBProgressHUD hideAllHUDsForView:view animated:YES];
    strongSelf->hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    strongSelf->hud.mode = MBProgressHUDModeDeterminateHorizontalBar;
    strongSelf->hud.labelText = @"Downloading...";
    strongSelf->hud.detailsLabelText = @"";
    strongSelf->hud.progress = 0.0;

    [weakSelf writeImageBytes];
  }];
  
  [otaStateDownloading setDidExitStateBlock:^(TKState *state, TKTransition *transition) {
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    UIView *view = window.rootViewController.view;
    [MBProgressHUD hideAllHUDsForView:view animated:YES];
  }];
  
  [otaStateVerifyImageRequest setDidEnterStateBlock:^(TKState *state, TKTransition *transition) {
    NSLog(@"<<otaStateVerifyImageRequest>>");
    [weakSelf writeOtaImageVerify];
  }];
  
  [otaStateAbortRequested setDidEnterStateBlock:^(TKState *state, TKTransition *transition) {
    NSLog(@"<<otaStateAbortRequested>>");
  }];
  
  [otaStateFailed setDidEnterStateBlock:^(TKState *state, TKTransition *transition) {
    
    NSLog(@"<<otaStateFailed>>");

    NSString* error = [transition.userInfo objectForKey:@"error"];
    NSLog(@"<<<<< OTA FAILURE, ABORTING %@ >>>>>>", error);
    
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    UIView *view = window.rootViewController.view;
    [MBProgressHUD hideAllHUDsForView:view animated:YES];
    
    [weakSelf abortOta];
  }];
}


-(void)configureStateMachineEvents {
  
  //event that initializes and begins the entire OTA process, whether its an application or BLE update
  otaEventStart = [TKEvent eventWithName:@"otaEventStart" transitioningFromStates:@[ otaStateIdle ] toState:otaStateStart];
  
  //event that occurs from almost any state, this will reset the state machine
  otaEventFailed = [TKEvent eventWithName:@"otaEventFailed" transitioningFromStates:@[  otaStateStart,  otaStateStartRequested,otaStateDownloadApplicationStart, otaStateDownloadBleStart ,otaStateDownloading  , otaStateVerifyImageRequest] toState:otaStateFailed];
  
  //event that signals the application or ble image type has been set
  otaEventImageTypeSet = [TKEvent eventWithName:@"otaEventImageTypeSet" transitioningFromStates:@[ otaStateStart ] toState:otaStateStartRequested];
  
  //event that signals the start of an application ota
  otaEventStartApplicationOta =[TKEvent eventWithName:@"otaEventStartApplicationOta" transitioningFromStates:@[ otaStateStartRequested ] toState:otaStateDownloadApplicationStart];
  
  //event that signals the start of a ble ota
  otaEventStartBleOta =[TKEvent eventWithName:@"otaEventStartBleOta" transitioningFromStates:@[ otaStateStartRequested ] toState:otaStateDownloadBleStart];
  
  //event that signals the module is ready for the download
  otaEventDownloadReady =[TKEvent eventWithName:@"otaEventDownloadReady" transitioningFromStates:@[ otaStateDownloadBleStart, otaStateDownloadApplicationStart ] toState:otaStateDownloading];
  
  //event that signals the completion of the download
  otaEventDownloadCompleted =[TKEvent eventWithName:@"otaEventDownloadCompleted" transitioningFromStates:@[ otaStateDownloading  ] toState:otaStateVerifyImageRequest];
  
  //event that signals a reset
  otaEventInitialize =[TKEvent eventWithName:@"otaEventInitialize" transitioningFromStates:@[ otaStateIdle, otaStateStart,  otaStateStartRequested,otaStateDownloadApplicationStart , otaStateDownloadBleStart, otaStateDownloading , otaStateVerifyImageRequest, otaStateAbortRequested, otaStateFailed  ] toState:otaStateIdle];
  
  [stateMachine addEvents:@[ otaEventStart, otaEventFailed, otaEventImageTypeSet,otaEventStartApplicationOta,otaEventStartBleOta,otaEventDownloadReady,otaEventDownloadCompleted,otaEventInitialize ]];
}


# pragma mark - helper functions
-(void)readOtaFileFromBundle
{
//  NSString *otaFileName = [[NSBundle mainBundle] pathForResource:@"opal_ble_1_02_00_00" ofType:@"ota"];
  NSString *otaFileName = [[NSBundle mainBundle] pathForResource:@"opal_61k" ofType:@"ota"];
  otaImage = [NSData dataWithContentsOfFile:otaFileName];
}

# pragma mark - write handlers
-(void)writeHandler:(FSTBleCharacteristic *)characteristic error:(NSError *)error
{
  [super writeHandler:characteristic error:error];
  if([[[characteristic.bleCharacteristic UUID] UUIDString] isEqualToString: FSTCharacteristicOtaImageData])
  {
    [self handleOtaImageDataWriteResponse:error];
  }
  else if ([[[characteristic.bleCharacteristic UUID] UUIDString] isEqualToString: FSTCharacteristicOtaImageType])
  {
    [self handleOtaImageTypeWriteResponse:error];
  }
  else if ([[[characteristic.bleCharacteristic UUID] UUIDString] isEqualToString: FSTCharacteristicOtaControlCommand ])
  {
    [self handleOtaControlCommandWriteResponse:error];
  }
}

-(void)handleOtaControlCommandWriteResponse: (NSError*)error
{
  NSLog(@"handleOtaControlCommandWriteResponse: %@", error);
}

-(void)handleOtaImageTypeWriteResponse: (NSError*) error
{
  if (error)
  {
    [stateMachine fireEvent:otaEventFailed userInfo:@{@"error":@"handleOtaImageTypeWriteResponse:write error"} error:nil];
    return;
  }
  else if (stateMachine.currentState != otaStateStart)
  {
    [stateMachine fireEvent:otaEventFailed userInfo:@{@"error":@"handleOtaImageTypeWriteResponse:incorrect state"} error:nil];
    return;
  }
  
  [stateMachine fireEvent:otaEventImageTypeSet userInfo:nil error:nil];
  
}

-(void)handleOtaImageDataWriteResponse: (NSError*) error
{
  if (error)
  {
    [stateMachine fireEvent:otaEventFailed userInfo:@{@"error":@"handleOtaImageDataWriteResponse:write error"} error:nil];
    return;
  }
  else if (stateMachine.currentState == otaStateDownloadApplicationStart)
  {
    [stateMachine fireEvent:otaEventDownloadReady userInfo:nil error:nil];
    return;
  }
  else if (stateMachine.currentState != otaStateDownloading)
  {
    [stateMachine fireEvent:otaEventFailed userInfo:@{@"error":@"handleOtaImageDataWriteResponse:incorrect state"} error:nil];
    return;
  }
  
  //check and see if we are done writing
  if (requestedOtaImageType == OtaImageTypeBle)
  {
    //check to see if we have written all the bytes in the trailer
    //TODO include this as part of bytes written (i.e. just add 160)
    if (otaBytesWrittenInTrailer == 160) {
      [stateMachine fireEvent:otaEventDownloadCompleted userInfo:nil error:nil];
      return;
    }
  }
//  else if(otaBytesWritten == otaImage.length)
//  {
//    NSLog(@"image transfer complete");
//    return;
//  }
  else if (otaBytesWritten + otaBytesWriteRequested == otaImage.length)
  {
    [stateMachine fireEvent:otaEventDownloadCompleted userInfo:nil error:nil];
    return;
  }
  
  otaBytesWritten = otaBytesWritten + otaBytesWriteRequested;
  
  hud.progress = (float)otaBytesWritten / (float)otaImage.length;
  
  printf("%lu,",(unsigned long)otaBytesWritten);
  
  [self writeImageBytes];
  
}

#pragma mark - write

-(void)writeOtaAbort
{
  FSTBleCharacteristic* characteristic = [self.characteristics objectForKey:FSTCharacteristicOtaControlCommand];
  
  Byte bytes[1];
  bytes[0] = 0x07;
  NSData *data = [[NSData alloc]initWithBytes:bytes length:sizeof(bytes)];
  if (characteristic)
  {
    [self.peripheral writeValue:data forCharacteristic:characteristic.bleCharacteristic type:CBCharacteristicWriteWithResponse];
  }
}

-(void)writeImageType
{
  FSTBleCharacteristic* characteristic = [self.characteristics objectForKey:FSTCharacteristicOtaImageType];
  Byte bytes[1];
  
  if (requestedOtaImageType == OtaImageTypeApplication) {
    bytes[0] = 0x01;
  } else if(requestedOtaImageType == OtaImageTypeBle) {
    bytes[0] = 0x00;
  } else {
    [stateMachine fireEvent:otaEventFailed userInfo:@{@"error":@"writeImageType:unknown image type"} error:nil];
    return;
  }
  
  NSData *data = [[NSData alloc]initWithBytes:bytes length:sizeof(bytes)];
  if (characteristic)
  {
    [self.peripheral writeValue:data forCharacteristic:characteristic.bleCharacteristic type:CBCharacteristicWriteWithResponse];
  }
}

-(void)writeImageBytes
{
  FSTBleCharacteristic* characteristic = [self.characteristics objectForKey:FSTCharacteristicOtaImageData];
  
  if (characteristic && stateMachine.currentState == otaStateDownloading && otaImage.length > 0)
  {
//    if (otaBytesWritten > 0 && otaBytesWritten%500==0)
//    {
//      NSLog(@"written %lu", (unsigned long)otaBytesWritten);
//    }
    
    if (requestedOtaImageType == OtaImageTypeApplication) {
      [self writeApplicationImageBytes];
    } else {
      [self writeBleImageBytes];
    }
  }
  else
  {
    [stateMachine fireEvent:otaEventFailed userInfo:@{@"error":@"writeImageBytes:unknown state"} error:nil];
    return;
  }
  
}

-(void)writeApplicationImageBytes
{
  NSData* data;
  FSTBleCharacteristic* characteristic = [self.characteristics objectForKey:FSTCharacteristicOtaImageData];
  
  if (otaBytesWritten < otaImage.length)
  {
    if (otaBytesWritten+20 > otaImage.length)
    {
      // padding
      NSUInteger otaRemainingLength = otaImage.length - otaBytesWritten;
      NSData* lastChunk = [otaImage subdataWithRange:NSMakeRange(otaBytesWritten, otaRemainingLength)];
      
      char remainingBytes[20];
      memset(remainingBytes,0,20);
      memcpy(remainingBytes,[lastChunk bytes],20);
      
      data = [NSData dataWithBytes:remainingBytes length:otaRemainingLength];
      
      NSLog(@"final bytes");
    }
    else
    {
      // normal
      data = [otaImage subdataWithRange:NSMakeRange(otaBytesWritten, 20)];
    }
    
    [_debugPayload appendData:data];
    otaBytesWriteRequested = data.length;
    [self.peripheral writeValue:data forCharacteristic:characteristic.bleCharacteristic type:CBCharacteristicWriteWithResponse];
  }
  else
  {
    [stateMachine fireEvent:otaEventFailed userInfo:@{@"error":@"writeApplicationImageBytes:byte issue"} error:nil];
  }
}


-(void)writeBleImageBytes
{
  NSUInteger otaImageActualLength = otaImage.length - 160;
  NSData* data;
  FSTBleCharacteristic* characteristic = [self.characteristics objectForKey:FSTCharacteristicOtaImageData];
  
  if (otaBytesWritten <= otaImageActualLength)
  {
    
    if (otaBytesWritten+20 > otaImageActualLength)
    {
      // padding
      NSUInteger otaRemainingLength = otaImageActualLength - otaBytesWritten;
      NSData* lastChunk = [otaImage subdataWithRange:NSMakeRange(otaBytesWritten, otaRemainingLength)];
      
      char remainingBytes[20];
      memset(remainingBytes,0,20);
      memcpy(remainingBytes,[lastChunk bytes],otaRemainingLength);
      
      data = [NSData dataWithBytes:remainingBytes length:20];
      NSLog(@"final bytes");
    }
    else
    {
      // normal
      data = [otaImage subdataWithRange:NSMakeRange(otaBytesWritten, 20)];
    }
    [_debugPayload appendData:data];
    otaBytesWriteRequested = data.length;
    [self.peripheral writeValue:data forCharacteristic:characteristic.bleCharacteristic type:CBCharacteristicWriteWithResponse];
  }
  else if (otaBytesWrittenInTrailer != 160)
  {
    data = [otaImage subdataWithRange:NSMakeRange(otaImageActualLength+otaBytesWrittenInTrailer, 20)];
    otaBytesWrittenInTrailer = otaBytesWrittenInTrailer + 20;
    [_debugPayload appendData:data];
    [self.peripheral writeValue:data forCharacteristic:characteristic.bleCharacteristic type:CBCharacteristicWriteWithResponse];
  }
  else
  {
    [stateMachine fireEvent:otaEventFailed userInfo:@{@"error":@"writeBleImageBytes:byte issue"} error:nil];
  }
  
}

-(void)writeStartOta
{
  FSTBleCharacteristic* characteristic = [self.characteristics objectForKey:FSTCharacteristicOtaControlCommand];
  
  Byte bytes[1];
  bytes[0] = 0x01;
  NSData *data = [[NSData alloc]initWithBytes:bytes length:sizeof(bytes)];
  if (characteristic)
  {
    [self.peripheral writeValue:data forCharacteristic:characteristic.bleCharacteristic type:CBCharacteristicWriteWithResponse];
  }
}

-(void)writeOtaStartDownloadBleCommand
{
  FSTBleCharacteristic* characteristic = [self.characteristics objectForKey:FSTCharacteristicOtaControlCommand];
  
  if (otaImage.length > 160 && otaImage.length < (60*1024))
  {
    Byte bytes[3];
    bytes[0] = 0x02;
    
    //if the size is 10245, data[1] = 0x05, data[2] = 0x28
    OSWriteLittleInt16(&bytes[1],   0, otaImage.length);
    NSData *data = [[NSData alloc]initWithBytes:bytes length:sizeof(bytes)];
    
    NSLog(@"read image from file system, length is %lu, byte[1] = 0x%02x, byte[2] = 0x%02x", (unsigned long)otaImage.length, bytes[1], bytes[2]);
    if (characteristic)
    {
      [self.peripheral writeValue:data forCharacteristic:characteristic.bleCharacteristic type:CBCharacteristicWriteWithResponse];
    }
  }
  else
  {
    [stateMachine fireEvent:otaEventFailed userInfo:@{@"error":@"writeOtaStartDownloadBleCommand:image length incorrect"} error:nil];
  }
  
}

-(void)writeOtaStartDownloadApplicationCommand
{
  FSTBleCharacteristic* characteristic = [self.characteristics objectForKey:FSTCharacteristicOtaImageData];
  
  if (otaImage.length > 0)
  {
    Byte bytes[20];
    memset(bytes,0,20);
    //app image type
    bytes[0] = 0x01;
    
    //app version
    bytes[1] = 0x01;
    bytes[2] = 0x00;
    bytes[3] = 0x00;
    bytes[4] = 0x02;
    
    bytes[5] = 0x20;
    bytes[6] = 0xf4;
    bytes[7] = 0x00;
    bytes[8] = 0x00;
    
    //file size
//    bytes[5] = (otaImage.length>>24)&0xFF;
//    bytes[6] = (otaImage.length>>16)&0xFF;
//    bytes[7] = (otaImage.length>>8)&0xFF;
//    bytes[8] = (otaImage.length>>0)&0xFF;
//    OSWriteLittleInt32(bytes, 5, otaImage.length);
    NSData *data = [[NSData alloc]initWithBytes:bytes length:sizeof(bytes)];
    
    NSLog(@"read app image from file system, length is %lu,  0x%02x, 0x%02x, 0x%02x, 0x%02x", (unsigned long)otaImage.length, bytes[5], bytes[6], bytes[7], bytes[8]);
    
    if (characteristic)
    {
      [self.peripheral writeValue:data forCharacteristic:characteristic.bleCharacteristic type:CBCharacteristicWriteWithResponse];
    }
  }
}

-(void)writeOtaImageVerify
{
  FSTBleCharacteristic* characteristic = [self.characteristics objectForKey:FSTCharacteristicOtaControlCommand];
  
  Byte bytes[1];
  bytes[0] = 0x03;
  NSData *data = [[NSData alloc]initWithBytes:bytes length:sizeof(bytes)];
  if (characteristic)
  {
    [self.peripheral writeValue:data forCharacteristic:characteristic.bleCharacteristic type:CBCharacteristicWriteWithResponse];
  }
}

# pragma mark - read handler
-(void)readHandler: (FSTBleCharacteristic*)characteristic
{
  [super readHandler:characteristic];
  
  if([[[characteristic.bleCharacteristic UUID] UUIDString] isEqualToString:FSTCharacteristicOtaControlCommand])
  {
    NSLog(@"char: FSTCharacteristicOtaControlCommand, data: %@", characteristic.bleCharacteristic.value);
    [self handleOtaControlCommandReadResponse:characteristic];
  }
  else if([[[characteristic.bleCharacteristic UUID] UUIDString] isEqualToString:FSTCharacteristicOtaAppUpdateStatus])
  {
    NSLog(@"char: FSTCharacteristicOtaAppUpdateStatus, data: %@", characteristic.bleCharacteristic.value);
    [self handleOtaAppUpdateReadResponse:characteristic];
  }
  else if([[[characteristic.bleCharacteristic UUID] UUIDString] isEqualToString:FSTCharacteristicOtaImageType])
  {
    NSLog(@"char: FSTCharacteristicOtaImageType, data: %@", characteristic.bleCharacteristic.value);
    [self handleOtaImageTypeReadResponse:characteristic];
  }
}

-(void)handleOtaAppUpdateReadResponse: (FSTBleCharacteristic*)characteristic
{
  if (characteristic.bleCharacteristic.value.length != 1)
  {
    [stateMachine fireEvent:otaEventFailed userInfo:@{@"error":@"handleOtaAppUpdateReadResponse:incorrect data length"} error:nil];
    return;
  }
  
  NSData *data = characteristic.bleCharacteristic.value;
  Byte bytes[characteristic.bleCharacteristic.value.length] ;
  [data getBytes:bytes length:characteristic.bleCharacteristic.value.length];
  applicationFlashPercent = bytes[0];
  NSLog(@"percent: %lu", (unsigned long)applicationFlashPercent);
  
}

-(void)handleOtaImageTypeReadResponse: (FSTBleCharacteristic*)characteristic
{
  if (characteristic.bleCharacteristic.value.length != 1)
  {
    [stateMachine fireEvent:otaEventFailed userInfo:@{@"error":@"handleOtaImageTypeReadResponse data length"} error:nil];
    return;
  }
  
  NSData *data = characteristic.bleCharacteristic.value;
  Byte bytes[characteristic.bleCharacteristic.value.length] ;
  [data getBytes:bytes length:characteristic.bleCharacteristic.value.length];
  
  if (bytes[0] == 0x01) {
    actualOtaImageType = OtaImageTypeApplication;
  } else if(bytes[0] == 0x00) {
    actualOtaImageType = OtaImageTypeBle;
  } else if(bytes[0] == 0xFF) {
    actualOtaImageType = OtaImageTypeNone;
  } else {
    actualOtaImageType = OtaImageTypeUnknown;
    [stateMachine fireEvent:otaEventFailed userInfo:@{@"error":@"handleOtaImageTypeReadResponse image type unknown"} error:nil];
    return;
  }
}

-(void)handleOtaControlCommandReadResponse: (FSTBleCharacteristic*)characteristic
{
  if (characteristic.bleCharacteristic.value.length != 1)
  {
    [stateMachine fireEvent:otaEventFailed userInfo:@{@"error":@"handleOtaControlCommandReadResponse:incorrect data length"} error:nil];
    return;
  }
  
  NSData *data = characteristic.bleCharacteristic.value;
  Byte bytes[characteristic.bleCharacteristic.value.length] ;
  [data getBytes:bytes length:characteristic.bleCharacteristic.value.length];
  uint8_t response = bytes[0];
  
  if (response==0)
  {
    if (stateMachine.currentState==otaStateDownloadBleStart)
    {
      [stateMachine fireEvent:otaEventDownloadReady userInfo:nil error:nil];
    }
    else if (stateMachine.currentState==otaStateStartRequested)
    {
      //ble says we are good to commence an OTA. need to decide if this is an application ota
      //or ble ota. ble ota will require an additional command to be written, but the application ota
      //begins straight-away, but requires a 20 byte header to be sent first
      if (requestedOtaImageType==OtaImageTypeBle) {
        [stateMachine fireEvent:otaEventStartBleOta userInfo:nil error:nil];
      } else {
        [stateMachine fireEvent:otaEventStartApplicationOta userInfo:nil error:nil];
      }
      
    }
    else if (stateMachine.currentState==otaStateVerifyImageRequest)
    {
      
    }
    else if (stateMachine.currentState==otaStateIdle)
    {
      NSLog(@"handleOtaControlCommandReadResponse, idle");
    }
    else if (stateMachine.currentState==otaStateStart)
    {
      NSLog(@"handleOtaControlCommandReadResponse, start");
    }
    else
    {
      [stateMachine fireEvent:otaEventFailed userInfo:@{@"error":@"handleOtaControlCommandReadResponse,unknown state"} error:nil];
    }
  }
  else
  {
    [stateMachine fireEvent:otaEventFailed userInfo:@{@"error":@"handleOtaControlCommandReadResponse,device reported error in control command"} error:nil];
  }
  
}

#pragma mark - external
- (void)startOta
{
  dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 5 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
    requestedOtaImageType = OtaImageTypeApplication;
    [stateMachine fireEvent:otaEventStart userInfo:nil error:nil];
  });
}

- (void)abortOta
{
  [stateMachine fireEvent:otaEventInitialize userInfo:nil error:nil];
  [self writeOtaAbort];
}

#pragma mark - discovery
-(void)handleDiscoverCharacteristics: (NSArray*)characteristics
{
  [super handleDiscoverCharacteristics:characteristics];
  
  ((FSTBleCharacteristic*)[self.characteristics objectForKey:FSTCharacteristicOtaControlCommand]).requiresValue = YES;
  ((FSTBleCharacteristic*)[self.characteristics objectForKey:FSTCharacteristicOtaImageType]).requiresValue = YES;
  ((FSTBleCharacteristic*)[self.characteristics objectForKey:FSTCharacteristicOtaAppUpdateStatus]).requiresValue = YES;
  
  ((FSTBleCharacteristic*)[self.characteristics objectForKey:FSTCharacteristicOtaAppUpdateStatus]).wantNotification = YES;
  ((FSTBleCharacteristic*)[self.characteristics objectForKey:FSTCharacteristicOtaControlCommand]).wantNotification = YES;
  
}

- (void) deviceReady
{
  [super deviceReady];
}


@end
