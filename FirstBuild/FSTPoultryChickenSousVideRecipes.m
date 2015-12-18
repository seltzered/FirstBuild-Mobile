//
//  FSTPoultryChickenSousVideRecipes.m
//  FirstBuild
//
//  Created by Myles Caley on 12/18/15.
//  Copyright © 2015 FirstBuild. All rights reserved.
//

#import "FSTPoultryChickenSousVideRecipes.h"
#import "FSTPoultryChickenBoneInSousVideRecipe.h"
#import "FSTPoultryChickenBonelessSousVideRecipe.h"
#import "FSTPoultryChickenLegsSousVideRecipe.h"


@implementation FSTPoultryChickenSousVideRecipes
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.recipes = [[NSArray alloc] initWithObjects:
                        [FSTPoultryChickenBoneInSousVideRecipe new],
                        [FSTPoultryChickenBonelessSousVideRecipe new],
                        [FSTPoultryChickenLegsSousVideRecipe new],
                        nil];
    }
    return self;
}
@end
