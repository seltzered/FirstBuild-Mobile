//
//  FSTEggRecipes.m
//  FirstBuild
//
//  Created by Myles Caley on 12/17/15.
//  Copyright © 2015 FirstBuild. All rights reserved.
//

#import "FSTEggRecipes.h"
#import "FSTEggScrambledSousVideRecipe.h"
#import "FSTEggWholeSousVideRecipe.h"

@implementation FSTEggRecipes

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.recipes = [[NSArray alloc] initWithObjects:
                        [FSTEggScrambledSousVideRecipe new],
                        [FSTEggWholeSousVideRecipe new],
                        nil];
    }
    return self;
}
@end
