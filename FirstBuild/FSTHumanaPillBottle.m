//
//  FSTHumanaPillBottle.m
//  FirstBuild
//
//  Created by Myles Caley on 8/13/15.
//  Copyright (c) 2015 FirstBuild. All rights reserved.
//

#import "FSTHumanaPillBottle.h"

@implementation FSTHumanaPillBottle
{
    NSTimeInterval _buttonDownStartTime;
    NSMutableDictionary *requiredCharacteristics; // a dictionary of strings with booleans
}

//notifications
NSString * const FSTHumanaPillBottleBatteryLevelChangedNotification         = @"FSTHumanaPillBottleBatteryLevelChangedNotification";

//Blue Bean Characteristics
//TODO: move standard characteristics to BLE base object
NSString * const FSTCharacteristicSerialPassThrough       = @"A495FF11-C5B1-4B44-B512-1370F02D74DE"; //read,notify,write
NSString * const FSTCharacteristicBatteryLevelDefault     = @"2A19"; //read,notify

#pragma mark - Allocation

- (id)init
{
    self = [super init];
    
    if (self)
    {
        self.needsRxRefill = NO;
        _buttonDownStartTime = 0;
        // booleans for all the required characteristics, tell us whether or not the characteristic loaded
        requiredCharacteristics = [[NSMutableDictionary alloc] initWithObjectsAndKeys:[
            [NSNumber alloc] initWithBool:0], FSTCharacteristicSerialPassThrough,
            nil];
    }
    
    return self;
}

#pragma mark - Read Handlers

-(void)readHandler: (CBCharacteristic*)characteristic
{
    [super readHandler:characteristic];
    
    if ([[[characteristic UUID] UUIDString] isEqualToString: FSTCharacteristicSerialPassThrough])
    {
        [requiredCharacteristics setObject:[NSNumber numberWithBool:1] forKey:FSTCharacteristicSerialPassThrough];
        [self handleSerial:characteristic];
    }
    else if([[[characteristic UUID] UUIDString] isEqualToString: FSTCharacteristicBatteryLevelDefault])
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
        //we haven't informed the application that the device is completely loaded, but we have
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
        //we don't have all the data yet...
        // calculate fraction
        double progressCount = [[NSNumber numberWithInt:(int)requiredCount] doubleValue];
        double progressTotal = [[NSNumber numberWithInt:(int)[requiredCharacteristics count]] doubleValue];
        self.loadingProgress = [NSNumber numberWithDouble: progressCount/progressTotal];
        
        [self notifyDeviceLoadProgressUpdated];
    }
    
} // end assignToProperty

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


-(void)handleSerial: (CBCharacteristic*)characteristic
{
    if (characteristic.value.length != 8)
    {
        //DLog(@"handleElapsedTime length of %lu not what was expected, %d", (unsigned long)characteristic.value.length, 2);
        return;
    }

    //using BlueBean data layer.. see GATT_Serial_Message.m in Bean-iOS-OSX-SDK
    NSData* payload = [characteristic.value subdataWithRange: NSMakeRange (2, [characteristic.value length]-4)];

    //3f = all digital pins HIGH
    //3d = D1 is off
    Byte bytes[payload.length] ;
    [payload getBytes:bytes length:payload.length];
    
    if (bytes[3] == 0x3f)
    {
        //all of the inputs are high
        NSLog(@"button up");
        NSTimeInterval _buttonUpTime = [NSDate timeIntervalSinceReferenceDate];
        if (_buttonUpTime - _buttonDownStartTime > 1.5 && _buttonDownStartTime != 0)
        {
            NSLog(@"button up GREATER THAN 3 second");
            self.needsRxRefill = !self.needsRxRefill;
            [[NSNotificationCenter defaultCenter] postNotificationName:FSTDeviceEssentialDataChangedNotification  object:self];
            
            ///
            UILocalNotification* local = [[UILocalNotification alloc]init];
            if (local)
            {
                local.fireDate = [NSDate dateWithTimeIntervalSinceNow:0];
                local.alertBody = self.needsRxRefill?@"Refill request succeeded" : @"Refill request cancelled";
                local.timeZone = [NSTimeZone defaultTimeZone];
                [[UIApplication sharedApplication] scheduleLocalNotification:local];
                
            }
            /////
            
        }
        _buttonDownStartTime = 0;
       
    }
    else
    {
        //one of the inputs is low
        NSLog(@"button down");
        
        _buttonDownStartTime = [NSDate timeIntervalSinceReferenceDate];
    }
}


#pragma mark - Characteristic Discovery Handler

-(void)handleDiscoverCharacteristics: (NSArray*)characteristics
{
    [super handleDiscoverCharacteristics:characteristics];
    
    self.initialCharacteristicValuesRead = NO;
    [requiredCharacteristics setObject:[NSNumber numberWithBool:0] forKey:FSTCharacteristicSerialPassThrough];
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
                 [[[characteristic UUID] UUIDString] isEqualToString: FSTCharacteristicSerialPassThrough] ||
                 [[[characteristic UUID] UUIDString] isEqualToString: FSTCharacteristicBatteryLevelDefault]
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
