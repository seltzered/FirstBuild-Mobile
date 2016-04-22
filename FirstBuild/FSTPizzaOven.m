//
//  FSTPizzaOven.m
//  FirstBuild
//
//  Created by Myles Caley on 10/5/15.
//  Copyright © 2015 FirstBuild. All rights reserved.
//

#import "FSTPizzaOven.h"

@implementation FSTPizzaOven
{
//    NSMutableDictionary *requiredCharacteristics; // a dictionary of strings with booleans
  
    NSNumber *currentSetPoint;
    NSNumber *currentDisplayTemperature;
}

NSString * const FSTCharacteristicPizzaOvenDisplayTemperature = @"13333333-3333-3333-3333-333333330003";
NSString * const FSTCharacteristicPizzaOvenSetTemperature = @"35D00001-E537-11E5-8390-0002A5D5C51B";

- (id)init
{
    self = [super init];
    
    if (self)
    {

        // booleans for all the required characteristics, tell us whether or not the characteristic loaded
//        requiredCharacteristics = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
//                                   [[NSNumber alloc] initWithBool:0], FSTCharacteristicPizzaOvenDisplayTemperature,
//                                   [[NSNumber alloc] initWithBool:0], FSTCharacteristicPizzaOvenSetTemperature,
//                                   nil];
        currentSetPoint = [[NSNumber alloc] initWithDouble:rintf((float)0)];
        currentDisplayTemperature =[[NSNumber alloc] initWithDouble:rintf((float)0)];
    }
    
    return self;
}

-(void)writeHandler: (FSTBleCharacteristic*)characteristic error:(NSError *)error
{
    [super writeHandler:characteristic error:error];
    
//    if([[[characteristic UUID] UUIDString] isEqualToString: FSTCharacteristicOvenWrite])
//    {
//        DLog(@"successfully wrote FSTCharacteristicOvenWrite");
//        //[self handleCooktimeWritten];
//    }
}

-(void)readHandler: (FSTBleCharacteristic*)characteristic
{
    [super readHandler:characteristic];
    
    if ([[[characteristic.bleCharacteristic UUID] UUIDString] isEqualToString: FSTCharacteristicPizzaOvenDisplayTemperature])
    {
        NSLog(@"char: FSTCharacteristicPizzaOvenDisplayTemperature, data: %@", characteristic.bleCharacteristic.value);
        [self handleDisplayTemperature:characteristic];
    }

    if ([[[characteristic.bleCharacteristic UUID] UUIDString] isEqualToString: FSTCharacteristicPizzaOvenSetTemperature])
    {
        NSLog(@"char: FSTCharacteristicPizzaOvenSetTemperature, data: %@", characteristic.bleCharacteristic.value);
        [self handleSetTemperature:characteristic];
    }
}

-(void)handleSetTemperature: (FSTBleCharacteristic*)characteristic
{
    
  if (characteristic.bleCharacteristic.value.length != 2)
  {
    DLog(@"handleDisplayTemperature length of %lu not what was expected, %d", (unsigned long)characteristic.bleCharacteristic.value.length, 2);
    return;
  }
  
  NSData *data = characteristic.bleCharacteristic.value;
  Byte bytes[characteristic.bleCharacteristic.value.length] ;
  [data getBytes:bytes length:characteristic.bleCharacteristic.value.length];
  uint16_t raw = OSReadBigInt16(bytes, 0);
    
  currentSetPoint = [[NSNumber alloc] initWithDouble:rintf((float)raw)];

  if ([self.delegate respondsToSelector:@selector(setTemperatureChanged:)])
  {
    [self.delegate setTemperatureChanged:currentSetPoint];
  }
}

-(void)handleDisplayTemperature: (FSTBleCharacteristic*)characteristic
{
    if (characteristic.bleCharacteristic.value.length != 2)
    {
        DLog(@"handleDisplayTemperature length of %lu not what was expected, %d", (unsigned long)characteristic.bleCharacteristic.value.length, 2);
        return;
    }
    
    NSData *data = characteristic.bleCharacteristic.value;
    Byte bytes[characteristic.bleCharacteristic.value.length] ;
    [data getBytes:bytes length:characteristic.bleCharacteristic.value.length];
    uint16_t raw = OSReadBigInt16(bytes, 0);
    
    currentDisplayTemperature = [[NSNumber alloc] initWithDouble:rintf((float)raw)];
    if ([self.delegate respondsToSelector:@selector(displayTemperatureChanged:)])
    {
        [self.delegate displayTemperatureChanged:currentDisplayTemperature];
    } 
}

#pragma mark - Characteristic Discovery Handler

    
/**
 *  call method called when characteristics are discovered
 *
 *  @param characteristics an array of the characteristics
 */
-(void) handleDiscoverCharacteristics: (NSMutableArray*)characteristics
{
    [super handleDiscoverCharacteristics:characteristics];
    
    //TODO: set required characteristics here, see FSTOpal.m > handleDiscoverCharacteristics
}

- (NSNumber*)getCurrentSetTemperature
{
    return currentSetPoint;
}

- (void)setCurrentSetTemperature: (NSNumber*) setTemperature
{
    NSLog(@"Attempting to set the current temperature to %@", [setTemperature stringValue]);
    FSTBleCharacteristic* characteristic = [self.characteristics objectForKey:FSTCharacteristicPizzaOvenSetTemperature];
    
    uint16_t val = setTemperature.unsignedShortValue;

    Byte bytes[2];
    bytes[0] = (val>>8)&0xff;
    bytes[1] = (val)&0xff;
    
    NSData *data = [[NSData alloc]initWithBytes:bytes length:sizeof(bytes)];
    if (characteristic)
    {
        [self.peripheral writeValue:data forCharacteristic:characteristic.bleCharacteristic type:CBCharacteristicWriteWithResponse];
    }
}

- (NSNumber*)getCurrentDisplayTemperature
{
    return currentDisplayTemperature;
}

@end
