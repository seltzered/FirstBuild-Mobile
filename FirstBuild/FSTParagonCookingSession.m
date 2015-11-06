//
//  FSTParagonCookingSession.m
//  FirstBuild
//
//  Created by Myles Caley on 6/2/15.
//  Copyright (c) 2015 FirstBuild. All rights reserved.
//

#import "FSTParagonCookingSession.h"

@implementation FSTParagonCookingSession
{
    uint8_t _currentStageIndex;
}

-(instancetype)init
{
    self = [super init];
    if (self) {
        self.activeRecipe = nil;
        self.toBeRecipe = nil;
        self.currentProbeTemperature = nil;
        self.currentStageCookTimeElapsed = nil;
        self.currentStage = nil;
        self.currentPowerLevel = nil;
        _currentStageIndex = 0;
    }
    return self;
}

@end
