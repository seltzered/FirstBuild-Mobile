//
//  FSTPoultryTurkeyLegsSousVideRecipe.m
//  FirstBuild
//
//  Created by Myles Caley on 12/18/15.
//  Copyright © 2015 FirstBuild. All rights reserved.
//

#import "FSTPoultryTurkeyLegsSousVideRecipe.h"

@implementation FSTPoultryTurkeyLegsSousVideRecipe
- (id) init
{
    self = [super init];
    if (self)
    {
        self.name = @"Leg";
        FSTParagonCookingStage* stage = [self addStage];
        stage.cookTimeMinimum = @480;
        stage.cookTimeMaximum = @600;
        stage.targetTemperature = @175;
        stage.maxPowerLevel = @10;
        stage.automaticTransition = @1;
    }
    return self;
    
}
@end
