//
//  FSTRecipeTableViewController.h
//  FirstBuild
//
//  Created by John Nolan on 8/17/15.
//  Copyright (c) 2015 FirstBuild. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FSTRecipe.h"

@protocol FSTRecipeTableDelegate <NSObject>

-(void)segueWithRecipe:(FSTRecipe*)recipe;

-(void)startCookingWithSession:(FSTParagonCookingSession*)session;

@end

@interface FSTRecipeTableViewController : UITableViewController

@property (nonatomic, weak) id <FSTRecipeTableDelegate> delegate;

@end
