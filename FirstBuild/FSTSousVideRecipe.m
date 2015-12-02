//
//  FSTSousVideCookingMethod.m
//  FirstBuild
//
//  Created by Myles Caley on 5/13/15.
//  Copyright (c) 2015 FirstBuild. All rights reserved.
//

#import "FSTSousVideRecipe.h"

@implementation FSTSousVideRecipe

- (id) init
{
    self = [super init];
    if (self)
    {
        self.name = @"Sous Vide";
        self.recipeType = [NSNumber numberWithInt: FSTRecipeTypeFirstBuildSousVide];

    }
    return self;
    
}
@end
