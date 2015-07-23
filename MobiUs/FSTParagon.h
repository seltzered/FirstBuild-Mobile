//
//  FSTParagon.h
//  FirstBuild
//
//  Created by Myles Caley on 3/12/15.
//  Copyright (c) 2015 FirstBuild. All rights reserved.
//
#import <CoreBluetooth/CoreBluetooth.h>

#import "FSTBleProduct.h"
#import "FSTParagonCookingSession.h"
#import "FSTCookingMethod.h"
#import "FSTBurner.h"

@interface FSTParagon : FSTBleProduct 

extern NSString * const FSTActualTemperatureChangedNotification;
extern NSString * const FSTCookModeChangedNotification;
extern NSString * const FSTElapsedTimeChangedNotification;
extern NSString * const FSTBatteryLevelChangedNotification;
extern NSString * const FSTCookTimeSetNotification ;


@property (nonatomic, strong) NSString* serialNumber;
@property (nonatomic, strong) NSString* modelNumber;
@property (nonatomic, strong) FSTCookingMethod* currentCookingMethod;
@property (atomic) ParagonCookMode currentCookMode;
@property (nonatomic, strong) NSArray* burners;
@property (nonatomic, strong) NSNumber* batteryLevel;

-(void)startHeatingWithTemperature: (NSNumber*)targetTemperature;
-(void)setCookingTime: (NSNumber*)cookingTime;

#ifdef SIMULATE_PARAGON
- (void)startSimulateHeating;
- (void)startSimulatePowerOn;
- (void)setSimulatorHeatingUpdateInterval: (NSTimeInterval)interval;
- (void)setSimulatorHeatingTemperatureIncrement: (uint8_t)increment;
- (void)startSimulatingTimeWithTemperatureRegulating;
#endif

@end
