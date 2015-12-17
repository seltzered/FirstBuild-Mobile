//
//  FSTPoultrySousVideRecipes.m
//  FirstBuild
//
//  Created by Myles Caley on 12/17/15.
//  Copyright © 2015 FirstBuild. All rights reserved.
//

#import "FSTPoultrySousVideRecipes.h"
#import "FSTPoultryChickenSousVideRecipe.h"
#import "FSTPoultryDuckSousVideRecipe.h"
#import "FSTPoultryTurkeySousVideRecipe.h"

@implementation FSTPoultrySousVideRecipes
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.recipes = [[NSArray alloc] initWithObjects:
                        [FSTPoultryChickenSousVideRecipe new],
                        [FSTPoultryDuckSousVideRecipe new],
                        [FSTPoultryTurkeySousVideRecipe new],
                        nil];
    }
    return self;
}
@end
