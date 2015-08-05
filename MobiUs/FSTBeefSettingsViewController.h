//
//  FSTBeefSettingsViewController.h
//  FirstBuild
//
//  Created by Myles Caley on 5/12/15.
//  Copyright (c) 2015 FirstBuild. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "FSTParagon.h"
#import "FSTCookSettingsViewController.h"

@interface FSTBeefSettingsViewController : FSTCookSettingsViewController

@property (weak, nonatomic) IBOutlet UILabel *beefSettingsLabel;
@property (weak, nonatomic) IBOutlet UILabel *tempSettingsLabel;
@property (weak, nonatomic) IBOutlet UISlider *donenessSlider;
@property (weak, nonatomic) IBOutlet UILabel *donenessLabel;
@property (weak, nonatomic) IBOutlet UISlider *thicknessSlider;
@property (weak, nonatomic) IBOutlet UILabel *thicknessLabel;

@end
