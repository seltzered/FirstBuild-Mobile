//
//  FSTGECooktop.m
//  FirstBuild
//
//  Created by Myles Caley on 9/17/15.
//  Copyright (c) 2015 FirstBuild. All rights reserved.
//

#import "FSTGECooktop.h"
#import "FSTSavedRecipeManager.h"
//#import "FSTGECooktopCookingSession.h"

@implementation FSTGECooktop
{
    NSMutableDictionary *requiredCharacteristics; // a dictionary of strings with booleans
}

////notifications
//NSString * const FSTActualTemperatureChangedNotification    = @"FSTActualTemperatureChangedNotification";
//NSString * const FSTTargetTemperatureChangedNotification    = @"FSTTargetTemperatureChangedNotification";
//NSString * const FSTBurnerModeChangedNotification           = @"FSTBurnerModeChangedNotification";
//NSString * const FSTElapsedTimeChangedNotification          = @"FSTElapsedTimeChangedNotification";
//
//NSString * const FSTCookTimeSetNotification                 = @"FSTCookTimeSetNotification";
NSString * const FSTCookingModeChangedNotification          = @"FSTCookingModeChangedNotification";
//NSString * const FSTElapsedTimeSetNotification              = @"FSTElapsedTimeSetNotification";
NSString * const FSTTargetTemperatureSetNotification        = @"FSTTargetTemperatureSetNotification";

//app info service
NSString * const FSTGECooktopServiceAppInfoService               = @"E936877A-8DD0-FAA7-B648-F46ACDA1F27B";
NSString * const FSTGECooktopCharacteristicAppInfo               = @"318DB1F5-67F1-119B-6A41-1EECA0C744CE"; //read

//acm service
NSString * const FSTGECooktopServiceParagon                      = @"05C78A3E-5BFA-4312-8391-8AE1E7DCBF6F";
NSString * const FSTGECooktopCharacteristicSpecialFeatures       = @"E7CDDD9D-DCAC-4D70-A0E1-D3B6DFEB5E4C"; //read,notify,write
NSString * const FSTGECooktopCharacteristicProbeFirmwareInfo     = @"83D33E5C-68EA-4158-8655-1A2AC0313FF6"; //read
NSString * const FSTGECooktopCharacteristicErrorState            = @"5BCBF6B1-DE80-94B6-0F4B-99FB984707B6"; //read,notify
NSString * const FSTGECooktopCharacteristicProbeConnectionState  = @"6B402ECC-3DDA-8BB4-9E42-F121D7E1CF69"; //read,notify
NSString * const FSTGECooktopCharacteristicBatteryLevel          = @"A74C3FB9-6E13-B4B9-CD47-465AAD76FCE7"; //read,notify
NSString * const FSTGECooktopCharacteristicBurnerStatus          = @"A1B9F907-D440-4278-97FE-0FBB4AEE93FD"; //read,notify
NSString * const FSTGECooktopCharacteristicTargetTemperature     = @"71B1A100-E3AE-46FF-BB0A-E37D0BA79496"; //read,notify,write
NSString * const FSTGECooktopCharacteristicElapsedTime           = @"998142D1-658E-33E2-DFC0-32091E2354EC"; //read,notify
NSString * const FSTGECooktopCharacteristicCookTime              = @"C4510188-9062-4D28-97EF-4FB32FFE1AC5"; //read,write
NSString * const FSTGECooktopCharacteristicCurrentTemperature    = @"8F080B1C-7C3B-FBB9-584A-F0AFD57028F0"; //read,notify
NSString * const FSTGECooktopCharacteristicRecipeId              = @"FF";



//TODO put sizes for the characteristics here and remove magic numbers below

#pragma mark - Allocation

