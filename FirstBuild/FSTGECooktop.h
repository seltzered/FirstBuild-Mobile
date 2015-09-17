//
//  FSTGECooktop.h
//  FirstBuild
//
//  Created by Myles Caley on 9/17/15.
//  Copyright (c) 2015 FirstBuild. All rights reserved.
//

#import "FSTBleProduct.h"

#import "FSTBleProduct.h"
#import "FSTParagonCookingSession.h"
#import "FSTRecipe.h"
#import "FSTBurner.h"

@interface FSTGECooktop : FSTBleProduct

typedef enum {
    
    //off
    FSTGECooktopCookingStateOff = 0,
    
    //precision cooking
    FSTGECooktopCookingStatePrecisionCookingReachingTemperature = 1,
    FSTGECooktopCookingStatePrecisionCookingTemperatureReached = 2,
    FSTGECooktopCookingStatePrecisionCookingReachingMinTime = 3,
    FSTGECooktopCookingStatePrecisionCookingReachingMaxTime = 4,
    FSTGECooktopCookingStatePrecisionCookingPastMaxTime = 5,
    FSTGECooktopCookingStatePrecisionCookingWithoutTime = 6,
    
    //direct cooking
    FSTGECooktopCookingDirectCooking,
    FSTGECooktopCookingDirectCookingWithTime,
    
    //unknown
    FSTGECooktopCookingStateUnknown
    
} GECooktopParagonCookMode;

extern NSString * const FSTActualTemperatureChangedNotification;
extern NSString * const FSTBurnerModeChangedNotification;
extern NSString * const FSTCookingModeChangedNotification;

extern NSString * const FSTElapsedTimeChangedNotification;
extern NSString * const FSTCookTimeSetNotification ;
extern NSString * const FSTTargetTemperatureChangedNotification ;
extern NSString * const FSTElapsedTimeSetNotification;
extern NSString * const FSTTargetTemperatureSetNotification;

@property (nonatomic, strong) NSString* serialNumber;
@property (nonatomic, strong) NSString* modelNumber;

@property (nonatomic, strong) NSNumber* recipeId;
@property (atomic) ParagonBurnerMode burnerMode;
@property (atomic) GECooktopParagonCookMode cookMode;
@property (nonatomic, strong) NSArray* burners;


-(void)startHeatingWithStage: (FSTParagonCookingStage*)stage;
-(void)setCookingTimesWithStage: (FSTParagonCookingStage*)stage;
//-(void)moveNextStage;

@property (nonatomic, retain) FSTParagonCookingSession* session;
@end
