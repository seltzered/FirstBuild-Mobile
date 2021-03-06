//
//  FSTParagonCookingSession.h
//  FirstBuild
//
//  Created by Myles Caley on 6/2/15.
//  Copyright (c) 2015 FirstBuild. All rights reserved.
//

#import "FSTRecipe.h"
#import "FSTPrecisionCooking.h"
#import "FSTBurner.h"

@interface FSTParagonCookingSession : NSObject

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

typedef enum {
    FSTParagonUserSelectedCookModeScreenOff = 0,
    FSTParagonUserSelectedCookModeDirect = 1,
    FSTParagonUserSelectedCookModeRapid = 2,
    FSTParagonUserSelectedCookModeGentle = 3,
    FSTParagonUserSelectedCookModeRemote = 4,
    FSTParagonUserSelectedCookModeUnknown = 5
} ParagonUserSelectedCookMode;

@property (nonatomic, strong) FSTRecipe* activeRecipe;
@property (nonatomic, strong) NSNumber* currentProbeTemperature;
@property (nonatomic, weak) FSTParagonCookingStage* currentStage;
@property (nonatomic) uint8_t currentStageIndex;
@property (nonatomic, strong) NSNumber* currentPowerLevel;
@property (nonatomic) ParagonBurnerMode burnerMode;
@property (nonatomic) ParagonCookMode cookMode;
@property (nonatomic) ParagonCookState cookState;
@property (nonatomic, strong) NSNumber* remainingHoldTime;
@property ParagonUserSelectedCookMode userSelectedCookMode;


@end
