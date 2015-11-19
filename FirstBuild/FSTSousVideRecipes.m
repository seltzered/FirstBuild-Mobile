//
//  FSTSousVideRecipes.m
//  FirstBuild
//
//  Created by Myles Caley on 5/13/15.
//  Copyright (c) 2015 FirstBuild. All rights reserved.
//

#import "FSTSousVideRecipes.h"
#import "FSTBeefSousVideRecipe.h"

@implementation FSTSousVideRecipes

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.recipes = [[NSArray alloc] initWithObjects:
                        [FSTBeefSousVideRecipe new],
                        nil];
    }
    return self;
}

@end
