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
  OtaStateStartRequested = 1,
  OtaStateDownloadRequested = 2,
  OtaStateDownloading = 3,
  OtaStateChunkWriteRequest = 10,
  OtaStateVerifyImageRequest = 11,
  OtaStateAbortRequested = 400,
  OtaStateFailed = 500
} OtaState;

//firmware
NSString * const FSTCharacteristicOtaControlCommand     = @"4FB34AB1-6207-E5A0-484F-E24A7F638FFF"; //write,notify
NSString * const FSTCharacteristicOtaImageData          = @"78282AE5-3060-C3B6-7D49-EC74702414E5"; //write

@implementation FSTGeBleProduct
{
  NSData* otaImage;
  OtaState otaState;
  uint otaBytesWritten;
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
  }
  return self;
}

-(void)writeHandler:(CBCharacteristic *)characteristic error:(NSError *)error
{
  [super writeHandler:characteristic error:error];
  if([[[characteristic UUID] UUIDString] isEqualToString: FSTCharacteristicOtaImageData])
  {
    [self handleOtaImageDataResponse:error];
  }
}


// TODO: TEMPORARY

-(void)readOtaFileFromBundle
{
  NSString *otaFileName = [[NSBundle mainBundle] pathForResource:@"paragon_master_01_03_00_00" ofType:@"ota"];
  otaImage = [NSData dataWithContentsOfFile:otaFileName];
}

-(void)handleOtaControlCommand: (CBCharacteristic*)characteristic
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

-(void)handleOtaImageDataResponse: (NSError*) error
{
  if (error || otaState != OtaStateChunkWriteRequest)
  {
    otaState = OtaStateFailed;
    NSLog(@"image write error");
    return;
  }
  
  if (otaBytesWrittenInTrailer == 160)
  {
    [self writeOtaImageVerify];
  }
  else
  {
    otaBytesWritten = otaBytesWritten + 20;
    otaState = OtaStateDownloading;
    [self writeImageBytes];
    printf(".");
  }
}

-(void)writeImageBytes
{
  CBCharacteristic* characteristic = [self.characteristics objectForKey:FSTCharacteristicOtaImageData];
  
  if (characteristic && otaState == OtaStateDownloading && otaImage.length > 0)
  {
    if (otaBytesWritten > 0 && otaBytesWritten%500==0)
    {
      NSLog(@"written %u", otaBytesWritten);
    }
    
    NSUInteger otaImageActualLength = otaImage.length - 160;
    NSData* data;
    
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
  else
  {
    otaState = OtaStateFailed;
    NSLog(@"ota failed during image write, unknown state");
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
  NSLog(@">>>>>>>>> start OTA download <<<<<<<<<<");
  otaState = OtaStateFailed;
  CBCharacteristic* characteristic = [self.characteristics objectForKey:FSTCharacteristicOtaControlCommand];
  
  [self readOtaFileFromBundle];
  
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

- (void)startOta
{
  dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 5 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
    [self writeStartOta];
  });
}

-(void)readHandler: (CBCharacteristic*)characteristic
{
  [super readHandler:characteristic];
  
  if([[[characteristic UUID] UUIDString] isEqualToString:FSTCharacteristicOtaControlCommand])
  {
    NSLog(@"char: FSTCharacteristicOtaControlCommand, data: %@", characteristic.value);
    [self handleOtaControlCommand:characteristic];
  }

}



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
      NSLog(@"        CAN NOTIFY");
    }
  }
}


@end
