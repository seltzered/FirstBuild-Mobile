//
//  WifiCommissioningConnectingViewController.h
//  FirstBuild-Mobile
//
//  Created by Myles Caley on 12/18/14.
//  Copyright (c) 2014 FirstBuild. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FSTDevice.h"

@interface WifiCommissioningConnectingViewController : UIViewController
@property (strong, nonatomic) FSTDevice *device;
@property (strong, nonatomic) IBOutlet UIImageView *searchingIcon;
@end
