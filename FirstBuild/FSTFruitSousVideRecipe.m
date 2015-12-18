//
//  FSTFruitSousVideRecipe.m
//  FirstBuild
//
//  Created by Myles Caley on 12/18/15.
//  Copyright © 2015 FirstBuild. All rights reserved.
//

#import "FSTFruitSousVideRecipe.h"

@implementation FSTFruitSousVideRecipe
- (id) init
{
    self = [super init];
    if (self)
    {
        self.name = @"Fruits";
        self.recipeType = [NSNumber numberWithInt: FSTRecipeTypeFirstBuildSousVide];
    }
    return self;
    
}
@end
