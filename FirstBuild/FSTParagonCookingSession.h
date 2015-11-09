//
//  FSTParagonCookingSession.h
//  FirstBuild
//
//  Created by Myles Caley on 6/2/15.
//  Copyright (c) 2015 FirstBuild. All rights reserved.
//

#import "FSTRecipe.h"

@interface FSTParagonCookingSession : NSObject

@property (nonatomic, strong) FSTRecipe* activeRecipe;
@property (nonatomic, strong) FSTRecipe* toBeRecipe;
@property (nonatomic, strong) NSNumber* currentProbeTemperature;
@property (nonatomic, strong) NSNumber* currentStageCookTimeElapsed;
@property (nonatomic, weak) FSTParagonCookingStage* currentStage;
@property (nonatomic) uint8_t currentStageIndex;
@property (nonatomic, strong) NSNumber* currentPowerLevel;

@end
