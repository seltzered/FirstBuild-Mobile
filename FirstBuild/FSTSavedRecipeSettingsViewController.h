//
//  FSTSavedRecipeSettingsViewController.h
//  FirstBuild
//
//  Created by John Nolan on 8/24/15.
//  Copyright (c) 2015 FirstBuild. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FSTStagePickerManager.h"

@interface FSTSavedRecipeSettingsViewController : UIViewController<FSTStagePickerManagerDelegate>

@property (nonatomic, strong) FSTStagePickerManager* pickerManager;

@end
