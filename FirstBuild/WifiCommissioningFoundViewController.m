//
//  WifiCommissioningFoundViewController.m
//  FirstBuild-Mobile
//
//  Created by Myles Caley on 1/14/15.
//  Copyright (c) 2015 FirstBuild. All rights reserved.
//

#import "WifiCommissioningFoundViewController.h"
#import <SWRevealViewController.h>

@interface WifiCommissioningFoundViewController ()

@end

@implementation WifiCommissioningFoundViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)okClick:(id)sender {
    // [self.revealViewController performSegueWithIdentifier:@"sw_front" sender:self];
    [self.navigationController popToRootViewControllerAnimated:NO];
}

@end
