//
//  FSTBleConnectedViewController.m
//  FirstBuild
//
//  Created by Myles Caley on 6/22/15.
//  Copyright (c) 2015 FirstBuild. All rights reserved.
//

#import <SWRevealViewController.h>

#import "FSTBleConnectedViewController.h"

@interface FSTBleConnectedViewController ()

@end

@implementation FSTBleConnectedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)continueTapGesture:(id)sender
{
    [self.navigationController popToRootViewControllerAnimated:NO];
}

@end
