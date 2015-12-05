
//
//  FSTParagon.m
//  FirstBuild
//
//  Created by Myles Caley on 3/12/15.
//  Copyright (c) 2015 FirstBuild. All rights reserved.
//

#import "FSTParagon.h"
#import "FSTSavedRecipeManager.h"
#import "FSTRecipe.h"
#import "FSTParagonUserInformation.h"

@implementation FSTParagon
{
    NSMutableDictionary *requiredCharacteristics; // a dictionary of strings with booleans
}

//app info service
NSString * const FSTServiceAppInfoService               = @"E936877A-8DD0-FAA7-B648-F46ACDA1F27B";
NSString * const FSTCharacteristicAppInfo               = @"318DB1F5-67F1-119B-6A41-1EECA0C744CE"; //read

//paragon  service
NSString * const FSTServiceParagon                      = @"D6B2767C-C5B6-0088-DC4A-533EB59CA190";
NSString * const FSTCharacteristicProbeFirmwareInfo     = @"83D33E5C-68EA-4158-8655-1A2AC0313FF6"; //read
NSString * const FSTCharacteristicErrorState            = @"5BCBF6B1-DE80-94B6-0F4B-99FB984707B6"; //read,notify
NSString * const FSTCharacteristicProbeConnectionState  = @"6B402ECC-3DDA-8BB4-9E42-F121D7E1CF69"; //read,notify
NSString * const FSTCharacteristicBatteryLevel          = @"A74C3FB9-6E13-B4B9-CD47-465AAD76FCE7"; //read,notify
NSString * const FSTCharacteristicCurrentTemperature    = @"8F080B1C-7C3B-FBB9-584A-F0AFD57028F0"; //read,notify
NSString * const FSTCharacteristicCurrentPowerLevel     = @"B2019449-F5B4-4198-96B4-C148AC941800"; //read,notify
NSString * const FSTCharacteristicBurnerState           = @"B98F1B81-F098-2CBA-7940-EB8C0FFD7BDC"; //read,notify
NSString * const FSTCharacteristicRemainingHoldTime     = @"7FCE08B6-B7B2-168B-C44F-5E576045FD2E"; //read,notify
NSString * const FSTCharacteristicCurrentCookState      = @"F80ABE44-C3D5-E99A-6B46-99DDF227F82D"; //read,notify
NSString * const FSTCharacteristicCurrentCookStage      = @"BB641183-73D8-4FC4-A7E1-7D3DB66FCAA7"; //write,notify,read
NSString * const FSTCharacteristicUserSelectedCookMode  = @"69248452-5AA7-45C8-9FD3-27C73D06D244"; //read,notify
NSString * const FSTCharacteristicTempDisplayUnit       = @"C1382B17-2DE7-4593-BC49-3B01502D42C7"; //write,notify,read
NSString * const FSTCharacteristicStartHoldTimer        = @"4F568285-9D2F-4C3D-864E-7047A30BD4A8"; //write
NSString * const FSTCharacteristicUserInfo              = @"007A7511-0D69-4749-AAE3-856CFF257912"; //write,read
NSString * const FSTCharacteristicCookConfiguration     = @"E0BA615A-A869-1C9D-BE45-4E3B83F592D9"; //write,notify,read

//firmware
NSString * const FSTCharacteristicOtaControlCommand     = @"4FB34AB1-6207-E5A0-484F-E24A7F638FFF"; //write,notify
NSString * const FSTCharacteristicOtaImageData          = @"78282AE5-3060-C3B6-7D49-EC74702414E5"; //write

static const uint8_t NUMBER_OF_STAGES = 5;
static const uint8_t POS_POWER = 0;
static const uint8_t POS_MIN_HOLD_TIME = POS_POWER + 1;
static const uint8_t POS_MAX_HOLD_TIME = POS_MIN_HOLD_TIME + 2;
static const uint8_t POS_TARGET_TEMP = POS_MAX_HOLD_TIME + 2;
static const uint8_t POS_AUTO_TRANSITION = POS_TARGET_TEMP + 2;
static const uint8_t STAGE_SIZE = 8;

//TODO put sizes for the characteristics here and remove magic numbers below

#pragma mark - Allocation

- (id)init
{
    self = [super init];
    
    if (self)
    {
        //setup the current cooking method and session, which is the actual
        //state of the cooking as reported by the cooktop
        self.session = [[FSTParagonCookingSession alloc] init];
        self.session.activeRecipe = nil;
        
        // booleans for all the required characteristics, tell us whether or not the characteristic loaded
        requiredCharacteristics = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
            [[NSNumber alloc] initWithBool:0], FSTCharacteristicProbeConnectionState,
            [[NSNumber alloc] initWithBool:0], FSTCharacteristicBatteryLevel,
            [[NSNumber alloc] initWithBool:0], FSTCharacteristicBurnerState,
            [[NSNumber alloc] initWithBool:0], FSTCharacteristicCurrentTemperature,
            [[NSNumber alloc] initWithBool:0], FSTCharacteristicCurrentCookStage,
            [[NSNumber alloc] initWithBool:0], FSTCharacteristicCurrentCookState,
            [[NSNumber alloc] initWithBool:0], FSTCharacteristicCookConfiguration,
            [[NSNumber alloc] initWithBool:0], FSTCharacteristicUserInfo,
            [[NSNumber alloc] initWithBool:0], FSTCharacteristicRemainingHoldTime,
            [[NSNumber alloc] initWithBool:0], FSTCharacteristicUserSelectedCookMode,
            [[NSNumber alloc] initWithBool:0], FSTCharacteristicCurrentPowerLevel,
                                   nil];
        
        self.session.cookState = FSTParagonCookStateOff;
        self.session.cookMode = FSTCookingStateOff;
    }

    return self;
}

