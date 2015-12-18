//
//  FSTPorkBackRibsSousVideRecipe.m
//  FirstBuild
//
//  Created by Myles Caley on 12/18/15.
//  Copyright © 2015 FirstBuild. All rights reserved.
//

#import "FSTPorkBackRibsSousVideRecipe.h"

@implementation FSTPorkBackRibsSousVideRecipe
- (id) init
{
    self = [super init];
    if (self)
    {
        self.name = @"Back Ribs";
        FSTParagonCookingStage* stage = [self addStage];
        stage.cookTimeMinimum = @480;
        stage.cookTimeMaximum = @720;
        stage.targetTemperature = @165;
        stage.maxPowerLevel = @10;
        stage.automaticTransition = @2;
    }
    return self;
    
}
@end
