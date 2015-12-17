//
//  FSTPoultrySousVideRecipe.m
//  FirstBuild
//
//  Created by Myles Caley on 12/17/15.
//  Copyright © 2015 FirstBuild. All rights reserved.
//

#import "FSTPoultrySousVideRecipe.h"

@implementation FSTPoultrySousVideRecipe
- (id) init
{
    self = [super init];
    if (self)
    {
        self.name = @"Poultry";
        self.recipeType = [NSNumber numberWithInt: FSTRecipeTypeFirstBuildSousVide];
    }
    return self;
    
}
@end
