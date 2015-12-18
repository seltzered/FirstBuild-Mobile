//
//  FSTPorkSpareRibsSousVideRecipe.m
//  FirstBuild
//
//  Created by Myles Caley on 12/18/15.
//  Copyright © 2015 FirstBuild. All rights reserved.
//

#import "FSTPorkSpareRibsSousVideRecipe.h"

@implementation FSTPorkSpareRibsSousVideRecipe
- (id) init
{
    self = [super init];
    if (self)
    {
        self.name = @"Spare Ribs";
        FSTParagonCookingStage* stage = [self addStage];
        stage.cookTimeMinimum = @720;
        stage.cookTimeMaximum = @1440;
        stage.targetTemperature = @165;
        stage.maxPowerLevel = @10;
        stage.automaticTransition = @2;
    }
    return self;
    
}
@end
