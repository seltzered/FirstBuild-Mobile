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

typedef enum {
    
    //off
    FSTParagonCookingStateOff = 0,
    
    //precision cooking
    FSTParagonCookingStatePrecisionCookingPreheating = 1,
    FSTParagonCookingStatePrecisionCookingPreheatingReached = 2,
    FSTParagonCookingStatePrecisionCookingReachingMinTime = 3,
    FSTParagonCookingStatePrecisionCookingReachingMaxTime = 4,
    FSTParagonCookingStatePrecisionCookingPastMaxTime = 5,
    
    //direct cooking
    FSTParagonCookingDirectCooking,
    FSTParagonCookingDirectCookingWithTime
} ParagonCookMode;

extern NSString * const FSTActualTemperatureChangedNotification;
extern NSString * const FSTBurnerModeChangedNotification;
extern NSString * const FSTCookingModeChangedNotification;

extern NSString * const FSTElapsedTimeChangedNotification;
extern NSString * const FSTBatteryLevelChangedNotification;
extern NSString * const FSTCookTimeSetNotification ;
extern NSString * const FSTTargetTemperatureChangedNotification ;
extern NSString * const FSTElapsedTimeSetNotification;
extern NSString * const FSTTargetTemperatureSetNotification;

@property (nonatomic, strong) NSString* serialNumber;
@property (nonatomic, strong) NSString* modelNumber;
@property (nonatomic, strong) FSTCookingMethod* currentCookingMethod;
@property (nonatomic, strong) FSTCookingMethod* toBeCookingMethod;

@property (atomic) ParagonBurnerMode burnerMode;
@property (atomic) ParagonCookMode cookMode;
@property (nonatomic, strong) NSArray* burners;
@property (nonatomic, strong) NSNumber* batteryLevel;
@property (nonatomic, strong) NSNumber* loadingProgress; // a percentage that tells how many characteristics loaded

- (void)startHeating;
- (void)setCookingTimes;

@end
