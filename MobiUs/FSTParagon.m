//
//  FSTParagon.m
//  FirstBuild
//
//  Created by Myles Caley on 3/12/15.
//  Copyright (c) 2015 FirstBuild. All rights reserved.
//

#import "FSTParagon.h"

@implementation FSTParagon

//notifications
NSString * const FSTActualTemperatureChangedNotification    = @"FSTActualTemperatureChangedNotification";
NSString * const FSTTargetTemperatureChangedNotification    = @"FSTTargetTemperatureChangedNotification";
NSString * const FSTBurnerModeChangedNotification           = @"FSTBurnerModeChangedNotification";
NSString * const FSTElapsedTimeChangedNotification          = @"FSTElapsedTimeChangedNotification";
NSString * const FSTBatteryLevelChangedNotification         = @"FSTBatteryLevelChangedNotification";
NSString * const FSTCookTimeSetNotification                 = @"FSTCookTimeSetNotification";
NSString * const FSTCookingModeChangedNotification          = @"FSTCookingModeChangedNotification";
NSString * const FSTElapsedTimeSetNotification              = @"FSTElapsedTimeSetNotification";
NSString * const FSTTargetTemperatureSetNotification        = @"FSTTargetTemperatureSetNotification";

//app info service
NSString * const FSTServiceAppInfoService               = @"E936877A-8DD0-FAA7-B648-F46ACDA1F27B";
NSString * const FSTCharacteristicAppInfo               = @"318DB1F5-67F1-119B-6A41-1EECA0C744CE"; //read

//acm service
NSString * const FSTServiceParagon                      = @"05C78A3E-5BFA-4312-8391-8AE1E7DCBF6F";
NSString * const FSTCharacteristicSpecialFeatures       = @"E7CDDD9D-DCAC-4D70-A0E1-D3B6DFEB5E4C"; //read,notify,write
NSString * const FSTCharacteristicProbeFirmwareInfo     = @"83D33E5C-68EA-4158-8655-1A2AC0313FF6"; //read
NSString * const FSTCharacteristicErrorState            = @"5BCBF6B1-DE80-94B6-0F4B-99FB984707B6"; //read,notify
NSString * const FSTCharacteristicProbeConnectionState  = @"6B402ECC-3DDA-8BB4-9E42-F121D7E1CF69"; //read,notify
NSString * const FSTCharacteristicBatteryLevel          = @"A74C3FB9-6E13-B4B9-CD47-465AAD76FCE7"; //read,notify
NSString * const FSTCharacteristicBurnerStatus          = @"A1B9F907-D440-4278-97FE-0FBB4AEE93FD"; //read,notify
NSString * const FSTCharacteristicTargetTemperature     = @"71B1A100-E3AE-46FF-BB0A-E37D0BA79496"; //read,notify,write
NSString * const FSTCharacteristicElapsedTime           = @"998142D1-658E-33E2-DFC0-32091E2354EC"; //read,notify
NSString * const FSTCharacteristicCookTime              = @"C4510188-9062-4D28-97EF-4FB32FFE1AC5"; //read,write
NSString * const FSTCharacteristicCurrentTemperature    = @"8F080B1C-7C3B-FBB9-584A-F0AFD57028F0"; //read,notify

NSMutableDictionary *requiredCharacteristics; // a dictionary of strings with booleans


//TODO put sizes for the characteristics here and remove magic numbers below


__weak NSTimer* _readCharacteristicsTimer;

