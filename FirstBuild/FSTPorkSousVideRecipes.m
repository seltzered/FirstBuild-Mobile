//
//  FSTPorkSousVideRecipes.m
//  FirstBuild
//
//  Created by Myles Caley on 12/18/15.
//  Copyright © 2015 FirstBuild. All rights reserved.
//

#import "FSTPorkSousVideRecipes.h"

@implementation FSTPorkSousVideRecipes
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.recipes = [[NSArray alloc] initWithObjects:
                        [FSTPorkChopsSousVideRecipe new],
                        [FSTPorkShoulderSousVideRecipe new],
                        [FSTPorkSpareRibsSousVideRecipe new],
                        [FSTPorkBackRibsSousVideRecipe new],
                        [FSTPorkTenderloinSousVideRecipe new],
                        nil];
    }
    return self;
}
@end
