//
//  FSTCookingMethodTableViewController.h
//  FirstBuild
//
//  Created by Myles Caley on 5/13/15.
//  Copyright (c) 2015 FirstBuild. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "FSTRecipes.h"
#import "FSTRecipe.h"

@protocol FSTRecipeTableViewControllerDelegate

- (FSTRecipes *) dataRequestedFromChild;
- (void) recipeSelected: (FSTRecipe*)recipe;

@end


@interface FSTRecipeTableViewController : UITableViewController

@property (weak, nonatomic) id<FSTRecipeTableViewControllerDelegate>delegate;

@end
