//
//  FSTPoultryDuckSousVideRecipe.m
//  FirstBuild
//
//  Created by Myles Caley on 12/17/15.
//  Copyright © 2015 FirstBuild. All rights reserved.
//

#import "FSTPoultryDuckSousVideRecipe.h"

@implementation FSTPoultryDuckSousVideRecipe
- (id) init
{
    self = [super init];
    if (self)
    {
        self.name = @"Duck";
        self.recipeType = [NSNumber numberWithInt: FSTRecipeTypeFirstBuildSousVide];
    }
    return self;
    
}
@end
