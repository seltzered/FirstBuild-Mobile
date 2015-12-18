//
//  FSTFishSousVideRecipes.m
//  FirstBuild
//
//  Created by Myles Caley on 12/18/15.
//  Copyright © 2015 FirstBuild. All rights reserved.
//

#import "FSTFishSousVideRecipes.h"


@implementation FSTFishSousVideRecipes
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.recipes = [[NSArray alloc] initWithObjects:
                        [FSTFishFilletSousVideRecipe new],
                        [FSTFishSteakSousVideRecipe new],
                        nil];
    }
    return self;
}
@end
