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
extern NSString * const FSTTargetTemperatureChangedNotification ;
extern NSString * const FSTElapsedTimeSetNotification;
extern NSString * const FSTTargetTemperatureSetNotification;



@property (nonatomic, strong) NSString* serialNumber;
@property (nonatomic, strong) NSString* modelNumber;
@property (nonatomic, strong) FSTCookingMethod* currentCookingMethod;
@property (nonatomic, strong) FSTCookingMethod* toBeCookingMethod;

@property (atomic) ParagonCookMode currentCookMode;
@property (nonatomic, strong) NSArray* burners;
@property (nonatomic, strong) NSNumber* batteryLevel;
@property (nonatomic, strong) NSNumber* loadingProgress; // a percentage that tells how many characteristics loaded

-(void)startHeatingWithTemperature: (NSNumber*)targetTemperature;
- (void)setCookingTimesStartingWithMinimumTime: (NSNumber*)cookingMinimumTime goingToMaximumTime: (NSNumber*)cookingTimeMaximum;

@end
