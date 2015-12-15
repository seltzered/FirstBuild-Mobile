//
//  FSTVegetableBeetsSousVideRecipe.m
//  FirstBuild
//
//  Created by Myles Caley on 12/15/15.
//  Copyright © 2015 FirstBuild. All rights reserved.
//

#import "FSTVegetableBeetsSousVideRecipe.h"

@implementation FSTVegetableBeetsSousVideRecipe
- (id) init
{
    self = [super init];
    if (self)
    {
        FSTParagonCookingStage* stage = [self addStage];
        stage.cookTimeMinimum = @30;
        stage.cookTimeMaximum = @60;
        stage.targetTemperature = @185;
        stage.maxPowerLevel = @10;
        stage.automaticTransition = @0;
    }
    return self;
    
}
@end
