//
//  FSTGeBleProduct.m
//  FirstBuild
//
//  Created by Myles Caley on 4/18/16.
//  Copyright © 2016 FirstBuild. All rights reserved.
//

#import "FSTGeBleProduct.h"

typedef enum {
  OtaStateIdle = 0,
  OtaStateSetImageType = 1,
  OtaStateStartRequested = 2,
  OtaStateDownloadRequested = 3,
  OtaStateDownloading = 4,
  OtaStateChunkWriteRequest = 10,
  OtaStateVerifyImageRequest = 11,
  OtaStateAbortRequested = 400,
  OtaStateFailed = 500
} OtaState;

//firmware
NSString * const FSTCharacteristicOtaControlCommand     = @"4FB34AB1-6207-E5A0-484F-E24A7F638FFF"; //write,notify
NSString * const FSTCharacteristicOtaImageData          = @"78282AE5-3060-C3B6-7D49-EC74702414E5"; //write
NSString * const FSTCharacteristicOtaImageType          = @"5EA370C7-2059-41DB-9999-36527B43A4B4"; //read,write
NSString * const FSTCharacteristicOtaAppUpdateStatus    = @"14FF6DFB-36FA-4456-927D-759E1A9A8446"; //read,notify


@implementation FSTGeBleProduct
{
  NSData* otaImage;
  BOOL otaIsApplicationImage;
  OtaState otaState;
  NSUInteger otaBytesWritten;
  uint otaBytesWrittenInTrailer;
  
  NSMutableData* _debugPayload;
}

- (instancetype)init
{
  self = [super init];
  if (self) {
    _debugPayload = [NSMutableData new];
    otaState = OtaStateIdle;
    otaBytesWritten = 0;
    otaBytesWrittenInTrailer = 0;
    otaIsApplicationImage = NO;
  }
  return self;
}

# pragma mark - helper functions
-(void)readOtaFileFromBundle
{
//  NSString *otaFileName = [[NSBundle mainBundle] pathForResource:@"opal_ble_1_02_00_00" ofType:@"ota"];
  NSString *otaFileName = [[NSBundle mainBundle] pathForResource:@"opal_61k" ofType:@"ota"];
  otaImage = [NSData dataWithContentsOfFile:otaFileName];
}

# pragma mark - write handlers
-(void)writeHandler:(CBCharacteristic *)characteristic error:(NSError *)error
{
  [super writeHandler:characteristic error:error];
  if([[[characteristic UUID] UUIDString] isEqualToString: FSTCharacteristicOtaImageData])
  {
    [self handleOtaImageDataWriteResponse:error];
  }
  else if ([[[characteristic UUID] UUIDString] isEqualToString: FSTCharacteristicOtaImageType])
  {
    [self handleOtaImageTypeWriteResponse:error];
  }
}

-(void)handleOtaImageTypeWriteResponse: (NSError*) error
{
  if (error || otaState != OtaStateSetImageType)
  {
    otaState = OtaStateFailed;
    NSLog(@"image type write error");
    return;
  }
  
  [self writeStartOta];
}

-(void)handleOtaImageDataWriteResponse: (NSError*) error
{
  if (error || otaState != OtaStateChunkWriteRequest)
  {
    otaState = OtaStateFailed;
    NSLog(@"image data write error");
    return;
  }
  
  if (otaBytesWrittenInTrailer == 160)
  {
    [self writeOtaImageVerify];
  }
  else if (otaIsApplicationImage && count==otaImage.length)
  {
    [self writeOtaImageVerify];
  }
  else
  {
    otaBytesWritten = count;
    //otaBytesWritten = otaBytesWritten + 20;
    otaState = OtaStateDownloading;
    [self writeImageBytes];
    //printf(".");
  }
}

#pragma mark - write

-(void)writeOtaAbort
{
  otaState = OtaStateFailed;
  
  NSLog(@">>>>>>>>> abort OTA <<<<<<<<<<");
  CBCharacteristic* characteristic = [self.characteristics objectForKey:FSTCharacteristicOtaControlCommand];
  
  Byte bytes[1];
  bytes[0] = 0x07;
  NSData *data = [[NSData alloc]initWithBytes:bytes length:sizeof(bytes)];
  if (characteristic)
  {
    otaState = OtaStateAbortRequested;
    [self.peripheral writeValue:data forCharacteristic:characteristic type:CBCharacteristicWriteWithResponse];
  }
}

