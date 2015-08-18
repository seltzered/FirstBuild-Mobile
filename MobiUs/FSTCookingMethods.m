//
//  FSTCookingMethods.m
//  FirstBuild
//
//  Created by Myles Caley on 5/13/15.
//  Copyright (c) 2015 FirstBuild. All rights reserved.
//

#import "FSTCookingMethods.h"

#import "FSTSousVideCookingMethod.h"
#import "FSTCandyCookingMethod.h"


@implementation FSTCookingMethods

- (instancetype)init
{
    self = [super init];
    if (self) {
              self.cookingMethods = [[NSArray alloc] initWithObjects:
                                     [FSTSousVideCookingMethod new],
                                     [FSTCandyCookingMethod new],
                                     nil];
    }
    return self;
}

@end
