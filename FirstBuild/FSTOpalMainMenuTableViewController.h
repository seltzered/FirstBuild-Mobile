//
//  FSTOpalMainMenuTableViewController.h
//  FirstBuild
//
//  Created by Myles Caley on 3/31/16.
//  Copyright © 2016 FirstBuild. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FSTOpal.h"

@interface FSTOpalMainMenuTableViewController : UITableViewController  <FSTOpalDelegate>
@property (weak, nonatomic) FSTOpal* opal;
@property (strong, nonatomic) IBOutlet UILabel *statusLabelOutlet;
@property (strong, nonatomic) IBOutlet UISwitch *nightLightSwitchOutlet;
@property (strong, nonatomic) IBOutlet UISwitch *scheduleEnabledSwitchOutlet;
@end
