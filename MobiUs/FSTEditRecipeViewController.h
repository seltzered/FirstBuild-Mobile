//
//  FSTEditRecipeViewController.h
//  FirstBuild
//
//  Created by John Nolan on 8/13/15.
//  Copyright (c) 2015 FirstBuild. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FSTRecipe.h"

@interface FSTEditRecipeViewController : UIViewController<UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate>

@property FSTRecipe* activeRecipe;

@end
