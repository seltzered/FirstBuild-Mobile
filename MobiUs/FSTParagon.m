//
//  FSTParagon.m
//  FirstBuild
//
//  Created by Myles Caley on 3/12/15.
//  Copyright (c) 2015 FirstBuild. All rights reserved.
//

#import "FSTParagon.h"

@implementation FSTParagon

NSString * const FSTActualTemperatureChangedNotification = @"FSTActualTemperatureChangedNotification";
NSString * const FSTCookModeChangedNotification = @"FSTCookModeChangedNotification";


#ifdef SIMULATE_PARAGON

//heating state
double _heatingUpdateFrequency = 200;
NSTimeInterval _heatingLastUpdate = 0;
uint8_t _heatingIncrement = 0;
uint16_t _actualTemperatureSimulation = 72;

//power on state
double _waitingForPowerOnNotificationFrequency = 3000;
NSTimeInterval _waitingForPowerOnNotificationLastUpdate = 0;

//state machine
typedef enum {
    kPARAGON_SIMULATOR_STATE_OFF = 0,
    kPARAGON_SIMULATOR_POWER_ON,
    kPARAGON_SIMULATOR_STATE_HEATING,
    kPARAGON_SIMULATOR_STATE_REGULATING
} PARAGON_SIMULATOR_STATE;

uint8_t _currentSimulationState = kPARAGON_SIMULATOR_STATE_OFF;

#endif

- (id)init
{
    self = [super init];
#ifdef SIMULATE_PARAGON
    [self startParagonSimulator];
#endif
    return self;
    
}

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
            
        case kPARAGON_SIMULATOR_STATE_REGULATING:
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
    [self setSimulatorHeatingTemperatureIncrement:5];
    [self setSimulatorHeatingUpdateInterval:200];
    _currentSimulationState = kPARAGON_SIMULATOR_STATE_HEATING;
}

#endif

@end
