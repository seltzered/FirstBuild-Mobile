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
NSString * const FSTCookModeChangedNotification             = @"FSTCookModeChangedNotification";
NSString * const FSTElapsedTimeChangedNotification          = @"FSTElapsedTimeChangedNotification";

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

__weak NSTimer* _readCharacteristicsTimer;

#ifdef SIMULATE_PARAGON

//heating state
double _heatingUpdateFrequency = 200;
NSTimeInterval _heatingLastUpdate = 0;
uint8_t _heatingIncrement = 0;
uint16_t _actualTemperatureSimulation = 72;

//power on state
double _waitingForPowerOnNotificationFrequency = 2000;
NSTimeInterval _waitingForPowerOnNotificationLastUpdate = 0;

//regulating temperature for set time state
double _timeRegulateFrequency = 1000;
NSTimeInterval _timeRegulateLastUpdate = 0;
NSTimeInterval _elapsedTime = 0;

//state machine
typedef enum {
    kPARAGON_SIMULATOR_STATE_OFF = 0,
    kPARAGON_SIMULATOR_POWER_ON,
    kPARAGON_SIMULATOR_STATE_HEATING,
    kPARAGON_SIMULATOR_STATE_TIME_REGULATE
} PARAGON_SIMULATOR_STATE;

uint8_t _currentSimulationState = kPARAGON_SIMULATOR_STATE_OFF;

#endif

- (id)init
{
    self = [super init];
    
    if (self)
    {
        //self.currentCookingMethod = [[FSTCookingMethod alloc]init];
//        [self.currentCookingMethod createCookingSession];
//        [self.currentCookingMethod addStageToCookingSession];
    }
#ifdef SIMULATE_PARAGON
    [self startParagonSimulator];
#endif
    return self;
    
}

-(void)dealloc
{
    [_readCharacteristicsTimer invalidate];
}

#pragma mark - Interactions

-(void)startHeatingWithTemperature: (NSNumber*)targetTemperature
{
    Byte bytes[2] ;
    OSWriteBigInt16(bytes, 0, [targetTemperature doubleValue]*100);
    NSData *data = [[NSData alloc]initWithBytes:bytes length:2];

    CBCharacteristic* characteristic = [self.characteristics objectForKey:FSTCharacteristicTargetTemperature];
    
    if (characteristic)
    {
        [self.peripheral writeValue:data forCharacteristic:characteristic type:CBCharacteristicWriteWithResponse];
    }
}

-(void)setCookingTime: (NSNumber*)cookingTime
{
    Byte bytes[2] ;
    OSWriteBigInt16(bytes, 0, [cookingTime unsignedIntegerValue]);
    NSData *data = [[NSData alloc]initWithBytes:bytes length:2];
    
    CBCharacteristic* characteristic = [self.characteristics objectForKey:FSTCharacteristicCookTime];
    
    if (characteristic)
    {
        [self.peripheral writeValue:data forCharacteristic:characteristic type:CBCharacteristicWriteWithResponse];
    }
}

-(void)readCharacteristicsTimerTimeout:(NSTimer *)timer
{
    [self.peripheral readValueForCharacteristic:[self.characteristics objectForKey:FSTCharacteristicCurrentTemperature]];
    [self.peripheral readValueForCharacteristic:[self.characteristics objectForKey:FSTCharacteristicTargetTemperature]];
    [self.peripheral readValueForCharacteristic:[self.characteristics objectForKey:FSTCharacteristicElapsedTime]];
    [self.peripheral readValueForCharacteristic:[self.characteristics objectForKey:FSTCharacteristicBurnerStatus]];
    [self.peripheral readValueForCharacteristic:[self.characteristics objectForKey:FSTCharacteristicCookTime]];
}

