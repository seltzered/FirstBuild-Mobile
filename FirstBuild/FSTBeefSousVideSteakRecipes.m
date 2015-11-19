//
//  FSTBeefSousVideSteakRecipes.m
//  FirstBuild
//
//  Created by Myles Caley on 11/19/15.
//  Copyright © 2015 FirstBuild. All rights reserved.
//

#import "FSTBeefSousVideSteakRecipes.h"
#import "FSTBeefSteakTenderRibEyeSousVideRecipe.h"
#import "FSTBeefSteakTenderRibSousVideRecipe.h"

@implementation FSTBeefSousVideSteakRecipes

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.recipes = [[NSArray alloc] initWithObjects:
                        [FSTBeefSteakTenderRibEyeSousVideRecipe new],
                        [FSTBeefSteakTenderRibSousVideRecipe new],
                        nil];
    }
    return self;
}

@end
