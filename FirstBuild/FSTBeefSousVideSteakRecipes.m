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
#import "FSTBeefSteakTenderTopLoinSousVideRecipe.h"
#import "FSTBeefSteakTenderTBoneSousVideRecipe.h"
#import "FSTBeefSteakTenderPorterHouseSousVideRecipe.h"
#import "FSTBeefSteakNormalFlatIronSousVideRecipe.h"
#import "FSTBeefSteakNormalSirloinSousVideRecipe.h"
#import "FSTBeefSteakToughCubedSousVideRecipe.h"
#import "FSTBeefSteakToughFlankSousVideRecipe.h"
#import "FSTBeefSteakToughRoundSousVideRecipe.h"
#import "FSTBeefSteakToughSkirtSousVideRecipe.h"
#import "FSTBeefSteakToughTipSousVideRecipe.h"


@implementation FSTBeefSousVideSteakRecipes

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.recipes = [[NSArray alloc] initWithObjects:
                        [FSTBeefSteakTenderRibEyeSousVideRecipe new],
                        [FSTBeefSteakTenderRibSousVideRecipe new],
                        [FSTBeefSteakTenderTopLoinSousVideRecipe new],
                        [FSTBeefSteakTenderTBoneSousVideRecipe new],
                        [FSTBeefSteakTenderPorterHouseSousVideRecipe new],
                        [FSTBeefSteakNormalFlatIronSousVideRecipe new],
                        [FSTBeefSteakNormalSirloinSousVideRecipe new],
                        [FSTBeefSteakToughCubedSousVideRecipe new],
                        [FSTBeefSteakToughFlankSousVideRecipe new],
                        [FSTBeefSteakToughRoundSousVideRecipe new],
                        [FSTBeefSteakToughSkirtSousVideRecipe new],
                        [FSTBeefSteakToughTipSousVideRecipe new],
                        nil];
    }
    return self;
}

@end
