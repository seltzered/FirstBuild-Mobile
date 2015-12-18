//
//  FSTFruitPapayaSousVideRecipe.m
//  FirstBuild
//
//  Created by Myles Caley on 12/18/15.
//  Copyright © 2015 FirstBuild. All rights reserved.
//

#import "FSTFruitPapayaSousVideRecipe.h"

@implementation FSTFruitPapayaSousVideRecipe
- (id) init
{
    self = [super init];
    if (self)
    {
        self.name = @"Papaya";
        FSTParagonCookingStage* stage = [self addStage];
        stage.cookTimeMinimum = @20;
        stage.cookTimeMaximum = @60;
        stage.targetTemperature = @185;
        stage.maxPowerLevel = @10;
        stage.automaticTransition = @2;
    }
    return self;
    
}
@end
