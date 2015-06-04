//
//  FSTPreheatingViewController.h
//  FirstBuild
//
//  Created by Myles Caley on 5/12/15.
//  Copyright (c) 2015 FirstBuild. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FSTParagon.h"

@interface FSTPreheatingViewController : UIViewController

@property (nonatomic,retain) FSTParagon* currentParagon;
@property (strong, nonatomic) IBOutlet UILabel *currentTemperatureLabel;
@property (strong, nonatomic) IBOutlet UILabel *targetTemperatureLabel;
@property (strong, nonatomic) IBOutlet UIView *temperatureScrollerView;
@property (strong, nonatomic) IBOutlet UIView *topOrangeBarView;
@property (strong, nonatomic) IBOutlet UIView *buttonWrapperView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *temperatureScrollerHeightConstraint;
@end
