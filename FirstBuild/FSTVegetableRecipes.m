//
//  FSTVegetableRecipes.m
//  FirstBuild
//
//  Created by Myles Caley on 12/15/15.
//  Copyright © 2015 FirstBuild. All rights reserved.
//

#import "FSTVegetableRecipes.h"
#import "FSTVegetableArtichokeSousVideRecipe.h"
#import "FSTVegetableAsparagusSousVideRecipe.h"
#import "FSTVegetableBeetsSousVideRecipe.h"
#import "FSTVegetableBroccoliSousVideRecipe.h"
#import "FSTVegetableBrusselSproutsSousVideRecipe.h"
#import "FSTVegetableCarrotsSousVideRecipe.h"
#import "FSTVegetableCornSousVideRecipe.h"
#import "FSTVegetableFennelSousVideRecipe.h"
#import "FSTVegetableGreenBeansSousVideRecipe.h"
#import "FSTVegetablePotatoesSousVideRecipe.h"
#import "FSTVegetableSweetPotatoesSousVideRecipe.h"

@implementation FSTVegetableRecipes

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.recipes = [[NSArray alloc] initWithObjects:
                        [FSTVegetableArtichokeSousVideRecipe new],
                        [FSTVegetableAsparagusSousVideRecipe new],
                        [FSTVegetableBeetsSousVideRecipe new],
                        [FSTVegetableBroccoliSousVideRecipe new],
                        [FSTVegetableBrusselSproutsSousVideRecipe new],
                        [FSTVegetableCarrotsSousVideRecipe new],
                        [FSTVegetableCornSousVideRecipe new],
                        [FSTVegetableFennelSousVideRecipe new],
                        [FSTVegetableGreenBeansSousVideRecipe new],
                        [FSTVegetablePotatoesSousVideRecipe new],
                        [FSTVegetableSweetPotatoesSousVideRecipe new],
                        nil];
    }
    return self;
}

@end
