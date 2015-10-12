//
//  FSTCustomCookSettingsViewController.h
//  FirstBuild
//
//  Created by Myles Caley on 5/12/15.
//  Copyright (c) 2015 FirstBuild. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FSTCookSettingsViewController.h"
#import "FSTStagePickerManager.h"

@interface FSTCustomCookSettingsViewController : FSTCookSettingsViewController <FSTStagePickerManagerDelegate, FSTParagonDelegate>

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *minPickerHeight; // height of min time picker

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *maxPickerHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tempPickerHeight;
@property (weak, nonatomic) IBOutlet UILabel *minTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *maxTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *temperatureLabel;
@property (weak, nonatomic) IBOutlet UIPickerView *minPicker;
@property (weak, nonatomic) IBOutlet UIPickerView *maxPicker;
@property (weak, nonatomic) IBOutlet UIPickerView *tempPicker;
@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *continueTapGesturerRecognizer;

@end
