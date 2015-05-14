//
//  FSTSousVideCookingMethods.m
//  FirstBuild
//
//  Created by Myles Caley on 5/13/15.
//  Copyright (c) 2015 FirstBuild. All rights reserved.
//

#import "FSTSousVideCookingMethods.h"
#import "FSTBeefSousVideCookingMethod.h"

@implementation FSTSousVideCookingMethods

- (instancetype)init
{
    self = [super init];
    if (self) {
        FSTSousVideCookingMethod *cookingMethod = [[FSTBeefSousVideCookingMethod alloc] init];
        self.cookingMethods = [[NSArray alloc] initWithObjects:cookingMethod, nil];
    }
    return self;
}

@end