#pragma mark - External Interface Selectors

-(BOOL)sendRecipeToCooktop: (FSTRecipe*)recipe
{
    if (!recipe.paragonCookingStages)
    {
        DLog(@"recipe does not contain any stages");
        return NO;
    }
    else if (self.session.userSelectedCookMode ==  FSTParagonUserSelectedCookModeDirect ||
             self.session.userSelectedCookMode == FSTParagonUserSelectedCookModeScreenOff)
    {
        DLog(@"paragon is not in gentle or rapid cook mode");
        return NO;
    }
    
    [self writeCookConfiguration:recipe];
    return YES;
}

-(void)startTimerForCurrentStage
{
    [self writeStartHoldTimer];
}

-(void)moveNextStage
{
    [self writeMoveNextStage];
}

- (void)startOta
{
    [self writeStartOta];
}

#pragma mark - Write Handlers

-(void)writeHandler: (CBCharacteristic*)characteristic error:(NSError *)error
{
    [super writeHandler:characteristic error:error];
    
    if([[[characteristic UUID] UUIDString] isEqualToString: FSTCharacteristicCurrentCookStage])
    {
        DLog(@"successfully wrote FSTCharacteristicCurrentCookStage");
        [self handleWriteMoveNextStage:error];
    }
    else if([[[characteristic UUID] UUIDString] isEqualToString: FSTCharacteristicTempDisplayUnit])
    {
        //[self handleElapsedTimeWritten];
        DLog(@"successfully wrote FSTCharacteristicTempDisplayUnit");
    }
    else if([[[characteristic UUID] UUIDString] isEqualToString: FSTCharacteristicStartHoldTimer])
    {
        DLog(@"successfully wrote FSTCharacteristicStartHoldTimer");
        [self handleHoldTimerWritten ];
    }
    else if([[[characteristic UUID] UUIDString] isEqualToString: FSTCharacteristicUserInfo])
    {
        DLog(@"successfully wrote FSTCharacteristicUserInfo");
        [self handleUserInformationWritten:error];
    }
    else if([[[characteristic UUID] UUIDString] isEqualToString: FSTCharacteristicCookConfiguration])
    {
        DLog(@"successfully wrote FSTCharacteristicCookConfiguration");
        [self handleCookConfigurationWritten:error];
    }

}

-(void)writeStartOta
{
    CBCharacteristic* characteristic = [self.characteristics objectForKey:FSTCharacteristicOtaControlCommand];
    
    Byte bytes[1];
    bytes[0] = 0x01;
    NSData *data = [[NSData alloc]initWithBytes:bytes length:sizeof(bytes)];
    if (characteristic)
    {
        [self.peripheral writeValue:data forCharacteristic:characteristic type:CBCharacteristicWriteWithResponse];
    }
}

-(void)writeOtaDownloadCommand
{
    CBCharacteristic* characteristic = [self.characteristics objectForKey:FSTCharacteristicOtaControlCommand];
    
    Byte bytes[3];
    bytes[0] = 0x02;
    OSWriteBigInt16(&bytes[1],   0, 23837);
    NSData *data = [[NSData alloc]initWithBytes:bytes length:sizeof(bytes)];
    if (characteristic)
    {
        [self.peripheral writeValue:data forCharacteristic:characteristic type:CBCharacteristicWriteWithResponse];
    }
}

//-(void)writeImage
//{
//    NSString *myFilePath = [[NSBundle mainBundle] pathForResource:@InBox ofType: @txt];
//
//}

-(void)writeOtaImageVerify
{
    CBCharacteristic* characteristic = [self.characteristics objectForKey:FSTCharacteristicOtaControlCommand];
    
    Byte bytes[1];
    bytes[0] = 0x03;
    NSData *data = [[NSData alloc]initWithBytes:bytes length:sizeof(bytes)];
    if (characteristic)
    {
        [self.peripheral writeValue:data forCharacteristic:characteristic type:CBCharacteristicWriteWithResponse];
    }
}

-(void)writeStartHoldTimer
{
    CBCharacteristic* characteristic = [self.characteristics objectForKey:FSTCharacteristicStartHoldTimer];

    Byte bytes[1];
    bytes[0] = 0x01;
    
    NSData *data = [[NSData alloc]initWithBytes:bytes length:sizeof(bytes)];
    if (characteristic)
    {
        [self.peripheral writeValue:data forCharacteristic:characteristic type:CBCharacteristicWriteWithResponse];
    }
}

-(void)handleHoldTimerWritten
{
    
    // the remaining hold time is not reset until after the first push
    // lets set it here
    self.session.remainingHoldTime = [[NSNumber alloc] initWithInt:0];
    
    if ([self.delegate respondsToSelector:@selector(remainingHoldTimeChanged:)])
    {
        [self.delegate remainingHoldTimeChanged:self.session.remainingHoldTime];
    }
    
    [self.delegate holdTimerSet];
}

