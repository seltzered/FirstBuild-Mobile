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
        self.currentProbeTemperature = nil;
        self.currentStage = nil;
        self.currentPowerLevel = nil;
        self.currentStageIndex = 0;
        self.burnerMode = 0;
        self.cookMode = FSTCookingStateUnknown;
        self.cookState = FSTParagonCookStateOff;
        self.remainingHoldTime = 0;
    }
    return self;
}

@end
