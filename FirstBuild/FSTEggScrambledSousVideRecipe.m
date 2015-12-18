//
//  FSTEggScrambledSousVideRecipe.m
//  FirstBuild
//
//  Created by Myles Caley on 12/17/15.
//  Copyright © 2015 FirstBuild. All rights reserved.
//

#import "FSTEggScrambledSousVideRecipe.h"

@implementation FSTEggScrambledSousVideRecipe

- (id) init
{
    self = [super init];
    if (self)
    {
        self.name = @"Scrambled";
        FSTParagonCookingStage* stage = [self addStage];
        stage.cookTimeMinimum = @20;
        stage.cookTimeMaximum = @60;
        stage.targetTemperature = @167;
        stage.maxPowerLevel = @10;
        stage.automaticTransition = @2;
    }
    return self;
    
}

@end
