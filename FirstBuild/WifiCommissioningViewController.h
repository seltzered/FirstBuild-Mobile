//
//  WifiCommissioningViewController.h
//  FirstBuild-Mobile
//
//  Created by Myles Caley on 11/17/14.
//  Copyright (c) 2014 FirstBuild. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FSTDevice.h"

@interface WifiCommissioningViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIImageView *searchingIcon;
@property NSInteger checkForAPTries;
@property (strong, nonatomic) FSTDevice *device;
@property (strong, nonatomic) NSTimer* searchTimer;
@end