-(void)writeUserInformation: (FSTParagonUserInformation*)userInformation
{
    CBCharacteristic* characteristic = [self.characteristics objectForKey:FSTCharacteristicUserInfo];
    
    Byte bytes[16];
    memset(bytes,0,sizeof(bytes));
    
    //recipe type
    bytes[0] = userInformation.recipeType;
    
    //recipe id
    OSWriteBigInt16(&bytes[1], 0, userInformation.recipeId);
    
    //package it up
    NSData *data = [[NSData alloc]initWithBytes:bytes length:sizeof(bytes)];
    if (characteristic)
    {
        [self.peripheral writeValue:data forCharacteristic:characteristic type:CBCharacteristicWriteWithResponse];
    }
}

-(void)handleUserInformationWritten: (NSError *)error
{
    CBCharacteristic* characteristic = [self.characteristics objectForKey:FSTCharacteristicUserInfo];

    // the session's active recipe id and type are no longer valid
    // which are stored in the user information portion of the cook configuration
    // on the paragon
    if (self.session.activeRecipe)
    {
        self.session.activeRecipe.recipeType = nil;
        self.session.activeRecipe.recipeId = nil;
    }
    
    // we need to read this back now to make sure we have everything set
    [self.peripheral readValueForCharacteristic:characteristic];
    if ([self.delegate respondsToSelector:@selector(userInformationSet:)])
    {
        [self.delegate userInformationSet:error];
    }
}

-(void)writeMoveNextStage
{
    CBCharacteristic* characteristic = [self.characteristics objectForKey:FSTCharacteristicCurrentCookStage];
    
    Byte bytes[1];
    bytes[0] = self.session.currentStageIndex + 1;
    
    NSData *data = [[NSData alloc]initWithBytes:bytes length:sizeof(bytes)];
    if (characteristic)
    {
        [self.peripheral writeValue:data forCharacteristic:characteristic type:CBCharacteristicWriteWithResponse];
    }
}

-(void)handleWriteMoveNextStage: (NSError *)error
{
    if ([self.delegate respondsToSelector:@selector(nextStageSet:)])
    {
        [self.delegate nextStageSet:error];
    }
    
    if (!error)
    {
        CBCharacteristic* characteristic = [self.characteristics objectForKey:FSTCharacteristicCurrentCookStage];
        [self.peripheral readValueForCharacteristic:characteristic];
    }
}

/**
 *  
 * cook configuration is up to 5 stages
 *   each stage is 8 bytes for a total of 40 bytes
 *   power - 1 byte (0-10)
 *   min hold time - 2 bytes
 *   max hold time - 2 bytes
 *   target temperature - 2 bytes
 *   automatic transition to next stage? - 1 byte
 *
 *  @param recipe Recipe object that contains the stages to be written to the paragon
 */
-(void)writeCookConfiguration: (FSTRecipe*)recipe
{
    CBCharacteristic* characteristic = [self.characteristics objectForKey:FSTCharacteristicCookConfiguration];
    
    if (recipe.paragonCookingStages.count > NUMBER_OF_STAGES)
    {
        DLog(@"too many stages to write to cooktop");
        return;
    }
    
    Byte bytes[NUMBER_OF_STAGES * STAGE_SIZE];
    memset(bytes, 0, sizeof(bytes));
    
    for (uint8_t i=0; i < recipe.paragonCookingStages.count; i++)
    {
        NSLog(@"building stage to send to cooktop...");
        FSTParagonCookingStage* stage = recipe.paragonCookingStages[i];
        uint8_t pos = i * 8;
        bytes[pos+POS_POWER] = [stage.maxPowerLevel unsignedCharValue];
        OSWriteBigInt16(&bytes[pos+POS_MIN_HOLD_TIME],   0, [stage.cookTimeMinimum unsignedShortValue]);

        if (stage.cookTimeMaximum > 0)
        {
            OSWriteBigInt16(&bytes[pos+POS_MAX_HOLD_TIME],   0, [stage.cookTimeMaximum unsignedShortValue] - [stage.cookTimeMinimum unsignedShortValue]);
        }
        else
        {
            OSWriteBigInt16(&bytes[pos+POS_MAX_HOLD_TIME],   0, 0);
        }
        OSWriteBigInt16(&bytes[pos+POS_TARGET_TEMP],     0, [stage.targetTemperature unsignedShortValue]*100);
        bytes[pos+POS_AUTO_TRANSITION] = [stage.automaticTransition unsignedCharValue];
    }
    
    NSData *data = [[NSData alloc]initWithBytes:bytes length:sizeof(bytes)];
    NSLog(@"cook config payload to write: %@", data);
    if (characteristic)
    {
        // write the actual characteristic
        [self.peripheral writeValue:data forCharacteristic:characteristic type:CBCharacteristicWriteWithResponse];
    
        FSTParagonUserInformation* info = [FSTParagonUserInformation new];
        info.recipeId = [recipe.recipeId unsignedShortValue];
        info.recipeType = [recipe.recipeType unsignedCharValue];
        
        [self writeUserInformation: info];
    }
}

/**
 *  called after cook configuration written
 */
-(void)handleCookConfigurationWritten: (NSError *)error
{
    CBCharacteristic* cookConfigurationCharacteristic = [self.characteristics objectForKey:FSTCharacteristicCookConfiguration];

    // the session's active recipe is no longer valid, set it to nil. a new one will
    // be created when we read it back from the paragon
    self.session.activeRecipe = nil;
    
    // request a rebuild of the recipe now
    [self.peripheral readValueForCharacteristic:cookConfigurationCharacteristic];
    
    [self.delegate cookConfigurationSet:error];
}