- (id)init
{
    self = [super init];
    
    if (self)
    {
        //setup the current cooking method and session, which is the actual
        //state of the cooking as reported by the cooktop
        self.currentCookingMethod = [[FSTCookingMethod alloc]init];
        [self.currentCookingMethod createCookingSession];
        [self.currentCookingMethod addStageToCookingSession];
        
        //setup the to-be cooking method, which is the settings for the building
        //out of a new method and session
        self.toBeCookingMethod = [[FSTCookingMethod alloc]init];
        [self.toBeCookingMethod createCookingSession];
        [self.toBeCookingMethod addStageToCookingSession];
        
        self.burners = [NSArray arrayWithObjects:[FSTBurner new], [FSTBurner new],[FSTBurner new],[FSTBurner new],[FSTBurner new], nil];
        
        requiredCharacteristics = [[NSMutableDictionary alloc] initWithObjectsAndKeys:[[NSNumber alloc] initWithBool:0], FSTCharacteristicProbeConnectionState,[[NSNumber alloc] initWithBool:0], FSTCharacteristicBatteryLevel,
            [[NSNumber alloc] initWithBool:0], FSTCharacteristicBurnerStatus,
            [[NSNumber alloc] initWithBool:0], FSTCharacteristicCurrentTemperature,
            [[NSNumber alloc] initWithBool:0], FSTCharacteristicElapsedTime,
            [[NSNumber alloc] initWithBool:0], FSTCharacteristicTargetTemperature,
            [[NSNumber alloc] initWithBool:0], FSTCharacteristicCookTime,
                                   nil]; // booleans for all the required characteristics, tell us whether or not the characteristic loaded
    }

    return self;
}

-(void)dealloc
{
    [_readCharacteristicsTimer invalidate];
}

#pragma mark - Interactions

-(void)startHeating
{
    FSTParagonCookingStage* toBeStage = self.toBeCookingMethod.session.paragonCookingStages[0];

    Byte bytes[2] ;
    OSWriteBigInt16(bytes, 0, [toBeStage.targetTemperature doubleValue]*100);
    NSData *data = [[NSData alloc]initWithBytes:bytes length:2];

    CBCharacteristic* characteristic = [self.characteristics objectForKey:FSTCharacteristicTargetTemperature];
    
    if (characteristic)
    {
        [self.peripheral writeValue:data forCharacteristic:characteristic type:CBCharacteristicWriteWithResponse];
    }
}

-(void)setCookingTimes
{
    FSTParagonCookingStage* toBeStage = self.toBeCookingMethod.session.paragonCookingStages[0];
    CBCharacteristic* characteristic = [self.characteristics objectForKey:FSTCharacteristicCookTime];
    
    //TODO: - once we actually have max time then remove this calculation
    //cookingTimeMaximum = [NSNumber numberWithInt:[cookingTimeMinimum intValue] + 3*60];

    if (characteristic && toBeStage.cookTimeMinimum && toBeStage.cookTimeMaximum)
    {
        Byte bytes[8] = {0x00};
        OSWriteBigInt16(bytes, 0, [toBeStage.cookTimeMinimum unsignedIntegerValue]);
        OSWriteBigInt16(bytes, 2, [toBeStage.cookTimeMaximum unsignedIntegerValue]);
        NSData *data = [[NSData alloc]initWithBytes:bytes length:8];
        [self.peripheral writeValue:data forCharacteristic:characteristic type:CBCharacteristicWriteWithResponse];
    }
    else
    {
        DLog(@"could not write cook time to BLE device, missing a min or max cooktime");
    }
    
    characteristic = [self.characteristics objectForKey:FSTCharacteristicElapsedTime];
    
    if (characteristic)
    {
        Byte bytes[2] = {0x00,0x00};
        NSData *data = [[NSData alloc]initWithBytes:bytes length:sizeof(bytes)];
        [self.peripheral writeValue:data forCharacteristic:characteristic type:CBCharacteristicWriteWithResponse];
    }
    else
    {
        DLog(@"could not set elapsed time to 0 on BLE device, characteristic is empty");
    }
    
}

