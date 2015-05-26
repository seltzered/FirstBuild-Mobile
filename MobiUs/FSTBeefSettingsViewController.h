//
//  FSTBeefSettingsViewController.h
//  FirstBuild
//
//  Created by Myles Caley on 5/12/15.
//  Copyright (c) 2015 FirstBuild. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FSTBeefSettingsViewController : UIViewController

@property (strong, nonatomic) IBOutlet UILabel *beefSettingsLabel;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *beefSizeVerticalConstraint;
@property (strong, nonatomic) IBOutlet UIView *timeTemperatureView;

@end