#pragma mark - Read Handlers

/**
 *  called from the super class BLE Product anytime a characteristic has received new data
 *
 *  @param characteristic the characteristic whose value changed
 */
-(void)readHandler: (CBCharacteristic*)characteristic
{
    [super readHandler:characteristic];
    
    if ([[[characteristic UUID] UUIDString] isEqualToString: FSTCharacteristicProbeFirmwareInfo])
    {
        NSLog(@"char: FSTCharacteristicProbeFirmwareInfo, data: %@", characteristic.value);
        //not implemented
    }
    else if([[[characteristic UUID] UUIDString] isEqualToString: FSTCharacteristicCurrentCookStage])
    {
        NSLog(@"char: FSTCharacteristicCurrentCookStage, data: %@", characteristic.value);
        [requiredCharacteristics setObject:[NSNumber numberWithBool:1] forKey:FSTCharacteristicCurrentCookStage];
        [self handleCurrentCookStage: characteristic];
    }
    else if([[[characteristic UUID] UUIDString] isEqualToString: FSTCharacteristicErrorState])
    {
        NSLog(@"char: FSTCharacteristicErrorState, data: %@", characteristic.value);
        //not implemented
    }
    else if([[[characteristic UUID] UUIDString] isEqualToString: FSTCharacteristicProbeConnectionState])
    {
        NSLog(@"char: FSTCharacteristicProbeConnectionState, data: %@", characteristic.value);
        [requiredCharacteristics setObject:[NSNumber numberWithBool:1] forKey:FSTCharacteristicProbeConnectionState];
        //not implemented
    }
    else if([[[characteristic UUID] UUIDString] isEqualToString: FSTCharacteristicBatteryLevel])
    {
        NSLog(@"char: FSTCharacteristicBatteryLevel, data: %@", characteristic.value);
        [requiredCharacteristics setObject:[NSNumber numberWithBool:1] forKey:FSTCharacteristicBatteryLevel];
        [self handleBatteryLevel:characteristic];
    }
    else if([[[characteristic UUID] UUIDString] isEqualToString: FSTCharacteristicBurnerState])
    {
        NSLog(@"char: FSTCharacteristicBurnerState, data: %@", characteristic.value);
        [requiredCharacteristics setObject:[NSNumber numberWithBool:1] forKey:FSTCharacteristicBurnerState];
        [self handleBurnerStatus:characteristic];
    }
    else if([[[characteristic UUID] UUIDString] isEqualToString: FSTCharacteristicCurrentCookState])
    {
        NSLog(@"char: FSTCharacteristicCurrentCookState, data: %@", characteristic.value);
        [requiredCharacteristics setObject:[NSNumber numberWithBool:1] forKey:FSTCharacteristicCurrentCookState];
        [self handleCurrentCookState:characteristic];
    }
    else if([[[characteristic UUID] UUIDString] isEqualToString: FSTCharacteristicCookConfiguration])
    {
        NSLog(@"char: FSTCharacteristicCookConfiguration, data: %@", characteristic.value);
        [requiredCharacteristics setObject:[NSNumber numberWithBool:1] forKey:FSTCharacteristicCookConfiguration];
        [self handleCookConfiguration:characteristic];
    }
    else if([[[characteristic UUID] UUIDString] isEqualToString: FSTCharacteristicUserInfo])
    {
        NSLog(@"char: FSTCharacteristicUserInfo, data: %@", characteristic.value);
        [requiredCharacteristics setObject:[NSNumber numberWithBool:1] forKey:FSTCharacteristicUserInfo];
        [self handleUserInformation:characteristic];
    }
    else if([[[characteristic UUID] UUIDString] isEqualToString:FSTCharacteristicCurrentTemperature])
    {
        [requiredCharacteristics setObject:[NSNumber numberWithBool:1] forKey:FSTCharacteristicCurrentTemperature];
        [self handleCurrentTemperature:characteristic];
    }
    else if([[[characteristic UUID] UUIDString] isEqualToString:FSTCharacteristicUserSelectedCookMode])
    {
        NSLog(@"char: FSTCharacteristicUserSelectedCookMode, data: %@", characteristic.value);
        [requiredCharacteristics setObject:[NSNumber numberWithBool:1] forKey:FSTCharacteristicUserSelectedCookMode];
        [self handleUserSelectedCookMode:characteristic];
    }
    else if([[[characteristic UUID] UUIDString] isEqualToString:FSTCharacteristicCurrentPowerLevel])
    {
        NSLog(@"char: FSTCharacteristicCurrentPowerLevel, data: %@", characteristic.value);
        [requiredCharacteristics setObject:[NSNumber numberWithBool:1] forKey:FSTCharacteristicCurrentPowerLevel];
        [self handleCurrentPowerLevel:characteristic];
    }
    else if ([[[characteristic UUID] UUIDString] isEqualToString:FSTCharacteristicRemainingHoldTime])
    {
        NSLog(@"char: FSTCharacteristicRemainingHoldTime, data: %@", characteristic.value);
        [requiredCharacteristics setObject:[NSNumber numberWithBool:1] forKey:FSTCharacteristicRemainingHoldTime];
        [self handleRemainingHoldTime:characteristic];
    }// end all characteristic cases
    
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
    
#ifdef DEBUG
    if ([[[characteristic UUID] UUIDString] isEqualToString:FSTCharacteristicCurrentTemperature])
    {
        //printf(".");
    }
    else
    {
        //[self logParagon];
    }
#endif
    
    
} // end assignToProperty

