//
//  FSTBeefSousVideRoastRecipes.m
//  FirstBuild
//
//  Created by Myles Caley on 11/20/15.
//  Copyright © 2015 FirstBuild. All rights reserved.
//

#import "FSTBeefSousVideRoastRecipes.h"


@implementation FSTBeefSousVideRoastRecipes

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.recipes = [[NSArray alloc] initWithObjects:
                        [FSTBeefRoastTenderLoinSousVideRecipe new],
                        [FSTBeefRoastRibEyeSousVideRecipe new],
                        [FSTBeefRoastChuckRoastSousVideRecipe new],
                        [FSTBeefRoastBrisketSousVideRecipe new],
                        [FSTBeefRoastShortRibsSousVideRecipe new],
                        [FSTBeefRoastGroundBeefSousVideRecipe new],
                        nil];
    }
    return self;
}

@end
