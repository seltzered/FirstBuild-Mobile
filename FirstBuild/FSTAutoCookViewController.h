//
//  FSTAutoCookViewController.h
//  FirstBuild
//
//  Created by Myles Caley on 12/15/15.
//  Copyright © 2015 FirstBuild. All rights reserved.
//

#import "FSTCookSettingsViewController.h"

@interface FSTAutoCookViewController : FSTCookSettingsViewController <FSTParagonDelegate>

@property (weak, nonatomic) IBOutlet UILabel *beefSettingsLabel;
@property (weak, nonatomic) IBOutlet UILabel *maxBeefSettingsLabel;
@property (weak, nonatomic) IBOutlet UILabel *tempSettingsLabel;
@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *continueTapGestureRecognizer;

@end
