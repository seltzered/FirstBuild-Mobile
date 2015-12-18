//
//  FSTVegetableArtichokeSousVideRecipe.m
//  FirstBuild
//
//  Created by Myles Caley on 12/15/15.
//  Copyright © 2015 FirstBuild. All rights reserved.
//

#import "FSTVegetableArtichokeSousVideRecipe.h"

@implementation FSTVegetableArtichokeSousVideRecipe

- (id) init
{
    self = [super init];
    if (self)
    {
        self.name = @"Artichokes";
        FSTParagonCookingStage* stage = [self addStage];
        stage.cookTimeMinimum = @45;
        stage.cookTimeMaximum = @75;
        stage.targetTemperature = @185;
        stage.maxPowerLevel = @10;
        stage.automaticTransition = @2;
    }
    return self;
    
}

@end