-(void)assignValueToPropertyFromCharacteristic: (CBCharacteristic*)characteristic
{
    if ([[[characteristic UUID] UUIDString] isEqualToString: FSTCharacteristicProbeFirmwareInfo])
    {
        //not implemented
    }
    else if([[[characteristic UUID] UUIDString] isEqualToString: FSTCharacteristicSpecialFeatures])
    {
        //not implemented
    }
    else if([[[characteristic UUID] UUIDString] isEqualToString: FSTCharacteristicErrorState])
    {
        //not implemented
    }
    else if([[[characteristic UUID] UUIDString] isEqualToString: FSTCharacteristicProbeConnectionState])
    {
        // set required dictionary to true for this key
        //characteristicStatusFlags.FSTCharacteristicProbeConnectionState = 1;
        [requiredCharacteristics setObject:[NSNumber numberWithBool:1] forKey:FSTCharacteristicProbeConnectionState];
        //not implemented
    }
    else if([[[characteristic UUID] UUIDString] isEqualToString: FSTCharacteristicBatteryLevel])
    {
        //characteristicStatusFlags.FSTCharacteristicBatteryLevel = 1;
        [requiredCharacteristics setObject:[NSNumber numberWithBool:1] forKey:FSTCharacteristicBatteryLevel];
        [self handleBatteryLevel:characteristic];
    }
    else if([[[characteristic UUID] UUIDString] isEqualToString: FSTCharacteristicBurnerStatus])
    {
        //characteristicStatusFlags.FSTCharacteristicBurnerStatus = 1;
        [requiredCharacteristics setObject:[NSNumber numberWithBool:1] forKey:FSTCharacteristicBurnerStatus];
        [self handleBurnerStatus:characteristic];
    }
    else if([[[characteristic UUID] UUIDString] isEqualToString: FSTCharacteristicElapsedTime])
    {
        //characteristicStatusFlags.FSTCharacteristicElapsedTime = 1;
        [requiredCharacteristics setObject:[NSNumber numberWithBool:1] forKey:FSTCharacteristicElapsedTime];
        [self handleElapsedTime:characteristic];
    }
    else if([[[characteristic UUID] UUIDString] isEqualToString: FSTCharacteristicTargetTemperature])
    {
        //characteristicStatusFlags.FSTCharacteristicTargetTemperature = 1;
        [requiredCharacteristics setObject:[NSNumber numberWithBool:1] forKey:FSTCharacteristicTargetTemperature];
        [self handleTargetTemperature:characteristic];
    }
    else if([[[characteristic UUID] UUIDString] isEqualToString: FSTCharacteristicCookTime])
    {
        //characteristicStatusFlags.FSTCharacteristicCookTime = 1;
        [requiredCharacteristics setObject:[NSNumber numberWithBool:1] forKey:FSTCharacteristicCookTime];
        [self handleCookTime:characteristic];
    }
    else if([[[characteristic UUID] UUIDString] isEqualToString:FSTCharacteristicCurrentTemperature])
    {
        //characteristicStatusFlags.FSTCharacteristicCurrentTemperature = 1;
        [requiredCharacteristics setObject:[NSNumber numberWithBool:1] forKey:FSTCharacteristicCurrentTemperature];
        [self handleCurrentTemperature:characteristic];
    } // end all characteristic cases
    
    NSEnumerator* requiredEnum = [requiredCharacteristics keyEnumerator]; // count how many characteristics are ready
    NSInteger requiredCount = 0; // count the number of discovered characteristics
    for (NSString* characteristic in requiredEnum) {
        requiredCount += [(NSNumber*)[requiredCharacteristics objectForKey:characteristic] integerValue];
    }
    
    if (requiredCount == [requiredCharacteristics count] && self.initialCharacteristicValuesRead == NO) // found all required characteristics
    {
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
    // calculate fraction
    double progressCount = [[NSNumber numberWithInt:(int)requiredCount] doubleValue];
    double progressTotal = [[NSNumber numberWithInt:(int)[requiredCharacteristics count]] doubleValue];
    self.loadingProgress = [NSNumber numberWithDouble: progressCount/progressTotal];
    
    //TODO *hack* need to add a second notification to determine when progress updated
    [self notifyDeviceReady];
    
    [self determineCookMode];
    [self logParagon];
    
    
} // end assignToProperty

#pragma mark - Data Assignment Handlers

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

-(void)handleElapsedTime: (CBCharacteristic*)characteristic
{
    if (characteristic.value.length != 2)
    {
        //DLog(@"handleElapsedTime length of %lu not what was expected, %d", (unsigned long)characteristic.value.length, 2);
        return;
    }
    
    FSTParagonCookingStage* currentStage = self.currentCookingMethod.session.paragonCookingStages[0];
    
    if (currentStage)
    {
        NSData *data = characteristic.value;
        Byte bytes[characteristic.value.length] ;
        [data getBytes:bytes length:characteristic.value.length];
        uint16_t raw = OSReadBigInt16(bytes, 0);
        currentStage.cookTimeElapsed = [[NSNumber alloc] initWithDouble:raw];
        [[NSNotificationCenter defaultCenter] postNotificationName:FSTElapsedTimeChangedNotification object:self];
        //NSLog(@"FSTCharacteristicElapsedTime %@", currentStage.cookTimeElapsed );
    }
}

-(void)handleBurnerStatus: (CBCharacteristic*)characteristic
{
    // TODO: - add direct cook detection
    if (characteristic.value.length != self.burners.count)
    {
        DLog(@"handleBurnerStatus length of %lu not what was expected, %lu", (unsigned long)characteristic.value.length, (unsigned long)self.burners.count);
        return;
    }
    
    FSTParagonCookingStage* toBeStage = self.currentCookingMethod.session.paragonCookingStages[0];
    
    //There are 5 burner statuses and and 5 bytes. Each byte is a status
    //the statuses are:
    //
    //Bit 7: 0 - Off, 1 - On
    //Bit 6: Normal / Sous Vide
    //Bit 5: 0 - Cook, 1 - Preheat
    //Bits 4-0: Burner PwrLevel
//    static const uint8_t BURNER_ON_OR_OFF_MASK = 0x80;
    static const uint8_t SOUS_VIDE_ON_OR_OFF_MASK = 0x40;
    static const uint8_t BURNER_PREHEAT_MASK = 0x20;
//    static const uint8_t BURNER_POWER_LEVEL_MASK = 0x1F;

//    //cook status
//    static const uint8_t COOK_STATUS_BIT = 5;
//    static const uint8_t COOK_STATUS_PREHEAT = 1;
//    
    //cook modes
//    static const uint8_t MODE_BIT = 6;
//    static const uint8_t MODE_NORMAL = 0;
    
    NSData *data = characteristic.value;
    Byte bytes[characteristic.value.length] ;
    [data getBytes:bytes length:characteristic.value.length];
    
    //loop through all burners (GE Cooktop)
    for (uint8_t burner = 0; burner < self.burners.count; burner++)
    {
        FSTBurner * currentBurner = (FSTBurner*)self.burners[burner];
        
        //figure out what mode the burner is
        if ((bytes[burner] & SOUS_VIDE_ON_OR_OFF_MASK) != SOUS_VIDE_ON_OR_OFF_MASK)
        {
            currentBurner.burnerMode = kPARAGON_OFF;
        }
        else
        {
            if((bytes[burner] & BURNER_PREHEAT_MASK) == BURNER_PREHEAT_MASK)
            {
                currentBurner.burnerMode = kPARAGON_PRECISION_PREHEATING;
            }
            else
            {
                currentBurner.burnerMode = kPARAGON_PRECISION_HEATING;
            }
        }
    }
    
    //now go through each of the burners and see if we can find one that is not off
    //in order to set the overall burner mode (self.burnerMode)
    for (FSTBurner* burner in self.burners) {
        if (burner.burnerMode != kPARAGON_OFF )
        {
            self.burnerMode = burner.burnerMode;
            break;
        }
        else
        {
            self.burnerMode = kPARAGON_OFF;
        }
    }
    
    //TODO: need to make sure this fix is actually ok...reset the cooktime when we see the paragon is off
    if (self.burnerMode == kPARAGON_OFF)
    {
        toBeStage.cookTimeMinimum = 0;
        toBeStage.cookTimeMaximum = 0;
        [self setCookingTimes];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:FSTBurnerModeChangedNotification object:self];
}


-(void)determineCookMode
{
    //TODO: add direct cook
    FSTParagonCookingStage* currentStage = self.currentCookingMethod.session.paragonCookingStages[0];
    ParagonCookMode currentCookMode = self.cookMode;
    
    if (self.burnerMode == kPARAGON_OFF)
    {
        self.cookMode = FSTParagonCookingStateOff;
    }
    else if (self.burnerMode == kPARAGON_PRECISION_PREHEATING)
    {
        //in precision cooking mode and preheating
        self.cookMode = FSTParagonCookingStatePrecisionCookingPreheating;
    }
    else if (self.burnerMode == kPARAGON_PRECISION_HEATING)
    {
        if (currentCookMode == FSTParagonCookingStatePrecisionCookingPreheating)
        {
            //since we are currently in preheating mode and the burner indicates
            //that we reached we reached our preheating goal
            self.cookMode = FSTParagonCookingStatePrecisionCookingPreheatingReached;
        }
        else if ([currentStage.cookTimeElapsed doubleValue] > [currentStage.cookTimeMaximum doubleValue])
        {
            //elapsed time is greater than the maximum time
            self.cookMode = FSTParagonCookingStatePrecisionCookingPastMaxTime;
        }
        else if ([currentStage.cookTimeElapsed doubleValue] > [currentStage.cookTimeMinimum doubleValue] )
        {
            //elapsed time is greater than the minimum time, but less than or equal to the max time
            self.cookMode = FSTParagonCookingStatePrecisionCookingReachingMaxTime;
        }
        else if([currentStage.cookTimeElapsed doubleValue] < [currentStage.cookTimeMinimum doubleValue])
        {
            //elapsed time is less than the minimum time
            self.cookMode = FSTParagonCookingStatePrecisionCookingReachingMinTime;
        }
        else
        {
            DLog(@"UNABLE TO DETERMINE COOK MODE");
        }
    }
    
    //only notify if we have changed cook modes
    if (self.cookMode != currentCookMode)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:FSTCookingModeChangedNotification object:self];
    }

}