- (id)init
{
    self = [super init];
    
    if (self)
    {
        //setup the current cooking method and session, which is the actual
        //state of the cooking as reported by the cooktop
        //TODO: create a new recipe based on the actual recipe
        self.recipeId = nil;
        self.session = [[FSTParagonCookingSession alloc] init];
        self.session.activeRecipe = nil;
        
        //forcibly set the toBe cooking method to nil since we are just creating the paragon
        //object and there is not way it could exist yet
        //self.session.toBeRecipe = nil;
        
        self.burners = [NSArray arrayWithObjects:[FSTBurner new], [FSTBurner new],[FSTBurner new],[FSTBurner new],[FSTBurner new], nil];
        
        requiredCharacteristics = [[NSMutableDictionary alloc] initWithObjectsAndKeys:[[NSNumber alloc] initWithBool:0], FSTGECooktopCharacteristicProbeConnectionState,[[NSNumber alloc] initWithBool:0], FSTGECooktopCharacteristicBatteryLevel,
                                   [[NSNumber alloc] initWithBool:0], FSTGECooktopCharacteristicBurnerStatus,
                                   [[NSNumber alloc] initWithBool:0], FSTGECooktopCharacteristicCurrentTemperature,
                                   [[NSNumber alloc] initWithBool:0], FSTGECooktopCharacteristicElapsedTime,
                                   [[NSNumber alloc] initWithBool:0], FSTGECooktopCharacteristicTargetTemperature,
                                   [[NSNumber alloc] initWithBool:0], FSTGECooktopCharacteristicCookTime,
                                   [[NSNumber alloc] initWithBool:0], FSTGECooktopCharacteristicRecipeId,
                                   nil]; // booleans for all the required characteristics, tell us whether or not the characteristic loaded
        
        //TODO: Hack! we need an actual recipe
        [self handleRecipeId:nil];
        
    }
    
    return self;
}

#pragma mark - External Interface Selectors

-(void)startHeatingWithStage: (FSTParagonCookingStage*)stage
{
    if (!stage)
    {
        DLog(@"no stage set when attempting to heat");
        return;
    }
    
    [self writeTargetTemperature:stage.targetTemperature];
}

-(void)setCookingTimesWithStage: (FSTParagonCookingStage*)stage
{
    if (!stage)
    {
        DLog(@"no stage set when attempting to send cooking times");
        return;
    }
    
    //must reset elapsed time to 0 before writing the cooktime
    [self writeElapsedTime];
    [self writeCookTimesWithMinimumCooktime:stage.cookTimeMinimum havingMaximumCooktime:stage.cookTimeMaximum];
    
    //now that we set everything, lets git rid of the stage
    stage = nil;
}

#pragma mark - Write Handlers

-(void)writeHandler: (CBCharacteristic*)characteristic error:(NSError *)error
{
    [super writeHandler:characteristic error:error];
    
    if([[[characteristic UUID] UUIDString] isEqualToString: FSTGECooktopCharacteristicCookTime])
    {
        DLog(@"successfully wrote FSTGECooktopCharacteristicCookTime");
        [self handleCooktimeWritten];
    }
    else if([[[characteristic UUID] UUIDString] isEqualToString: FSTGECooktopCharacteristicElapsedTime])
    {
        [self handleElapsedTimeWritten];
        DLog(@"successfully wrote FSTGECooktopCharacteristicElapsedTime");
    }
    else if([[[characteristic UUID] UUIDString] isEqualToString: FSTGECooktopCharacteristicTargetTemperature])
    {
        DLog(@"successfully wrote FSTGECooktopCharacteristicTargetTemperature");
        [self handleTargetTemperatureWritten];
    }
}

-(void)writeTargetTemperature: (NSNumber*)targetTemperature
{
    CBCharacteristic* characteristic = [self.characteristics objectForKey:FSTGECooktopCharacteristicTargetTemperature];
    
    Byte bytes[2] ;
    OSWriteBigInt16(bytes, 0, [targetTemperature doubleValue]*100);
    NSData *data = [[NSData alloc]initWithBytes:bytes length:2];
    
    if (characteristic)
    {
        [self.peripheral writeValue:data forCharacteristic:characteristic type:CBCharacteristicWriteWithResponse];
    }
    else
    {
        DLog(@"characteristic nil for writing target temperature");
    }
}

-(void)handleTargetTemperatureWritten
{
    [[NSNotificationCenter defaultCenter] postNotificationName:FSTTargetTemperatureSetNotification object:self];
}

-(void)writeCookTimesWithMinimumCooktime: (NSNumber*)minimumCooktime havingMaximumCooktime: (NSNumber*)maximumCooktime
{
    CBCharacteristic* characteristic = [self.characteristics objectForKey:FSTGECooktopCharacteristicCookTime];
    
    if (characteristic && minimumCooktime && maximumCooktime)
    {
        Byte bytes[8] = {0x00};
        OSWriteBigInt16(bytes, 0, [minimumCooktime unsignedIntegerValue]);
        OSWriteBigInt16(bytes, 2, [maximumCooktime unsignedIntegerValue]);
        NSData *data = [[NSData alloc]initWithBytes:bytes length:8];
        [self.peripheral writeValue:data forCharacteristic:characteristic type:CBCharacteristicWriteWithResponse];
    }
    else
    {
        DLog(@"could not write cook time to BLE device, missing a min or max cooktime");
    }
}

