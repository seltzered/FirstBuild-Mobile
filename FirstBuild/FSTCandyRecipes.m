//
//  FSTCandyRecipes.m
//  FirstBuild
//
//  Created by Myles Caley on 8/18/15.
//  Copyright (c) 2015 FirstBuild. All rights reserved.
//

#import "FSTCandyRecipes.h"
#import "FSTCaramelBrittleCandyRecipe.h"

@implementation FSTCandyRecipes

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.recipes = [[NSArray alloc] initWithObjects:
                        [FSTCaramelBrittleCandyRecipe new],
                        nil];
        
    }
    return self;
}

@end