-(void)writeImageIsApplicationType: (BOOL)isApplicationImage
{
  otaState = OtaStateFailed;
  otaIsApplicationImage = isApplicationImage;
  
  CBCharacteristic* characteristic = [self.characteristics objectForKey:FSTCharacteristicOtaImageType];
  Byte bytes[1];
  
  if (otaIsApplicationImage) {
    bytes[0] = 0x01;
  } else {
    bytes[0] = 0x00;
  }
  
  NSData *data = [[NSData alloc]initWithBytes:bytes length:sizeof(bytes)];
  if (characteristic)
  {
    otaState = OtaStateSetImageType;
    [self.peripheral writeValue:data forCharacteristic:characteristic type:CBCharacteristicWriteWithResponse];
  }
}

-(void)writeImageBytes
{
  CBCharacteristic* characteristic = [self.characteristics objectForKey:FSTCharacteristicOtaImageData];
  
  if (characteristic && otaState == OtaStateDownloading && otaImage.length > 0)
  {
    if (otaBytesWritten > 0 && otaBytesWritten%500==0)
    {
      NSLog(@"written %lu", (unsigned long)otaBytesWritten);
    }
    
    if (otaIsApplicationImage == YES) {
      [self writeApplicationImageBytes];
    } else {
      [self writeBleImageBytes];
    }
  }
  else
  {
    otaState = OtaStateFailed;
    NSLog(@"ota failed during image write, unknown state");
  }
  
}

NSUInteger count = 0;

-(void)writeApplicationImageBytes
{
  NSData* data;
  CBCharacteristic* characteristic = [self.characteristics objectForKey:FSTCharacteristicOtaImageData];
  
  if (otaBytesWritten <= otaImage.length)
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
      //otaBytesWritten = otaImage.length;
      
      NSLog(@"final bytes");
    }
    else
    {
      // normal
      data = [otaImage subdataWithRange:NSMakeRange(otaBytesWritten, 20)];
    }
    
    otaState = OtaStateChunkWriteRequest;
    [_debugPayload appendData:data];
    count = count + data.length;
    printf("%lu,",(unsigned long)count);
    [self.peripheral writeValue:data forCharacteristic:characteristic type:CBCharacteristicWriteWithResponse];
    
  }
}


-(void)writeBleImageBytes
{
  NSUInteger otaImageActualLength = otaImage.length - 160;
  NSData* data;
  CBCharacteristic* characteristic = [self.characteristics objectForKey:FSTCharacteristicOtaImageData];
  
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
    otaState = OtaStateChunkWriteRequest;
    [_debugPayload appendData:data];
    [self.peripheral writeValue:data forCharacteristic:characteristic type:CBCharacteristicWriteWithResponse];
  }
  else if (otaBytesWrittenInTrailer != 160)
  {
    data = [otaImage subdataWithRange:NSMakeRange(otaImageActualLength+otaBytesWrittenInTrailer, 20)];
    otaBytesWrittenInTrailer = otaBytesWrittenInTrailer + 20;
    otaState = OtaStateChunkWriteRequest;
    [_debugPayload appendData:data];
    [self.peripheral writeValue:data forCharacteristic:characteristic type:CBCharacteristicWriteWithResponse];
  }
  else
  {
    otaState = OtaStateFailed;
    NSLog(@"ota failed during image write, byte issue");
  }
  
}

-(void)writeStartOta
{
  otaState = OtaStateFailed;
  
  otaBytesWritten = 0;
  
  NSLog(@">>>>>>>>> start OTA <<<<<<<<<<");
  CBCharacteristic* characteristic = [self.characteristics objectForKey:FSTCharacteristicOtaControlCommand];
  
  Byte bytes[1];
  bytes[0] = 0x01;
  NSData *data = [[NSData alloc]initWithBytes:bytes length:sizeof(bytes)];
  if (characteristic)
  {
    otaState = OtaStateStartRequested;
    [self.peripheral writeValue:data forCharacteristic:characteristic type:CBCharacteristicWriteWithResponse];
  }
}



-(void)writeOtaDownloadCommand
{
  otaState = OtaStateFailed;
  
  [self readOtaFileFromBundle];
  
  if (otaIsApplicationImage == NO)
  {
    [self writeOtaDownloadBleCommand];
  }
  else
  {
    [self writeOtaDownloadApplicationCommand];
  }
  
}

-(void)writeOtaDownloadBleCommand
{
  CBCharacteristic* characteristic = [self.characteristics objectForKey:FSTCharacteristicOtaControlCommand];
  NSLog(@">>>>>>>>> start OTA download - BLE <<<<<<<<<<");
  
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
      otaState = OtaStateDownloadRequested;
      [self.peripheral writeValue:data forCharacteristic:characteristic type:CBCharacteristicWriteWithResponse];
    }
  }
  else
  {
    NSLog(@"image size is incorrect");
  }
  
}

