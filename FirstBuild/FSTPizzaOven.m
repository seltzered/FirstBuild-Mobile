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
    NSMutableDictionary *requiredCharacteristics; // a dictionary of strings with booleans
}

NSString * const FSTCharacteristicPizzaOvenDisplayTemperature = @"13333333-3333-3333-3333-333333330003";

- (id)init
{
    self = [super init];
    
    if (self)
    {

        // booleans for all the required characteristics, tell us whether or not the characteristic loaded
        requiredCharacteristics = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                   [[NSNumber alloc] initWithBool:0], FSTCharacteristicPizzaOvenDisplayTemperature,
                                   nil];
    }
    
    return self;
}

-(void)writeHandler: (CBCharacteristic*)characteristic error:(NSError *)error
{
    [super writeHandler:characteristic error:error];
    
//    if([[[characteristic UUID] UUIDString] isEqualToString: FSTCharacteristicOvenWrite])
//    {
//        DLog(@"successfully wrote FSTCharacteristicOvenWrite");
//        //[self handleCooktimeWritten];
//    }
}

-(void)readHandler: (CBCharacteristic*)characteristic
{
    [super readHandler:characteristic];
    
    if ([[[characteristic UUID] UUIDString] isEqualToString: FSTCharacteristicPizzaOvenDisplayTemperature])
    {
        NSLog(@"char: FSTCharacteristicPizzaOvenDisplayTemperature, data: %@", characteristic.value);
        [requiredCharacteristics setObject:[NSNumber numberWithBool:1] forKey:FSTCharacteristicPizzaOvenDisplayTemperature];
        [self handleDisplayTemperature:characteristic];
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

-(void)handleDisplayTemperature: (CBCharacteristic*)characteristic
{
 
  if (characteristic.value.length != 2)
  {
    DLog(@"handleDisplayTemperature length of %lu not what was expected, %d", (unsigned long)characteristic.value.length, 2);
    return;
  }
  
  NSData *data = characteristic.value;
  Byte bytes[characteristic.value.length] ;
  [data getBytes:bytes length:characteristic.value.length];
  uint16_t raw = OSReadBigInt16(bytes, 0);
  
  NSNumber* displayTemperature = [[NSNumber alloc] initWithDouble:rintf((float)raw)];
  if ([self.delegate respondsToSelector:@selector(displayTemperatureChanged:)])
  {
    [self.delegate displayTemperatureChanged:displayTemperature];
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
    [requiredCharacteristics setObject:[NSNumber numberWithBool:0] forKey:FSTCharacteristicPizzaOvenDisplayTemperature];
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
                 [[[characteristic UUID] UUIDString] isEqualToString: FSTCharacteristicPizzaOvenDisplayTemperature]
                 )
            {
                [self.peripheral readValueForCharacteristic:characteristic];
            }
            NSLog(@"        CAN NOTIFY");
        }
        
        if (characteristic.properties & CBCharacteristicPropertyRead)
        {
            NSLog(@"        CAN READ");
        }
        
        if (characteristic.properties & CBCharacteristicPropertyWriteWithoutResponse)
        {
            NSLog(@"        CAN WRITE WITHOUT RESPONSE");
        }
    }
}

@end
