//
//  FSTSavedRecipeTableViewController.h
//  FirstBuild
//
//  Created by John Nolan on 8/17/15.
//  Copyright (c) 2015 FirstBuild. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FSTRecipe.h"

@protocol FSTSavedRecipeTableDelegate <NSObject>

-(void)segueWithRecipe:(FSTRecipe*)recipe;

-(void)displayWithRecipe:(FSTRecipe*)recipe;

-(void)didDeleteRecipe;

@end

@interface FSTSavedRecipeTableViewController : UITableViewController

@property (nonatomic, weak) id <FSTSavedRecipeTableDelegate> delegate;

@end