-(void)handleCooktimeWritten
{
    //read back the characteristic since there is no notification
    CBCharacteristic* cookTimeCharacteristic = [self.characteristics objectForKey:FSTGECooktopCharacteristicCookTime];
    [self.peripheral readValueForCharacteristic:cookTimeCharacteristic];
    
//    [[NSNotificationCenter defaultCenter] postNotificationName:FSTCookTimeSetNotification object:self];
}

-(void)writeElapsedTime
{
    CBCharacteristic* characteristic = [self.characteristics objectForKey:FSTGECooktopCharacteristicElapsedTime];
    
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

-(void)handleElapsedTimeWritten
{
    CBCharacteristic* elapsedTimeCharacteristic = [self.characteristics objectForKey:FSTGECooktopCharacteristicElapsedTime];
    [self.peripheral readValueForCharacteristic:elapsedTimeCharacteristic];
//    [[NSNotificationCenter defaultCenter] postNotificationName:FSTElapsedTimeSetNotification object:self];
}

#pragma mark - Read Handlers

-(void)readHandler: (CBCharacteristic*)characteristic
{
    [super readHandler:characteristic];
    
    if ([[[characteristic UUID] UUIDString] isEqualToString: FSTGECooktopCharacteristicProbeFirmwareInfo])
    {
        //not implemented
    }
    else if([[[characteristic UUID] UUIDString] isEqualToString: FSTGECooktopCharacteristicSpecialFeatures])
    {
        //not implemented
    }
    else if([[[characteristic UUID] UUIDString] isEqualToString: FSTGECooktopCharacteristicErrorState])
    {
        //not implemented
    }
    else if([[[characteristic UUID] UUIDString] isEqualToString: FSTGECooktopCharacteristicProbeConnectionState])
    {
        // set required dictionary to true for this key
        //characteristicStatusFlags.FSTGECooktopCharacteristicProbeConnectionState = 1;
        [requiredCharacteristics setObject:[NSNumber numberWithBool:1] forKey:FSTGECooktopCharacteristicProbeConnectionState];
        //not implemented
    }
    else if([[[characteristic UUID] UUIDString] isEqualToString: FSTGECooktopCharacteristicBatteryLevel])
    {
        //characteristicStatusFlags.FSTGECooktopCharacteristicBatteryLevel = 1;
        [requiredCharacteristics setObject:[NSNumber numberWithBool:1] forKey:FSTGECooktopCharacteristicBatteryLevel];
        [self handleBatteryLevel:characteristic];
    }
    else if([[[characteristic UUID] UUIDString] isEqualToString: FSTGECooktopCharacteristicBurnerStatus])
    {
        //characteristicStatusFlags.FSTGECooktopCharacteristicBurnerStatus = 1;
        [requiredCharacteristics setObject:[NSNumber numberWithBool:1] forKey:FSTGECooktopCharacteristicBurnerStatus];
        [self handleBurnerStatus:characteristic];
    }
    else if([[[characteristic UUID] UUIDString] isEqualToString: FSTGECooktopCharacteristicElapsedTime])
    {
        //characteristicStatusFlags.FSTGECooktopCharacteristicElapsedTime = 1;
        [requiredCharacteristics setObject:[NSNumber numberWithBool:1] forKey:FSTGECooktopCharacteristicElapsedTime];
        [self handleElapsedTime:characteristic];
    }
    else if([[[characteristic UUID] UUIDString] isEqualToString: FSTGECooktopCharacteristicTargetTemperature])
    {
        //characteristicStatusFlags.FSTGECooktopCharacteristicTargetTemperature = 1;
        [requiredCharacteristics setObject:[NSNumber numberWithBool:1] forKey:FSTGECooktopCharacteristicTargetTemperature];
        [self handleTargetTemperature:characteristic];
    }
    else if([[[characteristic UUID] UUIDString] isEqualToString: FSTGECooktopCharacteristicCookTime])
    {
        //characteristicStatusFlags.FSTGECooktopCharacteristicCookTime = 1;
        [requiredCharacteristics setObject:[NSNumber numberWithBool:1] forKey:FSTGECooktopCharacteristicCookTime];
        [self handleCookTime:characteristic];
    }
    else if([[[characteristic UUID] UUIDString] isEqualToString:FSTGECooktopCharacteristicCurrentTemperature])
    {
        //characteristicStatusFlags.FSTGECooktopCharacteristicCurrentTemperature = 1;
        [requiredCharacteristics setObject:[NSNumber numberWithBool:1] forKey:FSTGECooktopCharacteristicCurrentTemperature];
        [self handleCurrentTemperature:characteristic];
    }
    else if ([[[characteristic UUID] UUIDString] isEqualToString:FSTGECooktopCharacteristicRecipeId])
    {
        [requiredCharacteristics setObject:[NSNumber numberWithBool:1] forKey:FSTGECooktopCharacteristicRecipeId];
        [self handleRecipeId:characteristic];
    }// end all characteristic cases
    
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
    
#ifdef DEBUG
    if ([[[characteristic UUID] UUIDString] isEqualToString:FSTGECooktopCharacteristicCurrentTemperature])
    {
        printf(".");
    }
    else
    {
        [self logParagon];
    }
#endif
    
    
} // end assignToProperty

-(void)handleRecipeId: (CBCharacteristic*)characteristic
{
    //TODO: implement with actual recipe id characteristic when we have that
    //    if (characteristic.value.length != 1)
    //    {
    //        DLog(@"handleRecipeId length of %lu not what was expected, %d", (unsigned long)characteristic.value.length, 1);
    //        return;
    //    }
    
    //    NSData *data = characteristic.value;
    //    Byte bytes[characteristic.value.length] ;
    //    [data getBytes:bytes length:characteristic.value.length];
    //    self.recipeId = [NSNumber numberWithUnsignedInt:bytes[0]];
    
    //TODO: REMOVE ALL OF THIS!
    [requiredCharacteristics setObject:[NSNumber numberWithBool:1] forKey:FSTGECooktopCharacteristicRecipeId];
    self.session.activeRecipe = [FSTRecipe new];
    //self.session.previousStage = self.session.currentStage;
    self.session.currentStage = [self.session.activeRecipe addStage];
    ///////////////////////////
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
    
    //NSLog(@"FSTGECooktopCharacteristicBatteryLevel: %@", self.batteryLevel );
    [[NSNotificationCenter defaultCenter] postNotificationName:FSTBatteryLevelChangedNotification  object:self];
    
}

-(void)handleElapsedTime: (CBCharacteristic*)characteristic
{
    if (characteristic.value.length != 2)
    {
        //DLog(@"handleElapsedTime length of %lu not what was expected, %d", (unsigned long)characteristic.value.length, 2);
        return;
    }
    
    if (self.session.currentStage)
    {
        NSData *data = characteristic.value;
        Byte bytes[characteristic.value.length] ;
        [data getBytes:bytes length:characteristic.value.length];
        uint16_t raw = OSReadBigInt16(bytes, 0);
        //self.session.currentStageCookTimeElapsed = [[NSNumber alloc] initWithDouble:raw];
        [self determineCookMode];
//        [[NSNotificationCenter defaultCenter] postNotificationName:FSTElapsedTimeChangedNotification object:self];
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
            currentBurner.geCooktopBurnerMode = kGECOOKTOP_OFF;
        }
        else
        {
            if((bytes[burner] & BURNER_PREHEAT_MASK) == BURNER_PREHEAT_MASK)
            {
                currentBurner.geCooktopBurnerMode = kGECOOKTOP_PRECISION_REACHING_TEMPERATURE;
            }
            else
            {
                currentBurner.geCooktopBurnerMode = kGECOOKTOP_PRECISION_HEATING;
            }
        }
    }
    
    //now go through each of the burners and see if we can find one that is not off
    //in order to set the overall burner mode (self.burnerMode)
    for (FSTBurner* burner in self.burners) {
        if (burner.geCooktopBurnerMode != kGECOOKTOP_OFF )
        {
            self.burnerMode = burner.geCooktopBurnerMode;
            break;
        }
        else
        {
            self.burnerMode = kGECOOKTOP_OFF;
        }
    }
    
//    [[NSNotificationCenter defaultCenter] postNotificationName:FSTBurnerModeChangedNotification object:self];
    [self determineCookMode];
}


