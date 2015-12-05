//
//  CookingStateModel.m
//  FirstBuild
//
//  Created by Myles Caley on 12/5/15.
//  Copyright © 2015 FirstBuild. All rights reserved.
//

#import "CookingStateModel.h"

@implementation CookingStateModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.remainingHoldTime = 0;
        self.targetMaxTime = 0;
        self.targetMinTime = 0;
        self.targetTemp = 0;
        self.directions = nil;
        self.stagePrep = nil;
        self.currentTemp = 0;
        self.burnerLevel = 0;
    }
    return self;
}

@end