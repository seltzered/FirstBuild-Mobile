//
//  FSTRecipes.m
//  FirstBuild
//
//  Created by Myles Caley on 5/13/15.
//  Copyright (c) 2015 FirstBuild. All rights reserved.
//

#import "FSTRecipes.h"

#import "FSTSousVideRecipe.h"
#import "FSTCandyRecipe.h"


@implementation FSTRecipes

- (instancetype)init
{
    self = [super init];
    if (self) {
              self.recipes = [[NSArray alloc] initWithObjects:
                                     [FSTSousVideRecipe new],
                                     [FSTCandyRecipe new],
                                     nil];
    }
    return self;
}

@end