-(void)handleTargetTemperature: (CBCharacteristic*)characteristic
{
    if (characteristic.value.length != 2)
    {
        DLog(@"handleTargetTemperature length of %lu not what was expected, %d", (unsigned long)characteristic.value.length, 2);
        return;
    }
    
    FSTParagonCookingStage* currentStage = self.currentCookingMethod.session.paragonCookingStages[0];

    if (currentStage)
    {
        NSData *data = characteristic.value;
        Byte bytes[characteristic.value.length] ;
        [data getBytes:bytes length:characteristic.value.length];
        uint16_t raw = OSReadBigInt16(bytes, 0);
        currentStage.targetTemperature = [[NSNumber alloc] initWithDouble:raw/100];
        [[NSNotificationCenter defaultCenter] postNotificationName:FSTTargetTemperatureChangedNotification object:self];
        //NSLog(@"FSTCharacteristicTargetTemperature: %@", currentStage.targetTemperature );
    }
}

-(void)handleCookTime: (CBCharacteristic*)characteristic
{
    if (characteristic.value.length != 8)
    {
        DLog(@"handleCookTime length of %lu not what was expected, %d", (unsigned long)characteristic.value.length, 8);
        return;
    }
    
    FSTParagonCookingStage* currentStage = self.currentCookingMethod.session.paragonCookingStages[0];

    if (currentStage)
    {
        NSData *data = characteristic.value;
        Byte bytes[characteristic.value.length] ;
        [data getBytes:bytes length:8];
        
        uint16_t minimumTime = OSReadBigInt16(bytes, 0);
        uint16_t maximumTime = OSReadBigInt16(bytes, 2);
        currentStage.cookTimeMinimum = [[NSNumber alloc] initWithDouble:minimumTime];
        currentStage.cookTimeMaximum = [[NSNumber alloc] initWithDouble:maximumTime];

        //NSLog(@"FSTCharacteristicCookTime [min desired %@, max desired %@],  [min actual: %@, max actual: %@]", toBeStage.cookTimeMinimum, toBeStage.cookTimeMaximum, currentStage.cookTimeMinimum, currentStage.cookTimeMaximum);
    }
}

