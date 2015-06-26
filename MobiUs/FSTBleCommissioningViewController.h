//
//  FSTBleCommissioningViewController.h
//  FirstBuild
//
//  Created by Myles Caley on 6/19/15.
//  Copyright (c) 2015 FirstBuild. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FSTBleCommissioningTableViewController.h"

@interface FSTBleCommissioningViewController : UIViewController<FSTBleCommissioningTableViewControllerDelegate>
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityWheel;
@property (weak, nonatomic) IBOutlet UIView *wheelBackground;

@end
