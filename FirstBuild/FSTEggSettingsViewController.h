//
//  FSTEggSettingsViewController.h
//  FirstBuild
//
//  Created by Myles Caley on 12/17/15.
//  Copyright © 2015 FirstBuild. All rights reserved.
//

#import "FSTCookSettingsViewController.h"

@interface FSTEggSettingsViewController : FSTCookSettingsViewController <FSTParagonDelegate>

@property (weak, nonatomic) IBOutlet UILabel *beefSettingsLabel;
@property (weak, nonatomic) IBOutlet UILabel *maxBeefSettingsLabel;
@property (weak, nonatomic) IBOutlet UILabel *tempSettingsLabel;
@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *continueTapGestureRecognizer;
@property (weak, nonatomic) IBOutlet UILabel *donenessLabel;
@property (strong, nonatomic) IBOutlet UISlider *donessSlider;

@end
