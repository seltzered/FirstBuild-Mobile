//
//  FSTBeefSousVideCookingMethod.m
//  FirstBuild
//
//  Created by Myles Caley on 5/13/15.
//  Copyright (c) 2015 FirstBuild. All rights reserved.
//

#import "FSTBeefSousVideCookingMethod.h"

@implementation FSTBeefSousVideCookingMethod

- (id) init
{
    self = [super init];
    if (self)
    {
        self.name = @"Beef";
        self.donenesses = @[ @"MR", @"M", @"MW", @"W"];
        self.thicknesses = @[
                            @(0.2),
                            @(0.4),
                            @(0.6),
                            @(0.8),
                            @(1.2),
                            @(1.4),
                            @(1.6),
                            @(2.0),
                            @(2.15),
                            @(2.35),
                            @(2.5),
                            @(2.75)
                            ];
    }
    return self;
    
}

@end
