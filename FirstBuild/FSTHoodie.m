//
//  FSTHoodie.m
//  FirstBuild
//
//  Created by Myles Caley on 10/5/15.
//  Copyright © 2015 FirstBuild. All rights reserved.
//

#import "FSTHoodie.h"

@implementation FSTHoodie

NSString * const FSTCharacteristicHoodieWrite =  @"713D0003-503E-4C75-BA94-3148F18D941E";
NSString * const FSTCharacteristicHoodieNotify = @"713D0002-503E-4C75-BA94-3148F18D941E";

NSString * const FSTCharacteristicBatteryLevelHoodie     = @"2A19"; //read,notify

NSMutableDictionary *requiredCharacteristics; // a dictionary of strings with booleans
__weak NSTimer* _readCharacteristicsTimer;

- (id)init
{
    self = [super init];
    
    if (self)
    {

        // booleans for all the required characteristics, tell us whether or not the characteristic loaded
        requiredCharacteristics = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                   [[NSNumber alloc] initWithBool:0], FSTCharacteristicHoodieNotify,
                                   nil];
    }
    
    return self;
}

-(void)writeHandler: (CBCharacteristic*)characteristic
{
    [super writeHandler:characteristic];
    
    if([[[characteristic UUID] UUIDString] isEqualToString: FSTCharacteristicHoodieWrite])
    {
        DLog(@"successfully wrote FSTCharacteristicHoodieWrite");
        //[self handleCooktimeWritten];
    }
}

-(void)readHandler: (CBCharacteristic*)characteristic
{
    [super readHandler:characteristic];
    
    if ([[[characteristic UUID] UUIDString] isEqualToString: FSTCharacteristicHoodieNotify])
    {
        NSLog(@"char: FSTCharacteristicHoodieNotify, data: %@", characteristic.value);
        [requiredCharacteristics setObject:[NSNumber numberWithBool:1] forKey:FSTCharacteristicHoodieNotify];
    }
    else if([[[characteristic UUID] UUIDString] isEqualToString: FSTCharacteristicBatteryLevelHoodie])
    {
        [self handleBatteryLevel:characteristic];
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

-(void)handleBatteryLevel: (CBCharacteristic*)characteristic
{
    if (characteristic.value.length != 1)
    {
        DLog(@"handleBatteryLevel length of %lu not what was expected, %d", (unsigned long)characteristic.value.length, 1);
        return;
    }
    
    NSData *data = characteristic.value;
    Byte bytes[characteristic.value.length] ;
    [data getBytes:bytes length:characteristic.value.length];
    self.batteryLevel = [NSNumber numberWithUnsignedInt:bytes[0]];
    
    //NSLog(@"FSTCharacteristicBatteryLevel: %@", self.batteryLevel );
    [[NSNotificationCenter defaultCenter] postNotificationName:FSTBatteryLevelChangedNotification  object:self];
}

/**
 *  call method called when characteristics are discovered
 *
 *  @param characteristics an array of the characteristics
 */
-(void)handleDiscoverCharacteristics: (NSArray*)characteristics
{
    [super handleDiscoverCharacteristics:characteristics];
    
    self.initialCharacteristicValuesRead = NO;
    [requiredCharacteristics setObject:[NSNumber numberWithBool:0] forKey:FSTCharacteristicHoodieNotify];
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
                 [[[characteristic UUID] UUIDString] isEqualToString: FSTCharacteristicHoodieNotify] ||
                 [[[characteristic UUID] UUIDString] isEqualToString: FSTCharacteristicBatteryLevelHoodie]
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

- (void) writeTextOnHoodie: (NSString*)text
{
    NSUInteger left = text.length;
    NSUInteger lastPosition = 0;
    CBCharacteristic* characteristic = [self.characteristics objectForKey:FSTCharacteristicHoodieWrite];
    
    while (left > 0)
    {
        NSData *data = [[text substringWithRange:NSMakeRange(lastPosition, lastPosition+19)] dataUsingEncoding:NSUTF8StringEncoding];
        
        lastPosition = lastPosition+19;
        
        NSLog(@"to write %s", data);
//        if (characteristic)
//        {
//            [self.peripheral writeValue:data forCharacteristic:characteristic type:CBCharacteristicWriteWithResponse];
//        }
       
    }
}


-(void)dealloc
{
    [_readCharacteristicsTimer invalidate];
}

@end