-(void)handleCurrentTemperature: (CBCharacteristic*)characteristic
{
    if (characteristic.value.length != 2)
    {
        DLog(@"handleCurrentTemperature length of %lu not what was expected, %d", (unsigned long)characteristic.value.length, 2);
        return;
    }
    
    FSTParagonCookingStage* currentStage = self.currentCookingMethod.session.paragonCookingStages[0];
    if (currentStage)
    {
        NSData *data = characteristic.value;
        Byte bytes[characteristic.value.length] ;
        [data getBytes:bytes length:characteristic.value.length];
        uint16_t raw = OSReadBigInt16(bytes, 0);
        currentStage.actualTemperature = [[NSNumber alloc] initWithDouble:raw/100];
        [[NSNotificationCenter defaultCenter] postNotificationName:FSTActualTemperatureChangedNotification object:self];
        //NSLog(@"FSTCharacteristicCurrentTemperature %@", currentStage.actualTemperature );
    }
}

#pragma mark - <CBPeripheralDelegate>

-(void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error
{
    self.initialCharacteristicValuesRead = NO;
    [requiredCharacteristics setObject:[NSNumber numberWithBool:0] forKey:FSTCharacteristicProbeConnectionState];
    [requiredCharacteristics setObject:[NSNumber numberWithBool:0] forKey:FSTCharacteristicBatteryLevel];
    [requiredCharacteristics setObject:[NSNumber numberWithBool:0] forKey:FSTCharacteristicBurnerStatus];
    [requiredCharacteristics setObject:[NSNumber numberWithBool:0] forKey:FSTCharacteristicCurrentTemperature];
    [requiredCharacteristics setObject:[NSNumber numberWithBool:0] forKey:FSTCharacteristicElapsedTime];
    [requiredCharacteristics setObject:[NSNumber numberWithBool:0] forKey:FSTCharacteristicTargetTemperature];
    [requiredCharacteristics setObject:[NSNumber numberWithBool:0] forKey:FSTCharacteristicCookTime];
    NSLog(@"=======================================================================");
    NSLog(@"SERVICE %@", [service.UUID UUIDString]);
        
    for (CBCharacteristic *characteristic in service.characteristics)
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
                    [[[characteristic UUID] UUIDString] isEqualToString: FSTCharacteristicBatteryLevel] ||
                    [[[characteristic UUID] UUIDString] isEqualToString: FSTCharacteristicBurnerStatus] ||
                    [[[characteristic UUID] UUIDString] isEqualToString: FSTCharacteristicCurrentTemperature] ||
                    [[[characteristic UUID] UUIDString] isEqualToString: FSTCharacteristicElapsedTime] ||
                    [[[characteristic UUID] UUIDString] isEqualToString: FSTCharacteristicProbeConnectionState] ||
                    [[[characteristic UUID] UUIDString] isEqualToString: FSTCharacteristicTargetTemperature]
                )
            {
                [self.peripheral readValueForCharacteristic:characteristic];
                //[self.peripheral setNotifyValue:YES forCharacteristic:characteristic];
            }
            
        }
        
        if (characteristic.properties & CBCharacteristicPropertyRead)
        {
            if([[[characteristic UUID] UUIDString] isEqualToString: FSTCharacteristicCookTime])
            {
                [self.peripheral readValueForCharacteristic:characteristic];
            }
            NSLog(@"        CAN READ");
        }
        
        if (characteristic.properties & CBCharacteristicPropertyWriteWithoutResponse)
        {
            NSLog(@"        CAN WRITE WITHOUT RESPONSE");
        }
    }
}

