//
//  FSTFruitSousVideRecipes.m
//  FirstBuild
//
//  Created by Myles Caley on 12/18/15.
//  Copyright © 2015 FirstBuild. All rights reserved.
//

#import "FSTFruitSousVideRecipes.h"

@implementation FSTFruitSousVideRecipes
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.recipes = [[NSArray alloc] initWithObjects:
                        [FSTFruitApplesSousVideRecipe new],
                        [FSTFruitPeachesSousVideRecipe new],
                        [FSTFruitNectarinesSousVideRecipe new],
                        [FSTFruitBerriesSousVideRecipe new],
                        [FSTFruitPearsSousVideRecipe new],
                        [FSTFruitApricotsSousVideRecipe new],
                        [FSTFruitPlumsSousVideRecipe new],
                        [FSTFruitMangosSousVideRecipe new],
                        [FSTFruitPapayaSousVideRecipe new],
                        [FSTFruitCherriesSousVideRecipe new],
                        nil];
    }
    return self;
}
@end
