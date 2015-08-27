//
//  FSTEditRecipeViewController.h
//  FirstBuild
//
//  Created by John Nolan on 8/13/15.
//  Copyright (c) 2015 FirstBuild. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FSTRecipe.h"
#import "FSTParagon.h"
#import "FSTStagePickerManager.h"
#import "FSTSavedRecipeManager.h"
#import "FSTStageTableViewController.h"

@interface FSTSavedEditRecipeViewController : UIViewController<UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate, UITextViewDelegate, UITabBarControllerDelegate, FSTStageTableViewControllerDelegate>

@property (nonatomic, strong) FSTRecipe* activeRecipe; 
// need two different classes to decide what settings to load
@property (nonatomic, weak) FSTParagon* currentParagon;

@end
