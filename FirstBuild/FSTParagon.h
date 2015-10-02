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

@interface FSTParagon : FSTBleProduct 

extern NSString * const FSTServiceParagon ;

extern NSString * const FSTActualTemperatureChangedNotification;
extern NSString * const FSTBurnerModeChangedNotification;
extern NSString * const FSTCookingModeChangedNotification;

extern NSString * const FSTElapsedTimeChangedNotification;
extern NSString * const FSTCookTimeSetNotification ;
extern NSString * const FSTTargetTemperatureChangedNotification ;
extern NSString * const FSTElapsedTimeSetNotification;
extern NSString * const FSTCookConfigurationSetNotification;
extern NSString * const FSTHoldTimerSetNotification;
extern NSString * const FSTCookConfigurationChangedNotification;


@property (nonatomic, strong) NSString* serialNumber;
@property (nonatomic, strong) NSString* modelNumber;

@property (nonatomic, strong) NSNumber* recipeId;
@property (atomic) ParagonBurnerMode burnerMode;
@property (atomic) ParagonCookMode cookMode;

@property (nonatomic, strong) NSNumber* remainingHoldTime;

-(void)startTimerForCurrentStage;


-(void)sendRecipeToCooktop: (FSTRecipe*)recipe;

//-(void)moveNextStage;

@property (nonatomic, retain) FSTParagonCookingSession* session;

@end
