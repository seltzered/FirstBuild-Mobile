//
//  FSTCandyCookingMethods.m
//  FirstBuild
//
//  Created by Myles Caley on 8/18/15.
//  Copyright (c) 2015 FirstBuild. All rights reserved.
//

#import "FSTCandyCookingMethods.h"
#import "FSTCaramelBrittleCandyCooking.h"

@implementation FSTCandyCookingMethods

- (instancetype)init
{
    self = [super init];
    if (self) {
        FSTCandyCookingMethod *cookingMethod = [[FSTCaramelBrittleCandyCooking alloc] init];
        self.cookingMethods = [[NSArray alloc] initWithObjects:cookingMethod, nil];
    }
    return self;
}

@end