-(void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error
{
    DLog("discovered services for peripheral %@", peripheral.identifier);
    NSArray * services;
    services = [self.peripheral services];
    for (CBService *service in services)
    {
        [self.peripheral discoverCharacteristics:nil forService:service];
    }
}

-(void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    //NSLog(@"characteristic %@ changed value %@", characteristic.UUID, characteristic.value);
    [self assignValueToPropertyFromCharacteristic:characteristic];
}

-(void)peripheral:(CBPeripheral *)peripheral didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    if (error)
    {
        NSLog(@"characteristic %@ notification failed %@", characteristic.UUID, error);
        return;
    }
    
    NSLog(@"characteristic %@ , notifying: %s", characteristic.UUID, characteristic.isNotifying ? "true" : "false");
   
}

-(void)peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    //TODO: create set handlers and take this out of here
    if([[[characteristic UUID] UUIDString] isEqualToString: FSTCharacteristicCookTime])
    {
        if (error)
        {
            //TODO: what do we do if error writing characteristic?
            DLog(@"error writing the cooktime characteristic %@", error);
            return;
        }
        DLog(@"successfully wrote FSTCharacteristicCookTime");
        
        //we successfully wrote the cooking time so go ahead and set the current cooking times to the
        //to be cooking times. since we don't get notifications when it is published
        FSTParagonCookingStage* currentStage = self.currentCookingMethod.session.paragonCookingStages[0];
        FSTParagonCookingStage* toBeStage = self.toBeCookingMethod.session.paragonCookingStages[0];
        
        currentStage.cookTimeMaximum = toBeStage.cookTimeMaximum;
        currentStage.cookTimeMinimum = toBeStage.cookTimeMinimum;
        [self determineCookMode];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:FSTCookTimeSetNotification object:self];
    }
    else if([[[characteristic UUID] UUIDString] isEqualToString: FSTCharacteristicElapsedTime])
    {
        if (error)
        {
            //TODO: what do we do if error writing characteristic?
            DLog(@"error writing the elapsed time characteristic %@", error);
            return;
        }
        DLog(@"successfully wrote FSTCharacteristicElapsedTime");
        [self determineCookMode];
        [[NSNotificationCenter defaultCenter] postNotificationName:FSTElapsedTimeSetNotification object:self];
    }
    else if([[[characteristic UUID] UUIDString] isEqualToString: FSTCharacteristicTargetTemperature])
    {
        if (error)
        {
            //TODO: what do we do if error writing characteristic?
            DLog(@"error writing the target temperature characteristic %@", error);
            return;
        }
        DLog(@"successfully wrote FSTCharacteristicTargetTemperature");
        [[NSNotificationCenter defaultCenter] postNotificationName:FSTTargetTemperatureSetNotification object:self];
    }
}

#ifdef DEBUG
-(void)logParagon
{
    FSTParagonCookingStage* currentStage = self.currentCookingMethod.session.paragonCookingStages[0];
    FSTParagonCookingStage* toBeStage = self.toBeCookingMethod.session.paragonCookingStages[0];
    NSLog(@"------PARAGON-------");
    NSLog(@"bmode %d, cmode %d, curtmp %@", self.burnerMode, self.cookMode, currentStage.actualTemperature);
    NSLog(@"\tACTUAL: tartmp %@, mint %@, maxt %@, elapt %@", currentStage.targetTemperature, currentStage.cookTimeMinimum, currentStage.cookTimeMaximum, currentStage.cookTimeElapsed);
    NSLog(@"\t  TOBE: tartmp %@, mint %@, maxt %@, elapt %@", toBeStage.targetTemperature, toBeStage.cookTimeMinimum, toBeStage.cookTimeMaximum, toBeStage.cookTimeElapsed);
}
#endif

@end
