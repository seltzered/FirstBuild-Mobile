//
//  FSTFruitApplesSousVideRecipe.m
//  FirstBuild
//
//  Created by Myles Caley on 12/18/15.
//  Copyright © 2015 FirstBuild. All rights reserved.
//

#import "FSTFruitApplesSousVideRecipe.h"

@implementation FSTFruitApplesSousVideRecipe
- (id) init
{
    self = [super init];
    if (self)
    {
        self.name = @"Apples";
        FSTParagonCookingStage* stage = [self addStage];
        stage.cookTimeMinimum = @25;
        stage.cookTimeMaximum = @60;
        stage.targetTemperature = @185;
        stage.maxPowerLevel = @10;
        stage.automaticTransition = @0;
    }
    return self;
    
}
@end
