//
//  FSTBeefSousVideRecipe.m
//  FirstBuild
//
//  Created by Myles Caley on 5/13/15.
//  Copyright (c) 2015 FirstBuild. All rights reserved.
//

#import "FSTBeefSousVideRecipe.h"

@implementation FSTBeefSousVideRecipe

- (id) init
{
    self = [super init];
    if (self)
    {
        self.name = @"Beef";
        self.recipeType = [NSNumber numberWithInt: FSTRecipeTypeFirstBuildSousVide];
    }
    return self;
    
}

@end