-(void)assignValueToPropertyFromCharacteristic: (CBCharacteristic*)characteristic
{
    FSTParagonCookingStage* currentStage = self.currentCookingMethod.session.paragonCookingStages[0];

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
        //not implemented
    }
    else if([[[characteristic UUID] UUIDString] isEqualToString: FSTCharacteristicBatteryLevel])
    {
        //not implemented
    }
    else if([[[characteristic UUID] UUIDString] isEqualToString: FSTCharacteristicBurnerStatus])
    {
        //00 00 60 00 00 <-- start sous vide mode
        //0000 f3 0000 <-- preheat
        //0000c00000 <-- cookingout
        NSData *data = characteristic.value;
        Byte bytes[5] ;
        [data getBytes:bytes length:5];
        
        switch (bytes[4] >> 4)
        {
            case 0xf:
                self.currentCookMode = kPARAGON_PREHEATING;
                break;
                
            case 0x6:
                self.currentCookMode = kPARAGON_SOUS_VIDE_ENABLED;
                break;
                
            case 0xc:
                //if the cooktop is actually reporting a cook time is set
                //and we are past the preheating stage then indicate
                if ([currentStage.cookTimeRequestedActual integerValue] > 0)
                {
                    self.currentCookMode = kPARAGON_HEATING_WITH_TIME;
                }
                else
                {
                    self.currentCookMode = kPARAGON_HEATING;
                }
                break;
                
            default:
                self.currentCookMode = kPARAGON_OFF;
                break;
        }
        
        [[NSNotificationCenter defaultCenter] postNotificationName:FSTCookModeChangedNotification object:self];
        NSLog(@"FSTCharacteristicBurnerStatus %d", self.currentCookMode );
    }
    else if([[[characteristic UUID] UUIDString] isEqualToString: FSTCharacteristicElapsedTime])
    {
        if (currentStage)
        {
            NSData *data = characteristic.value;
            Byte bytes[2] ;
            [data getBytes:bytes length:2];
            uint16_t raw = OSReadBigInt16(bytes, 0);
            currentStage.cookTimeElapsed = [[NSNumber alloc] initWithDouble:raw];
            [[NSNotificationCenter defaultCenter] postNotificationName:FSTElapsedTimeChangedNotification object:self];
            NSLog(@"FSTCharacteristicElapsedTime %@", currentStage.cookTimeElapsed );
        }
    }
    else if([[[characteristic UUID] UUIDString] isEqualToString: FSTCharacteristicTargetTemperature])
    {
        if (currentStage)
        {
            NSData *data = characteristic.value;
            Byte bytes[2] ;
            [data getBytes:bytes length:2];
            uint16_t raw = OSReadBigInt16(bytes, 0);
            NSLog(@"FSTCharacteristicTargetTemperature %@", currentStage.targetTemperature );
        }
    }
    else if([[[characteristic UUID] UUIDString] isEqualToString: FSTCharacteristicCookTime])
    {
        if (currentStage)
        {
            NSData *data = characteristic.value;
            Byte bytes[2] ;
            [data getBytes:bytes length:2];
            uint16_t raw = OSReadBigInt16(bytes, 0);
            currentStage.cookTimeRequestedActual = [[NSNumber alloc] initWithDouble:raw];
            NSLog(@"FSTCharacteristicCookTime %@", currentStage.cookTimeRequestedActual );
        }
        //not implemented
    }
    else if([[[characteristic UUID] UUIDString] isEqualToString:FSTCharacteristicCurrentTemperature])
    {
        if (currentStage)
        {
            NSData *data = characteristic.value;
            Byte bytes[2] ;
            [data getBytes:bytes length:2];
            uint16_t raw = OSReadBigInt16(bytes, 0);
            currentStage.actualTemperature = [[NSNumber alloc] initWithDouble:raw/100];
            [[NSNotificationCenter defaultCenter] postNotificationName:FSTActualTemperatureChangedNotification object:self];
            NSLog(@"FSTCharacteristicCurrentTemperature %@", currentStage.actualTemperature );
        }
    }
}

#pragma mark - <CBPeripheralDelegate>

-(void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error
{
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
            //[self.peripheral readValueForCharacteristic:characteristic];
            //[self.peripheral setNotifyValue:YES forCharacteristic:characteristic];
            NSLog(@"        CAN NOTIFY");
        }
        
        if (characteristic.properties & CBCharacteristicPropertyRead)
        {
            [self.peripheral readValueForCharacteristic:characteristic];
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
    __weak typeof(self) weakSelf = self;
    _readCharacteristicsTimer = [NSTimer timerWithTimeInterval:5.0 target:weakSelf selector:@selector(readCharacteristicsTimerTimeout:) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:_readCharacteristicsTimer forMode:NSRunLoopCommonModes];
    NSArray * services;
    services = [self.peripheral services];
    for (CBService *service in services)
    {
        [self.peripheral discoverCharacteristics:nil forService:service];
    }
}

-(void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    NSLog(@"characteristic %@ changed value %@", characteristic.UUID, characteristic.value);
    [self assignValueToPropertyFromCharacteristic:characteristic];

}

-(void)peripheral:(CBPeripheral *)peripheral didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    NSLog(@"characteristic %@ notification failed %@", characteristic.UUID, error);
}

