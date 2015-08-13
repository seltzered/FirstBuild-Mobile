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

@interface FSTEditRecipeViewController : UIViewController<UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate, UITextViewDelegate>

@property FSTRecipe* activeRecipe;

@property FSTParagon* currentParagon;

@end
