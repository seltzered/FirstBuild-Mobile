//
//  FSTFruitBerriesSousVideRecipe.m
//  FirstBuild
//
//  Created by Myles Caley on 12/18/15.
//  Copyright © 2015 FirstBuild. All rights reserved.
//

#import "FSTFruitBerriesSousVideRecipe.h"

@implementation FSTFruitBerriesSousVideRecipe
- (id) init
{
    self = [super init];
    if (self)
    {
        self.name = @"Berries";
        FSTParagonCookingStage* stage = [self addStage];
        stage.cookTimeMinimum = @25;
        stage.cookTimeMaximum = @60;
        stage.targetTemperature = @190;
        stage.maxPowerLevel = @10;
        stage.automaticTransition = @0;
    }
    return self;
    
}
@end
