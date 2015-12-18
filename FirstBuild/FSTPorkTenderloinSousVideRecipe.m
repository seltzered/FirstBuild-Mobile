//
//  FSTPorkTenderloinSousVideRecipe.m
//  FirstBuild
//
//  Created by Myles Caley on 12/18/15.
//  Copyright © 2015 FirstBuild. All rights reserved.
//

#import "FSTPorkTenderloinSousVideRecipe.h"

@implementation FSTPorkTenderloinSousVideRecipe
- (id) init
{
    self = [super init];
    if (self)
    {
        self.name = @"Tenderloin";
        FSTParagonCookingStage* stage = [self addStage];
        stage.cookTimeMinimum = @120;
        stage.cookTimeMaximum = @240;
        stage.targetTemperature = @140;
        stage.maxPowerLevel = @10;
        stage.automaticTransition = @2;
    }
    return self;
    
}
@end
