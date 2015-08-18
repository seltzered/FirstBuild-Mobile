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
#import "FSTRecipeManager.h"

@interface FSTEditRecipeViewController : UIViewController<UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate, UITextViewDelegate, FSTStagePickerManagerDelegate>

@property (nonatomic, strong) FSTRecipe* activeRecipe;

@property (nonatomic, weak) FSTParagon* currentParagon;

@end
