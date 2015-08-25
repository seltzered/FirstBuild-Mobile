//
//  FSTSavedRecipeViewController.h
//  FirstBuild
//
//  Created by John Nolan on 8/17/15.
//  Copyright (c) 2015 FirstBuild. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FSTSavedRecipeTableViewController.h"
#import "FSTParagon.h"

@interface FSTSavedRecipeViewController : UIViewController <FSTSavedRecipeTableDelegate>

@property FSTParagon* currentParagon;

@end
