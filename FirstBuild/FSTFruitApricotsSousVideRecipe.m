//
//  FSTFruitApricotsSousVideRecipe.m
//  FirstBuild
//
//  Created by Myles Caley on 12/18/15.
//  Copyright © 2015 FirstBuild. All rights reserved.
//

#import "FSTFruitApricotsSousVideRecipe.h"

@implementation FSTFruitApricotsSousVideRecipe
- (id) init
{
    self = [super init];
    if (self)
    {
        self.name = @"Apricots";
        FSTParagonCookingStage* stage = [self addStage];
        stage.cookTimeMinimum = @20;
        stage.cookTimeMaximum = @60;
        stage.targetTemperature = @185;
        stage.maxPowerLevel = @10;
        stage.automaticTransition = @0;
    }
    return self;
    
}
@end
