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
@property (strong, nonatomic) IBOutlet UIView *donenessSelectionsView;
@property (strong, nonatomic) IBOutlet UIView *selectorOutlineView;
@property (strong, nonatomic) IBOutlet UILabel *wholeNumberLabel;
@property (strong, nonatomic) IBOutlet UIView *fractionView;
@property (strong, nonatomic) IBOutlet UILabel *numeratorLabel;
@property (strong, nonatomic) IBOutlet UILabel *denominatorLabel;
@property (strong, nonatomic) IBOutlet UIView *thicknessLabelView;
@property (strong, nonatomic) IBOutlet UILabel *meatViewLabel;

@end
