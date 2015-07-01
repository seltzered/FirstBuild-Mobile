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

@interface FSTParagon : FSTBleProduct 

//paragon cook mode
typedef enum {
    kPARAGON_OFF = 0,
    kPARAGON_SOUS_VIDE_ENABLED,
    kPARAGON_PREHEATING,
    kPARAGON_HEATING
} ParagonCookMode;

extern NSString * const FSTActualTemperatureChangedNotification;
extern NSString * const FSTCookModeChangedNotification;
extern NSString * const FSTElapsedTimeChangedNotification;

@property (nonatomic, strong) NSString* serialNumber;
@property (nonatomic, strong) NSString* modelNumber;
@property (nonatomic, strong) FSTCookingMethod* currentCookingMethod;
@property (atomic) ParagonCookMode currentCookMode;

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