-(void)peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    
}

#pragma mark - Simulations

#ifdef SIMULATE_PARAGON

- (void) startParagonSimulator
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(20)), dispatch_get_main_queue(), ^{
        [self paragonSimulatorTick];
    });
}

- (void)setSimulatorHeatingUpdateInterval: (NSTimeInterval)interval
{
    _heatingUpdateFrequency = interval;
}

- (void)setSimulatorHeatingTemperatureIncrement: (uint8_t)increment
{
    _heatingIncrement = increment;
}

- (void)startSimulatePowerOn
{
    _currentSimulationState = kPARAGON_SIMULATOR_POWER_ON;
    _waitingForPowerOnNotificationLastUpdate = [NSDate timeIntervalSinceReferenceDate]*1000 +_waitingForPowerOnNotificationFrequency;
}

- (void)startSimulateHeating
{
    _currentSimulationState = kPARAGON_SIMULATOR_STATE_HEATING;
}

- (void)startSimulatingTimeWithTemperatureRegulating
{
    _elapsedTime = 0;
    _currentSimulationState = kPARAGON_SIMULATOR_STATE_TIME_REGULATE;

}

- (void)paragonSimulatorTick
{
    NSTimeInterval elapsed = [NSDate timeIntervalSinceReferenceDate]*1000;
    
    switch (_currentSimulationState)
    {
        case kPARAGON_SIMULATOR_POWER_ON:
            if (elapsed - _waitingForPowerOnNotificationLastUpdate > _waitingForPowerOnNotificationFrequency)
            {
                [self simulatePowerOn];
                _waitingForPowerOnNotificationLastUpdate = [NSDate timeIntervalSinceReferenceDate]*1000;
            }
            break;
            
        case kPARAGON_SIMULATOR_STATE_HEATING:
            if (elapsed - _heatingLastUpdate > _heatingUpdateFrequency)
            {
                [self simulateHeatingTick];
                _heatingLastUpdate = [NSDate timeIntervalSinceReferenceDate]*1000;
            }
            break;
            
        case kPARAGON_SIMULATOR_STATE_TIME_REGULATE:
            if (elapsed - _timeRegulateLastUpdate > _timeRegulateFrequency)
            {
                [self simulateRegulateCookingTick];
                _timeRegulateLastUpdate = [NSDate timeIntervalSinceReferenceDate]*1000;
            }
            break;
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(20)), dispatch_get_main_queue(), ^{
        [self paragonSimulatorTick];
    });
}

- (void)simulateHeatingTick
{
    FSTParagonCookingStage* stage = (FSTParagonCookingStage*)self.currentCookingMethod.session.paragonCookingStages[0];
    _actualTemperatureSimulation = _actualTemperatureSimulation + _heatingIncrement;
    stage.actualTemperature = [NSNumber numberWithInt:_actualTemperatureSimulation];
    [[NSNotificationCenter defaultCenter] postNotificationName:FSTActualTemperatureChangedNotification object:self];
}

- (void)simulatePowerOn
{
    [[NSNotificationCenter defaultCenter] postNotificationName:FSTCookModeChangedNotification object:self];

}

- (void)simulateRegulateCookingTick
{
    FSTParagonCookingStage* stage = (FSTParagonCookingStage*)self.currentCookingMethod.session.paragonCookingStages[0];
    _actualTemperatureSimulation = [stage.targetTemperature floatValue] + randomFloat(-2, 2);
    stage.actualTemperature = [NSNumber numberWithInt:_actualTemperatureSimulation];
    _elapsedTime = _elapsedTime + (1/60.0f);
    stage.cookTimeElapsed = [NSNumber numberWithDouble:_elapsedTime];
    [[NSNotificationCenter defaultCenter] postNotificationName:FSTActualTemperatureChangedNotification object:self];
    [[NSNotificationCenter defaultCenter] postNotificationName:FSTElapsedTimeChangedNotification object:self];

}

float randomFloat(float Min, float Max){
    return ((arc4random()%RAND_MAX)/(RAND_MAX*1.0))*(Max-Min)+Min;
}

#endif

@end
