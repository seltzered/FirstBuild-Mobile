//
//  FSTPoultryTurkeySousVideRecipes.m
//  FirstBuild
//
//  Created by Myles Caley on 12/18/15.
//  Copyright © 2015 FirstBuild. All rights reserved.
//

#import "FSTPoultryTurkeySousVideRecipes.h"
#import "FSTPoultryTurkeyBonelessSousVideRecipe.h"
#import "FSTPoultryTurkeyBoneInSousVideRecipe.h"
#import "FSTPoultryTurkeyLegsSousVideRecipe.h"

@implementation FSTPoultryTurkeySousVideRecipes
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.recipes = [[NSArray alloc] initWithObjects:
                        [FSTPoultryTurkeyBonelessSousVideRecipe new],
                        [FSTPoultryTurkeyBoneInSousVideRecipe new],
                        [FSTPoultryTurkeyLegsSousVideRecipe new],
                        nil];
    }
    return self;
}
@end
