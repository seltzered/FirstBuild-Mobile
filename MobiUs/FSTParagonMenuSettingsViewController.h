//
//  FSTParagonMenuSettingsViewController.h
//  FirstBuild
//
//  Created by John Nolan on 7/27/15.
//  Copyright (c) 2015 FirstBuild. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FSTParagon.h"

@interface FSTParagonMenuSettingsViewController : UIViewController <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UISwitch *temperatureSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *unitSwitch;
@property (weak, nonatomic) IBOutlet UILabel *serialNumberLabel;
@property (weak, nonatomic) IBOutlet UITextField *paragonNameField;
@property (strong, nonatomic) FSTParagon* currentParagon;

@end
