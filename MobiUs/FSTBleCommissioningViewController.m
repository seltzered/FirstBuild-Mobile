//
//  FSTBleCommissioningViewController.m
//  FirstBuild
//
//  Created by Myles Caley on 6/19/15.
//  Copyright (c) 2015 FirstBuild. All rights reserved.
//

#import "FSTBleCommissioningViewController.h"

@interface FSTBleCommissioningViewController ()

@end

@implementation FSTBleCommissioningViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[self.wheelBackground layer] setCornerRadius:self.wheelBackground.frame.size.height/2];
    [self.activityWheel insertSubview:self.wheelBackground atIndex:0];

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
