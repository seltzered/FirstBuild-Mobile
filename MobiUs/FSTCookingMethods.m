//
//  FSTCookingMethods.m
//  FirstBuild
//
//  Created by Myles Caley on 5/13/15.
//  Copyright (c) 2015 FirstBuild. All rights reserved.
//

#import "FSTCookingMethods.h"

@implementation FSTCookingMethods

- (instancetype)init
{
    self = [super init];
    if (self) {
        FSTSousVideCookingMethod *cookingMethod = [[FSTSousVideCookingMethod alloc] init];
        self.cookingMethods = [[NSArray alloc] initWithObjects:cookingMethod, nil];
    }
    return self;
}

@end
