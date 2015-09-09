//
//  WifiCommissioningPasswordViewController.m
//  FirstBuild-Mobile
//
//  Created by Myles Caley on 1/12/15.
//  Copyright (c) 2015 FirstBuild. All rights reserved.
//

#import "WifiCommissioningPasswordViewController.h"
#import "WifiCommissioningNetworkListViewController.h"

@interface WifiCommissioningPasswordViewController ()

@end

@implementation WifiCommissioningPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    UIToolbar *translucentUnderlayment = [[UIToolbar alloc] init];
    [translucentUnderlayment setFrame:self.view.bounds];
    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1) {
        [translucentUnderlayment setAlpha:0.9];
    }
    translucentUnderlayment.layer.masksToBounds = YES;
    [self.view addSubview:translucentUnderlayment];
    [self.view sendSubviewToBack:translucentUnderlayment];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.networkLabel.text = self.network.ssid;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)buttonActionConnect:(id)sender {
    WifiCommissioningNetworkListViewController *parentController = (WifiCommissioningNetworkListViewController*)self.delegate;
    parentController.selectedNetwork.passphrase = self.passwordText.text;
    [self dismissViewControllerAnimated:YES completion:^{
         [parentController connectToWifi];
    }];
   
}

- (IBAction)cancelButton:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        nil;
    }];
}

@end
