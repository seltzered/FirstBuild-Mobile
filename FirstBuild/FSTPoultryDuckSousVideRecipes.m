//
//  FSTPoultryDuckSousVideRecipes.m
//  FirstBuild
//
//  Created by Myles Caley on 12/17/15.
//  Copyright © 2015 FirstBuild. All rights reserved.
//

#import "FSTPoultryDuckSousVideRecipes.h"
#import "FSTPoultryDuckBreastSousVideRecipe.h"
#import "FSTPoultryDuckLegsSousVideRecipe.h"

@implementation FSTPoultryDuckSousVideRecipes

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.recipes = [[NSArray alloc] initWithObjects:
                        [FSTPoultryDuckBreastSousVideRecipe new],
                        [FSTPoultryDuckLegsSousVideRecipe new],
                        nil];
    }
    return self;
}
@end