-(void)writeOtaDownloadApplicationCommand
{
  CBCharacteristic* characteristic = [self.characteristics objectForKey:FSTCharacteristicOtaImageData];
  
  NSLog(@">>>>>>>>> start OTA download - application <<<<<<<<<<");
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
    bytes[4] = 0x01;
    
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
      otaState = OtaStateChunkWriteRequest;
      [self.peripheral writeValue:data forCharacteristic:characteristic type:CBCharacteristicWriteWithResponse];
    }
  }
}

-(void)writeOtaImageVerify
{
  NSLog(@">>>>>>>>> image Verify <<<<<<<<<<");
  
  CBCharacteristic* characteristic = [self.characteristics objectForKey:FSTCharacteristicOtaControlCommand];
  
  otaState = OtaStateFailed;
  
  Byte bytes[1];
  bytes[0] = 0x03;
  NSData *data = [[NSData alloc]initWithBytes:bytes length:sizeof(bytes)];
  if (characteristic)
  {
    otaState = OtaStateVerifyImageRequest;
    [self.peripheral writeValue:data forCharacteristic:characteristic type:CBCharacteristicWriteWithResponse];
  }
}

# pragma mark - read handler
-(void)readHandler: (CBCharacteristic*)characteristic
{
  [super readHandler:characteristic];
  
  if([[[characteristic UUID] UUIDString] isEqualToString:FSTCharacteristicOtaControlCommand])
  {
    NSLog(@"char: FSTCharacteristicOtaControlCommand, data: %@", characteristic.value);
    [self handleOtaControlCommandReadResponse:characteristic];
  }
  else if([[[characteristic UUID] UUIDString] isEqualToString:FSTCharacteristicOtaAppUpdateStatus])
  {
    NSLog(@"char: FSTCharacteristicOtaAppUpdateStatus, data: %@", characteristic.value);
    [self handleOtaAppUpdateReadResponse:characteristic];
  }
}

-(void)handleOtaAppUpdateReadResponse: (CBCharacteristic*)characteristic
{
  if (characteristic.value.length != 1)
  {
    DLog(@"handleOtaAppUpdateReadResponse length of %lu not what was expected, %d", (unsigned long)characteristic.value.length, 1);
    return;
  }
  
  NSData *data = characteristic.value;
  Byte bytes[characteristic.value.length] ;
  [data getBytes:bytes length:characteristic.value.length];
  uint8_t percent = bytes[0];
  
  NSLog(@"percent: %d", percent);
  
}

-(void)handleOtaControlCommandReadResponse: (CBCharacteristic*)characteristic
{
  if (characteristic.value.length != 1)
  {
    DLog(@"handleOtaControlCommand length of %lu not what was expected, %d", (unsigned long)characteristic.value.length, 1);
    return;
  }
  
  NSData *data = characteristic.value;
  Byte bytes[characteristic.value.length] ;
  [data getBytes:bytes length:characteristic.value.length];
  uint8_t response = bytes[0];
  
  if (response==0)
  {
    switch (otaState) {
      case OtaStateDownloadRequested:
        otaState = OtaStateDownloading;
        [self writeImageBytes];
        break;
        
      case OtaStateStartRequested:
        [self writeOtaDownloadCommand];
        break;
        
      case OtaStateAbortRequested:
        NSLog(@">>>>>>>>> aborted OTA <<<<<<<<<<");
        otaState = OtaStateIdle;
        break;
        
      case OtaStateVerifyImageRequest:
        break;
        
      default:
        NSLog(@"unknown ota state in handleOtaControlCommand");
        break;
    }
    
  }
  else
  {
    NSLog(@"ota command response indicated failure during state %d", otaState);
  }
  
}

#pragma mark - external
- (void)startOta
{
  dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 5 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
    [self writeImageIsApplicationType:YES];
  });
}


#pragma mark - discovery

-(void)handleDiscoverCharacteristics: (NSArray*)characteristics
{
  [super handleDiscoverCharacteristics:characteristics];
  
  NSLog(@"=========================== OTA =========================================");
  //NSLog(@"SERVICE %@", [service.UUID UUIDString]);
  
  for (CBCharacteristic *characteristic in characteristics)
  {
    NSLog(@"    CHARACTERISTIC %@", [characteristic.UUID UUIDString]);
    
    if (characteristic.properties & CBCharacteristicPropertyWrite)
    {
      NSLog(@"        CAN WRITE");
    }
    
    if (characteristic.properties & CBCharacteristicPropertyNotify)
    {
      if ([[[characteristic UUID] UUIDString] isEqualToString: FSTCharacteristicOtaControlCommand])
      {
        [self.peripheral setNotifyValue:YES forCharacteristic:characteristic ];
      }
      else if ([[[characteristic UUID] UUIDString] isEqualToString: FSTCharacteristicOtaAppUpdateStatus])
      {
        [self.peripheral setNotifyValue:YES forCharacteristic:characteristic ];
      }
      NSLog(@"        CAN NOTIFY");
    }
  }
}


@end
