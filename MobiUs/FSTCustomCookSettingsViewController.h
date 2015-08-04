//
//  FSTCustomCookSettingsViewController.h
//  FirstBuild
//
//  Created by Myles Caley on 5/12/15.
//  Copyright (c) 2015 FirstBuild. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FSTParagon.h"
#import "FSTCookSettingsViewController.h"

@interface FSTCustomCookSettingsViewController : FSTCookSettingsViewController <UIPickerViewDataSource, UIPickerViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (weak, nonatomic) IBOutlet UILabel *temperatureLabel;

@property (weak, nonatomic) IBOutlet UIPickerView *picker;

@property (weak, nonatomic) IBOutlet UIView *timeButtonHolder;

@property (weak, nonatomic) IBOutlet UIView *temperatureButtonHolder;

@property (weak, nonatomic) IBOutlet UILabel *timeButtonLabel;

@property (weak, nonatomic) IBOutlet UILabel *temperatureButtonLabel;

-(void)updateLabels;

@end