-(void)determineCookMode
{
    //TODO: add direct cook
    
    GECooktopParagonCookMode currentCookMode = self.cookMode;
    
    if (self.burnerMode == kGECOOKTOP_OFF)
    {
        self.cookMode = FSTGECooktopCookingStateOff;
    }
    else if (self.burnerMode == kGECOOKTOP_PRECISION_REACHING_TEMPERATURE)
    {
        self.cookMode = FSTGECooktopCookingStatePrecisionCookingReachingTemperature;
        // TODO: this might cause the problem with precision cooking without time
    }
    else if (self.burnerMode == kGECOOKTOP_PRECISION_HEATING)
    {
//        if ([self.session.currentStageCookTimeElapsed doubleValue] > [self.session.currentStage.cookTimeMaximum doubleValue] && [self.session.currentStage.cookTimeMinimum doubleValue] > 0)
//        {
//            //elapsed time is greater than the maximum time
//            self.cookMode = FSTGECooktopCookingStatePrecisionCookingPastMaxTime;
//        }
//        else if ([self.session.currentStageCookTimeElapsed doubleValue] >= [self.session.currentStage.cookTimeMinimum doubleValue] && [self.session.currentStage.cookTimeMinimum doubleValue] > 0)
//        {
//            //elapsed time is greater than the minimum time, but less than or equal to the max time
//            //and the cookTime is set
//            self.cookMode = FSTGECooktopCookingStatePrecisionCookingReachingMaxTime;
//        }
//        else if([self.session.currentStageCookTimeElapsed doubleValue] < [self.session.currentStage.cookTimeMinimum doubleValue] && [self.session.currentStage.cookTimeMinimum doubleValue] > 0)
//        {
//            //elapsed time is less than the minimum time and the cook time is set
//            self.cookMode = FSTGECooktopCookingStatePrecisionCookingReachingMinTime;
//        }
//        else if (self.session.toBeRecipe)
//        {
//            //if we have a desired cooktime (not set yet) and none of the above cases are satisfied
//            self.cookMode = FSTGECooktopCookingStatePrecisionCookingTemperatureReached;
//        }
//        else if([self.session.currentStage.cookTimeMinimum doubleValue] == 0 && !self.session.toBeRecipe)
//        {
//            //cook time not set
//            self.cookMode = FSTGECooktopCookingStatePrecisionCookingWithoutTime;
//        }
//        else
//        {
//            self.cookMode = FSTGECooktopCookingStateUnknown;
//            DLog(@"UNABLE TO DETERMINE COOK MODE");
//        }
    }
    
    //only notify if we have changed cook modes
    if (self.cookMode != currentCookMode)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:FSTCookingModeChangedNotification object:self];
        [self notifyDeviceEssentialDataChanged];
        
        //now if the cooking mode has changed to off lets reset the values by
        //writing them to the paragon
        if (self.cookMode == FSTGECooktopCookingStateOff)
        {
            [self writeElapsedTime];
            [self writeCookTimesWithMinimumCooktime:[NSNumber numberWithInt:0] havingMaximumCooktime:[NSNumber numberWithInt:0]];
        }
    }
    
}


