//
//  FSTRecipeViewController.h
//  FirstBuild
//
//  Created by Myles Caley on 5/12/15.
//  Copyright (c) 2015 FirstBuild. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "FSTRecipeTableViewController.h"
#import "FSTParagon.h"

@interface FSTRecipeViewController : UIViewController <FSTRecipeTableViewControllerDelegate>

@property (weak, nonatomic) FSTParagon* product;

@end
