//
//  FSTSavedDisplayRecipeViewController.h
//  FirstBuild
//
//  Created by John Nolan on 9/2/15.
//  Copyright (c) 2015 FirstBuild. All rights reserved.
//

#import "FSTSavedEditRecipeViewController.h"
#import "FSTRecipe.h"
#import "FSTParagon.h"

@interface FSTSavedDisplayRecipeViewController : FSTSavedEditRecipeViewController

@property (weak, nonatomic) IBOutlet UIView *cookButton;

@property (weak, nonatomic) NSNumber* will_hide_cook;

@end
