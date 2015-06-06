//
//  FSTParagon.h
//  FirstBuild
//
//  Created by Myles Caley on 3/12/15.
//  Copyright (c) 2015 FirstBuild. All rights reserved.
//

#import "FSTProduct.h"
#import "FSTParagonCookingSession.h"
#import "FSTCookingMethod.h"

@interface FSTParagon : FSTProduct

extern NSString * const FSTActualTemperatureChangedNotification;
extern NSString * const FSTCookModeChangedNotification;
extern NSString * const FSTElapsedTimeChangedNotification;

@property (nonatomic, strong) NSString* serialNumber;
@property (nonatomic, strong) NSString* modelNumber;
@property (nonatomic, strong) FSTCookingMethod* currentCookingMethod;

#ifdef SIMULATE_PARAGON
//- (void)startSimulatePreheat;
//- (void)startSimulateCookModeChanged;
//- (void)startSimulateReadyToCook;
//- (void)simulateHeatingWithTemperatureIncrement: (uint8_t) increment;
- (void)startSimulateHeating;
- (void)startSimulatePowerOn;
- (void)setSimulatorHeatingUpdateInterval: (NSTimeInterval)interval;
- (void)setSimulatorHeatingTemperatureIncrement: (uint8_t)increment;
- (void)startSimulatingTimeWithTemperatureRegulating;


#endif

@end
