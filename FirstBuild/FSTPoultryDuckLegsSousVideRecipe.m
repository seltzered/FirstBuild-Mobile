//
//  FSTPoultryDuckLegsSousVideRecipe.m
//  FirstBuild
//
//  Created by Myles Caley on 12/17/15.
//  Copyright © 2015 FirstBuild. All rights reserved.
//

#import "FSTPoultryDuckLegsSousVideRecipe.h"

@implementation FSTPoultryDuckLegsSousVideRecipe
- (id) init
{
    self = [super init];
    if (self)
    {
        self.name = @"Leg";
        FSTParagonCookingStage* stage = [self addStage];
        stage.cookTimeMinimum = @480;
        stage.cookTimeMaximum = @720;
        stage.targetTemperature = @175;
        stage.maxPowerLevel = @10;
        stage.automaticTransition = @2;
    }
    return self;
    
}

@end
