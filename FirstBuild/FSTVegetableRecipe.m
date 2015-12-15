//
//  FSTVegetableRecipe.m
//  FirstBuild
//
//  Created by Myles Caley on 12/15/15.
//  Copyright © 2015 FirstBuild. All rights reserved.
//

#import "FSTVegetableRecipe.h"

@implementation FSTVegetableRecipe


- (id) init
{
    self = [super init];
    if (self)
    {
        self.name = @"Vegetables";
        self.recipeType = [NSNumber numberWithInt: FSTRecipeTypeFirstBuildSousVide];
    }
    return self;
    
}

@end