-(void)handleTargetTemperature: (CBCharacteristic*)characteristic
{
    if (characteristic.value.length != 2)
    {
        DLog(@"handleTargetTemperature length of %lu not what was expected, %d", (unsigned long)characteristic.value.length, 2);
        return;
    }
    
    if (self.session.currentStage)
    {
        NSData *data = characteristic.value;
        Byte bytes[characteristic.value.length] ;
        [data getBytes:bytes length:characteristic.value.length];
        uint16_t raw = OSReadBigInt16(bytes, 0);
        self.session.currentStage.targetTemperature = [[NSNumber alloc] initWithDouble:raw/100];
//        [[NSNotificationCenter defaultCenter] postNotificationName:FSTTargetTemperatureChangedNotification object:self];
    }
}

-(void)handleCookTime: (CBCharacteristic*)characteristic
{
    if (characteristic.value.length != 8)
    {
        DLog(@"handleCookTime length of %lu not what was expected, %d", (unsigned long)characteristic.value.length, 8);
        return;
    }
    
    if (self.session.currentStage)
    {
        NSData *data = characteristic.value;
        Byte bytes[characteristic.value.length] ;
        [data getBytes:bytes length:8];
        
        uint16_t minimumTime = OSReadBigInt16(bytes, 0);
        uint16_t maximumTime = OSReadBigInt16(bytes, 2);
        self.session.currentStage.cookTimeMinimum = [[NSNumber alloc] initWithDouble:minimumTime];
        self.session.currentStage.cookTimeMaximum = [[NSNumber alloc] initWithDouble:maximumTime];
        [self determineCookMode];
//        [[NSNotificationCenter defaultCenter] postNotificationName:FSTCookTimeSetNotification object:self];
    }
}

