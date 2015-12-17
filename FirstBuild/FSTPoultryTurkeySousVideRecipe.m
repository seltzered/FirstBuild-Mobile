//
//  FSTPoultryTurkeySousVideRecipe.m
//  FirstBuild
//
//  Created by Myles Caley on 12/17/15.
//  Copyright © 2015 FirstBuild. All rights reserved.
//

#import "FSTPoultryTurkeySousVideRecipe.h"

@implementation FSTPoultryTurkeySousVideRecipe
- (id) init
{
    self = [super init];
    if (self)
    {
        self.name = @"Turkey";
        self.recipeType = [NSNumber numberWithInt: FSTRecipeTypeFirstBuildSousVide];
    }
    return self;
    
}
@end