-(void)handleUserInformation: (CBCharacteristic*)characteristic
{
    if (characteristic.value.length != 16)
    {
        DLog(@"handleUserInformation length of %lu not what was expected, %d", (unsigned long)characteristic.value.length, 16);
        return;
    }
    
    FSTParagonUserInformation* _userInformation = [FSTParagonUserInformation new];

    // this reflects the most recent version of the user information
    NSData *data = characteristic.value;
    Byte bytes[characteristic.value.length] ;
    [data getBytes:bytes length:characteristic.value.length];
    
    _userInformation.recipeType = bytes[0];
    _userInformation.recipeId   = OSReadBigInt16(&bytes[1],0);
    
    if (self.session.activeRecipe)
    {
        self.session.activeRecipe.recipeType = [NSNumber numberWithChar:_userInformation.recipeType];
        self.session.activeRecipe.recipeId = [NSNumber numberWithUnsignedShort:_userInformation.recipeId];
        
        [self determineCookMode];
        [self setCurrentStageInCookingMatrixWithCurrentIndex];
    }
    else
    {
        DLog(@">>>>>>>> NO ACTIVE RECIPE TO SET USER INFORMATION TO <<<<<<<<< ");
    }
    
#ifdef DEBUG
    [self logParagon];
#endif
}

-(void)handleCurrentPowerLevel: (CBCharacteristic*)characteristic
{
    if (characteristic.value.length != 1)
    {
        DLog(@"handleCurrentPowerLevel length of %lu not what was expected, %d", (unsigned long)characteristic.value.length, 1);
        return;
    }
    
    NSData *data = characteristic.value;
    Byte bytes[characteristic.value.length] ;
    [data getBytes:bytes length:characteristic.value.length];
    self.session.currentPowerLevel = [NSNumber numberWithInt:bytes[0]];
    
    if ([self.delegate respondsToSelector:@selector(currentPowerLevelChanged:)])
    {
        [self.delegate currentPowerLevelChanged:self.session.currentPowerLevel];
    }
}

/**
 *  Called when the cook configuration has changed (i.e. on load of the app), or directly read. If 
 *  the user sets the cook configuration from the app then after it successfully writes it a read is called
 *  so this method will then be called.
 *
 *  The data is returned in the following format
 *    Byte bytes[] = {
 *        //pwr   //min         //max         //temp          //auto
 *        0x01 ,  0x00, 0x01,   0x02, 0x57,   0x88, 0xb8,     0x00, //stage 1
 *        0x07,   0x00, 0x14,   0x00, 0x00,   0x88, 0xb8,     0x01, //stage 2
 *        0x00,   0x00, 0x00,   0x00, 0x00,   0x00, 0x00,     0x00,
 *        0x00,   0x00, 0x00,   0x00, 0x00,   0x00, 0x00,     0x00,
 *        0x00,   0x00, 0x00,   0x00, 0x00,   0x00, 0x00,     0x00
 *    };
 *
 *  @param characteristic BLE characteristic
 */
-(void)handleCookConfiguration: (CBCharacteristic*)characteristic
{
    //TODO: there is a bug, when reading a user selected mode of rapid or gentle then its
    //only reporting 38 bytes.
    if (!(characteristic.value.length == 40 || characteristic.value.length == 8 ||  characteristic.value.length == 38))
    {
        DLog(@"handleCookConfiguration length of %lu not what was expected, %d or %d", (unsigned long)characteristic.value.length, 40, 8);
        return;
    }
    
    NSData *data = characteristic.value;
    Byte bytes[characteristic.value.length] ;
    [data getBytes:bytes length:characteristic.value.length];
    
    // the active recipe is no longer valid, lets create a new one
    self.session.activeRecipe = [FSTRecipe new];
    
    uint8_t numberOfStages ;
    
    //TODO: there is a bug, when reading a user selected mode of rapid or gentle then its
    //only reporting 38 bytes.
    if (characteristic.value.length == 8 || characteristic.value.length == 38)
    {
        numberOfStages = 1;
    }
    else
    {
        numberOfStages = NUMBER_OF_STAGES;
    }
    
    // setup all the stages based on the incoming payload
    for (uint8_t i=0; i < numberOfStages; i++)
    {
        uint8_t pos = i * 8;
        uint16_t minTime = OSReadBigInt16(&bytes[pos+POS_MIN_HOLD_TIME],0);
        uint16_t maxTime = OSReadBigInt16(&bytes[pos+POS_MAX_HOLD_TIME],0);
        uint16_t targetTemp = OSReadBigInt16(&bytes[pos+POS_TARGET_TEMP],0)/100;
        uint8_t maxPowerLevel = bytes[pos+POS_POWER];
        uint8_t automaticTransition = bytes[pos+POS_AUTO_TRANSITION];
        
        if (!(maxPowerLevel==0 && minTime==0 && targetTemp==0))
        {
            FSTParagonCookingStage* stage = [self.session.activeRecipe addStage];
            stage.maxPowerLevel =       [NSNumber numberWithChar:maxPowerLevel];
            stage.cookTimeMinimum =     [NSNumber numberWithUnsignedShort:minTime];
            stage.cookTimeMaximum =     [NSNumber numberWithUnsignedShort:maxTime];
            stage.targetTemperature =   [NSNumber numberWithUnsignedShort:targetTemp ];
            stage.automaticTransition = [NSNumber numberWithChar:automaticTransition];
        }
    }
    
    if (self.session.activeRecipe.paragonCookingStages.count)
    {
        // since we have a new recipe the current stage is going to be the first one
        self.session.currentStage = self.session.activeRecipe.paragonCookingStages[0];
    }
    
    [self setCurrentStageInCookingMatrixWithCurrentIndex];
    
    if ([self.delegate respondsToSelector:@selector(cookConfigurationChanged)])
    {
        [self.delegate cookConfigurationChanged];
    }
    
#ifdef DEBUG
    [self logParagon];
#endif
    
}

