//
//  FSTParagonCookingStage.m
//  FirstBuild
//
//  Created by Myles Caley on 6/2/15.
//  Copyright (c) 2015 FirstBuild. All rights reserved.
//

#import "FSTParagonCookingStage.h"

@implementation FSTParagonCookingStage

- (instancetype)init
{
    self = [super init];
    if (self) {
        _targetTemperature = [NSNumber numberWithInt:0];
        _actualTemperature = [NSNumber numberWithInt:0];
        _cookTimeMinimum = [NSNumber numberWithInt:0];
        _cookTimeMaximum = [NSNumber numberWithInt:0];
        _cookTimeElapsed = [NSNumber numberWithInt:0];
        _cookingLabel = @"";
    }
    return self;
}
@end
