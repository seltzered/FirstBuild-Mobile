//
//  FSTStageSettingsViewController.h
//  FirstBuild
//
//  Created by John Nolan on 8/26/15.
//  Copyright (c) 2015 FirstBuild. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FSTStagePickerManager.h"
#import "FSTRecipe.h"

@interface FSTStageSettingsViewController : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource, FSTStagePickerManagerDelegate, UITextViewDelegate>

@property (nonatomic, weak) FSTParagonCookingStage* activeStage;
@end
