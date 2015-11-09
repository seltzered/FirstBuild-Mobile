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
#import "FSTRecipe.h"
#import "FSTBurner.h"
#import "FSTPrecisionCooking.h"

@protocol FSTParagonDelegate <NSObject>

@optional - (void) actualTemperatureChanged: (NSNumber*) temperature;
@optional - (void) cookModeChanged: (ParagonCookMode) cookMode;
@optional - (void) cookConfigurationChanged;
@optional - (void) cookConfigurationSet;
@optional - (void) holdTimerSet;
@optional - (void) currentStageIndexChanged: (NSNumber*) stageIndex;
@optional - (void) currentPowerLevelChanged: (NSNumber*) powerLevel;

@end

@interface FSTParagon : FSTBleProduct

// this defines the cookstates from the raw paragon cook state on the paragon
// the overarching cook mode is defined in FSTPrecisionCooking.h in the
// FSTParagonCookMode
typedef enum {
    FSTParagonCookStateOff = 0,
    FSTParagonCookStateReachingTemperature = 1,
    FSTParagonCookStateReady = 2,
    FSTParagonCookStateCooking = 3,
    FSTParagonCookStateDone = 4,
} ParagonCookState;

@property (nonatomic, weak) id<FSTParagonDelegate> delegate;

extern NSString * const FSTServiceParagon ;

@property (nonatomic, strong) NSNumber* recipeId;
@property (atomic) ParagonBurnerMode burnerMode;
@property (atomic) ParagonCookMode cookMode;
@property (nonatomic) ParagonCookState cookState;
@property (nonatomic, strong) NSNumber* remainingHoldTime;

-(void)startTimerForCurrentStage;
-(BOOL)sendRecipeToCooktop: (FSTRecipe*)recipe;

@property (nonatomic, retain) FSTParagonCookingSession* session;

@end
