//
//  WifiCommissioningPasswordViewController.h
//  FirstBuild-Mobile
//
//  Created by Myles Caley on 1/12/15.
//  Copyright (c) 2015 FirstBuild. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FSTNetwork.h"

@interface WifiCommissioningPasswordViewController : UIViewController

@property (nonatomic, assign) id delegate;
@property (strong, nonatomic) IBOutlet UILabel *networkLabel;
@property (strong, nonatomic) IBOutlet UITextField *passwordText;
@property (strong, nonatomic) FSTNetwork* network;
@end
