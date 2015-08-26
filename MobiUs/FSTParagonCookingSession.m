//
//  FSTParagonCookingSession.m
//  FirstBuild
//
//  Created by Myles Caley on 6/2/15.
//  Copyright (c) 2015 FirstBuild. All rights reserved.
//

#import "FSTParagonCookingSession.h"

@implementation FSTParagonCookingSession

-(instancetype)init
{
    self = [super init];
    if (self) {
        self.activeRecipe = nil;
        self.toBeRecipe = nil;
        self.currentStage = 0;
        self.currentProbeTemperature = 0;
        self.currentStageCookTimeElapsed = 0;
        self.currentStage = nil;
    }
    return self;
}

@end