-(void)handleCurrentTemperature: (CBCharacteristic*)characteristic
{
    if (characteristic.value.length != 2)
    {
        DLog(@"handleCurrentTemperature length of %lu not what was expected, %d", (unsigned long)characteristic.value.length, 2);
        return;
    }
    
    if (self.session.currentStage)
    {
        NSData *data = characteristic.value;
        Byte bytes[characteristic.value.length] ;
        [data getBytes:bytes length:characteristic.value.length];
        uint16_t raw = OSReadBigInt16(bytes, 0);
        self.session.currentProbeTemperature = [[NSNumber alloc] initWithDouble:raw/100];
//        [[NSNotificationCenter defaultCenter] postNotificationName:FSTActualTemperatureChangedNotification object:self];
    }
}

#pragma mark - Characteristic Discovery Handler

-(void)handleDiscoverCharacteristics: (NSArray*)characteristics
{
    [super handleDiscoverCharacteristics:characteristics];
    
    self.initialCharacteristicValuesRead = NO;
    [requiredCharacteristics setObject:[NSNumber numberWithBool:0] forKey:FSTGECooktopCharacteristicProbeConnectionState];
    [requiredCharacteristics setObject:[NSNumber numberWithBool:0] forKey:FSTGECooktopCharacteristicBatteryLevel];
    [requiredCharacteristics setObject:[NSNumber numberWithBool:0] forKey:FSTGECooktopCharacteristicBurnerStatus];
    [requiredCharacteristics setObject:[NSNumber numberWithBool:0] forKey:FSTGECooktopCharacteristicCurrentTemperature];
    [requiredCharacteristics setObject:[NSNumber numberWithBool:0] forKey:FSTGECooktopCharacteristicElapsedTime];
    [requiredCharacteristics setObject:[NSNumber numberWithBool:0] forKey:FSTGECooktopCharacteristicTargetTemperature];
    [requiredCharacteristics setObject:[NSNumber numberWithBool:0] forKey:FSTGECooktopCharacteristicCookTime];
    NSLog(@"=======================================================================");
    //NSLog(@"SERVICE %@", [service.UUID UUIDString]);
    
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
                 [[[characteristic UUID] UUIDString] isEqualToString: FSTGECooktopCharacteristicBatteryLevel] ||
                 [[[characteristic UUID] UUIDString] isEqualToString: FSTGECooktopCharacteristicBurnerStatus] ||
                 [[[characteristic UUID] UUIDString] isEqualToString: FSTGECooktopCharacteristicCurrentTemperature] ||
                 [[[characteristic UUID] UUIDString] isEqualToString: FSTGECooktopCharacteristicElapsedTime] ||
                 [[[characteristic UUID] UUIDString] isEqualToString: FSTGECooktopCharacteristicProbeConnectionState] ||
                 [[[characteristic UUID] UUIDString] isEqualToString: FSTGECooktopCharacteristicTargetTemperature]
                 )
            {
                [self.peripheral readValueForCharacteristic:characteristic];
            }
            NSLog(@"        CAN NOTIFY");
        }
        
        if (characteristic.properties & CBCharacteristicPropertyRead)
        {
            if([[[characteristic UUID] UUIDString] isEqualToString: FSTGECooktopCharacteristicCookTime])
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

#ifdef DEBUG
-(void)logParagon
{
//    FSTParagonCookingStage* currentStage = self.session.currentStage;
//    FSTParagonCookingStage* toBeStage = self.session.toBeRecipe.paragonCookingStages[0];
//    NSLog(@"------PARAGON-------");
//    NSLog(@"bmode %d, cmode %d, curtmp %@, stage %@, elapt %@", self.burnerMode, self.cookMode, self.session.currentProbeTemperature, self.session.currentStage, self.session.currentStageCookTimeElapsed);
//    NSLog(@"\tACTIVE RECIPE : tartmp %@, mint %@, maxt %@", currentStage.targetTemperature, currentStage.cookTimeMinimum, currentStage.cookTimeMaximum);
//    if (toBeStage)
//    {
//        NSLog(@"\t  TOBE RECIPE: tartmp %@, mint %@, maxt %@", toBeStage.targetTemperature, toBeStage.cookTimeMinimum, toBeStage.cookTimeMaximum);
//    }
//    else
//    {
//        NSLog(@"\t TOBE RECIPE : not set");
//    }
    
}
#endif

@end
