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
@optional - (void) cookConfigurationSet:(NSError *)error;
@optional - (void) userInformationSet:(NSError *)error;
@optional - (void) nextStageSet:(NSError *)error;
@optional - (void) holdTimerSet;
@optional - (void) currentStageIndexChanged: (NSNumber*) stageIndex;
@optional - (void) currentPowerLevelChanged: (NSNumber*) powerLevel;
@optional - (void) remainingHoldTimeChanged: (NSNumber*) holdTime;
@optional - (void) userSelectedCookModeChanged : (ParagonUserSelectedCookMode) userSelectedCookMode;
@end

@interface FSTParagon : FSTBleProduct

@property (nonatomic, weak) id<FSTParagonDelegate> delegate;

extern NSString * const FSTServiceParagon ;

-(void)startTimerForCurrentStage;
-(BOOL)sendRecipeToCooktop: (FSTRecipe*)recipe;
-(void)moveNextStage;

@property (nonatomic, retain) FSTParagonCookingSession* session;
@property (nonatomic) BOOL isProbeConnected;

@end