/**
 *  This is called when the cooking stage is changed by the paragon. Call the delegate method
 *  with an actual index so the receive can use that for whatever purposes. There is also the
 *  pointer to the current stage on the session itself
 *
 *  @param characteristic BLE characteristic
 */
-(void)handleCurrentCookStage: (CBCharacteristic*)characteristic
{
    if (characteristic.value.length != 1)
    {
        DLog(@"handleCurrentCookStage length of %lu not what was expected, %d", (unsigned long)characteristic.value.length, 1);
        return;
    }
    NSData *data = characteristic.value;
    Byte bytes[characteristic.value.length] ;
    [data getBytes:bytes length:characteristic.value.length];
    
    uint8_t stage = bytes[0];
    self.session.currentStageIndex = stage;
    
    if (self.session.currentStageIndex > self.session.activeRecipe.paragonCookingStages.count)
    {
        DLog("incoming stage from paragon greater than available (may not have cook config yet), just set index for now");
        return;
    }
    
    if (self.session.currentStageIndex == 0)
    {
        DLog("no current stage");
        return;
    }

    [self setCurrentStageInCookingMatrixWithCurrentIndex];

}

-(void)setCurrentStageInCookingMatrixWithCurrentIndex
{    
    if (self.session.currentStageIndex == 0 && self.session.activeRecipe.paragonCookingStages.count)
    {
        // current index not set, so point the stage to the first element
        self.session.currentStage = self.session.activeRecipe.paragonCookingStages[0];
    }
    else if (self.session.currentStageIndex <= self.session.activeRecipe.paragonCookingStages.count)
    {
        self.session.currentStage = self.session.activeRecipe.paragonCookingStages[self.session.currentStageIndex-1];
    }
    else
    {
        NSLog(@">>>>>>>>>> STAGE INDEX GREATER THAN COOKING ARRAY LENGTH <<<<<<<<<<<<<<<");
    }
    
    if ([self.delegate respondsToSelector:@selector(currentStageIndexChanged:)])
    {
        [self.delegate currentStageIndexChanged:[NSNumber numberWithInt: self.session.currentStageIndex]];
    }
}

/**
 *  Called when remaining hold time is counted down
 *
 *  @param characteristic BLE characteristic
 */
-(void)handleRemainingHoldTime: (CBCharacteristic*)characteristic
{
    if (characteristic.value.length != 2)
    {
        DLog(@"handleRemainingHoldTime length of %lu not what was expected, %d", (unsigned long)characteristic.value.length, 2);
        return;
    }
    NSData *data = characteristic.value;
    Byte bytes[characteristic.value.length] ;
    [data getBytes:bytes length:characteristic.value.length];
    uint16_t raw = OSReadBigInt16(bytes, 0);
    self.session.remainingHoldTime = [[NSNumber alloc] initWithDouble:raw];
    if ([self.delegate respondsToSelector:@selector(remainingHoldTimeChanged:)])
    {
        [self.delegate remainingHoldTimeChanged:self.session.remainingHoldTime];
    }
    
    //we need to check the cook mode. if the remaining time is now 0 then we don't
    //get a notification for a new cookmode if it is reaching past the maximum
    [self determineCookMode];
}

/**
 *  Called when the cook state is changed. Depending on the cook state from the paragon
 *  we then set the cook mode. this also takes into account what cook mode the user 
 *  has selected on the actual paragon.
 *
 *  @param characteristic <#characteristic description#>
 */
-(void)handleCurrentCookState: (CBCharacteristic*)characteristic
{
    if (characteristic.value.length != 1)
    {
        DLog(@"handleCurrentCookState length of %lu not what was expected, %d", (unsigned long)characteristic.value.length, 1);
        return;
    }
    
    NSData *data = characteristic.value;
    Byte bytes[characteristic.value.length] ;
    [data getBytes:bytes length:characteristic.value.length];
    self.session.cookState = bytes[0];
    
    [self determineCookMode];
}

/**
 * Called when the user selects a cook mode on the paragon
 *
 *
 * @param characteristic BLE characteristc
 */
-(void)handleUserSelectedCookMode: (CBCharacteristic*)characteristic
{
    if (characteristic.value.length != 1)
    {
        DLog(@"handleUserSelectedCookMode length of %lu not what was expected, %d", (unsigned long)characteristic.value.length, 1);
        return;
    }
    
    NSData *data = characteristic.value;
    Byte bytes[characteristic.value.length] ;
    [data getBytes:bytes length:characteristic.value.length];
    self.session.userSelectedCookMode = bytes[0];
    
    [self determineCookMode];
}

