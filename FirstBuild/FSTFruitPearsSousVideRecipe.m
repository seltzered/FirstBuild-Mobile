//
//  FSTFruitPearsSousVideRecipe.m
//  FirstBuild
//
//  Created by Myles Caley on 12/18/15.
//  Copyright © 2015 FirstBuild. All rights reserved.
//

#import "FSTFruitPearsSousVideRecipe.h"

@implementation FSTFruitPearsSousVideRecipe
- (id) init
{
    self = [super init];
    if (self)
    {
        self.name = @"Pears";
        FSTParagonCookingStage* stage = [self addStage];
        stage.cookTimeMinimum = @20;
        stage.cookTimeMaximum = @40;
        stage.targetTemperature = @185;
        stage.maxPowerLevel = @10;
        stage.automaticTransition = @2;
    }
    return self;
    
}
@end
