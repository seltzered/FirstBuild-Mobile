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

@end

@interface FSTParagon : FSTBleProduct 

@property (nonatomic, weak) id<FSTParagonDelegate> delegate;

extern NSString * const FSTServiceParagon ;


@property (nonatomic, strong) NSNumber* recipeId;
@property (atomic) ParagonBurnerMode burnerMode;
@property (atomic) ParagonCookMode cookMode;
@property (nonatomic, strong) NSNumber* remainingHoldTime;

-(void)startTimerForCurrentStage;
-(void)sendRecipeToCooktop: (FSTRecipe*)recipe;

@property (nonatomic, retain) FSTParagonCookingSession* session;

@end