-(void)determineCookMode
{
    ParagonCookMode currentCookMode = self.session.cookMode;
    
    if (self.session.userSelectedCookMode == FSTParagonUserSelectedCookModeDirect)
    {
        //we are in direct cook mode, determine what each of the states mean
        if (self.session.cookState == FSTParagonCookStateReachingTemperature)
        {
            self.session.cookMode = FSTCookingDirectCooking;
        }
        else if (self.session.cookState == FSTParagonCookStateOff)
        {
            self.session.cookMode = FSTCookingStateOff;
        }
    }
    else if (self.session.userSelectedCookMode == FSTParagonUserSelectedCookModeRemote)
    {
        if (self.session.cookState == FSTParagonCookStateReachingTemperature)
        {
            self.session.cookMode = FSTCookingStatePrecisionCookingReachingTemperature;
        }
        else if(self.session.cookState == FSTParagonCookStateReady)
        {
            self.session.cookMode = FSTCookingStatePrecisionCookingTemperatureReached;
        }
        else if(self.session.cookState == FSTParagonCookStateCooking)
        {
            self.session.cookMode = FSTCookingStatePrecisionCookingReachingMinTime;
        }
        else if (self.session.cookState == FSTParagonCookStateDone &&
                 [self.session.activeRecipe.recipeType intValue] == FSTRecipeTypeFirstBuildMultiStage)
        {
            self.session.cookMode = FSTCookingStatePrecisionCookingCurrentStageDone;
        }
        else if ( self.session.cookState == FSTParagonCookStateDone &&
                 [self.session.remainingHoldTime intValue] == 0 &&
                 (currentCookMode == FSTCookingStatePrecisionCookingReachingMaxTime || !currentCookMode)
                 )
        {
            //we need to make sure the paragon thinks its done, there is no more hold time remaining AND
            //the current app cook mode is reaching max time or there is not current cook mode which
            //could be the case when the app is opened against an already existing session. the issue here
            //was that the paragon cook state (self.session.cookState) was announced as done before the new
            //hold timer for the reaching max was set. therefore the app thought it was reaching past max.
            self.session.cookMode = FSTCookingStatePrecisionCookingPastMaxTime;
        }
        else if (self.session.cookState == FSTParagonCookStateDone)
        {
            self.session.cookMode = FSTCookingStatePrecisionCookingReachingMaxTime;
        }
        else if (self.session.cookState == FSTParagonCookStateOff)
        {
            self.session.cookMode = FSTCookingStateOff;
        }
    }
    else if (self.session.userSelectedCookMode == FSTParagonUserSelectedCookModeGentle ||
             self.session.userSelectedCookMode == FSTParagonUserSelectedCookModeRapid
        )
    {
        if (self.session.cookState == FSTParagonCookStateReachingTemperature)
        {
            self.session.cookMode = FSTCookingStatePrecisionCookingReachingTemperature;
        }
        else if(self.session.cookState == FSTParagonCookStateReady)
        {
            self.session.cookMode = FSTCookingStatePrecisionCookingWithoutTime;
        }
        else if(self.session.cookState == FSTParagonCookStateCooking)
        {
            self.session.cookMode = FSTCookingStatePrecisionCookingWithoutTime;
        }
        else if (self.session.cookState == FSTParagonCookStateOff)
        {
            self.session.cookMode = FSTCookingStateOff;
        }
        else
        {
            NSLog(@">>>>>>>> UNKNOWN COOK MODE <<<<<<<<<<");
            self.session.cookMode = FSTCookingStateUnknown;
        }
    }
    else if (self.session.userSelectedCookMode == FSTParagonUserSelectedCookModeScreenOff)
    {
        self.session.cookMode = FSTCookingStateOff;
    }
    
#ifdef DEBUG
    [self logParagon];
#endif
    
    //only notify if we have changed cook modes
    if (self.session.cookMode != currentCookMode)
    {
        if ([self.delegate respondsToSelector:@selector(cookModeChanged:)])
        {
            [self.delegate cookModeChanged:self.session.cookMode];
        }
        
        [self notifyDeviceEssentialDataChanged];
    }
}

//TODO: move to ble product
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
 *  called when the burner stagus changes - on/off. This function currently doesn't perform any action 
 *  as a result of the burner changing.
 *
 *  @param characteristic <#characteristic description#>
 */
-(void)handleBurnerStatus: (CBCharacteristic*)characteristic
{
    if (characteristic.value.length != 1)
    {
        DLog(@"handleBurnerStatus length of %lu not what was expected, %d", (unsigned long)characteristic.value.length, 1);
        return;
    }
    
    NSData *data = characteristic.value;
    Byte bytes[characteristic.value.length] ;
    [data getBytes:bytes length:characteristic.value.length];
    if (bytes[0] == 1 || bytes[0] == 0)
    {
        self.session.burnerMode = bytes[0];
    }
    else
    {
        DLog(@"attempted to set unknown burner state, %d", bytes[0]);
    }
}

/**
 *  called when value changed or reported from the thermometer
 *
 *  @param characteristic <#characteristic description#>
 */
