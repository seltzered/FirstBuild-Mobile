//
//  FSTVegetableCornSousVideRecipe.m
//  FirstBuild
//
//  Created by Myles Caley on 12/15/15.
//  Copyright © 2015 FirstBuild. All rights reserved.
//

#import "FSTVegetableCornSousVideRecipe.h"

@implementation FSTVegetableCornSousVideRecipe
- (id) init
{
    self = [super init];
    if (self)
    {
        FSTParagonCookingStage* stage = [self addStage];
        stage.cookTimeMinimum = @20;
        stage.cookTimeMaximum = @40;
        stage.targetTemperature = @185;
        stage.maxPowerLevel = @10;
        stage.automaticTransition = @0;
    }
    return self;
    
}
@end