-(void)handleCurrentTemperature: (CBCharacteristic*)characteristic
{
    NSNumber* oldTemp = self.session.currentProbeTemperature;
    if (characteristic.value.length != 2)
    {
        DLog(@"handleCurrentTemperature length of %lu not what was expected, %d", (unsigned long)characteristic.value.length, 2);
        return;
    }
    
    NSData *data = characteristic.value;
    Byte bytes[characteristic.value.length] ;
    [data getBytes:bytes length:characteristic.value.length];
    uint16_t raw = OSReadBigInt16(bytes, 0);
    
    self.session.currentProbeTemperature = [[NSNumber alloc] initWithDouble:raw/100];
    if ([self.delegate respondsToSelector:@selector(actualTemperatureChanged:)])
    {
        [self.delegate actualTemperatureChanged:self.session.currentProbeTemperature];
    }
    
    if (!oldTemp)
    {
        [self notifyDeviceEssentialDataChanged];
    }
}

#pragma mark - Characteristic Discovery Handler

-(void)handleDiscoverCharacteristics: (NSArray*)characteristics
{
    [super handleDiscoverCharacteristics:characteristics];
    
    self.initialCharacteristicValuesRead = NO;
    [requiredCharacteristics setObject:[NSNumber numberWithBool:0] forKey:FSTCharacteristicProbeConnectionState];
    [requiredCharacteristics setObject:[NSNumber numberWithBool:0] forKey:FSTCharacteristicBatteryLevel];
    [requiredCharacteristics setObject:[NSNumber numberWithBool:0] forKey:FSTCharacteristicBurnerState];
    [requiredCharacteristics setObject:[NSNumber numberWithBool:0] forKey:FSTCharacteristicCurrentTemperature];
    [requiredCharacteristics setObject:[NSNumber numberWithBool:0] forKey:FSTCharacteristicCurrentCookStage];
    [requiredCharacteristics setObject:[NSNumber numberWithBool:0] forKey:FSTCharacteristicCurrentCookState];
    [requiredCharacteristics setObject:[NSNumber numberWithBool:0] forKey:FSTCharacteristicCookConfiguration];
    [requiredCharacteristics setObject:[NSNumber numberWithBool:0] forKey:FSTCharacteristicUserInfo];
    [requiredCharacteristics setObject:[NSNumber numberWithBool:0] forKey:FSTCharacteristicRemainingHoldTime];
    [requiredCharacteristics setObject:[NSNumber numberWithBool:0] forKey:FSTCharacteristicCurrentPowerLevel];
    [requiredCharacteristics setObject:[NSNumber numberWithBool:0] forKey:FSTCharacteristicUserSelectedCookMode];
    
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
                 [[[characteristic UUID] UUIDString] isEqualToString: FSTCharacteristicBatteryLevel] ||
                 [[[characteristic UUID] UUIDString] isEqualToString: FSTCharacteristicBurnerState] ||
                 [[[characteristic UUID] UUIDString] isEqualToString: FSTCharacteristicCurrentTemperature] ||
                 [[[characteristic UUID] UUIDString] isEqualToString: FSTCharacteristicCurrentCookStage] ||
                 [[[characteristic UUID] UUIDString] isEqualToString: FSTCharacteristicProbeConnectionState] ||
                 [[[characteristic UUID] UUIDString] isEqualToString: FSTCharacteristicCurrentCookState] ||
                 [[[characteristic UUID] UUIDString] isEqualToString: FSTCharacteristicTempDisplayUnit] ||
                 [[[characteristic UUID] UUIDString] isEqualToString: FSTCharacteristicRemainingHoldTime] ||
                 [[[characteristic UUID] UUIDString] isEqualToString: FSTCharacteristicUserSelectedCookMode] ||
                 [[[characteristic UUID] UUIDString] isEqualToString: FSTCharacteristicCurrentPowerLevel]
                 )
            {
                [self.peripheral readValueForCharacteristic:characteristic];
            }
            NSLog(@"        CAN NOTIFY");
        }
        
        if (characteristic.properties & CBCharacteristicPropertyRead)
        {
            if([[[characteristic UUID] UUIDString] isEqualToString: FSTCharacteristicCookConfiguration] ||
               [[[characteristic UUID] UUIDString] isEqualToString: FSTCharacteristicUserInfo]
               )
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
    
    NSLog(@"-----------------------------------------------------");
    NSLog(@"                    PARAGON");
    NSLog(@"mode: %d", self.session.userSelectedCookMode);
    NSLog(@"burner %d, app cook state %d, paragon cook state %d, probe temp %@, cur stage %d, remaining time %@", self.session.burnerMode, self.session.cookMode, self.session.cookState, self.session.currentProbeTemperature, self.session.currentStageIndex, self.session.remainingHoldTime);
    NSLog(@"recipe id %@, recipe type %@", self.session.activeRecipe.recipeId, self.session.activeRecipe.recipeType);
    NSLog(@" stage table");

    for (uint8_t i=0; i<self.session.activeRecipe.paragonCookingStages.count;i++)
    {
        FSTParagonCookingStage* stage= self.session.activeRecipe.paragonCookingStages[i];
        NSLog(@"\t stage %i: tartmp %@, mint %@, maxt %@, maxpwr %@, trans %@", i+1, stage.targetTemperature, stage.cookTimeMinimum, stage.cookTimeMaximum, stage.maxPowerLevel, stage.automaticTransition);

    }
    NSLog(@"current stage instructions: \n\t%@", self.session.currentStage.cookingLabel);
    NSLog(@"current stage prep instructions: \n\t%@", self.session.currentStage.cookingPrepLabel);
    NSLog(@"-----------------------------------------------------");
    
}
#endif

@end
