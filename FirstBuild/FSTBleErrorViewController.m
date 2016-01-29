//
//  FSTBleErrorViewController.m
//  FirstBuild
//
//  Created by John Nolan on 6/24/15.
//  Copyright (c) 2015 FirstBuild. All rights reserved.
//

#import "FSTBleErrorViewController.h"

@interface FSTBleErrorViewController ()

@end

@implementation FSTBleErrorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(timeout:) userInfo:nil repeats:NO];

    // Do any additional setup after loading the view from its nib.
}

- (void)timeout:(NSTimer*)timer {
    
    [self.navigationController popToRootViewControllerAnimated:YES];
    // Press the icon. just to test segues until I figure out when the segue actually happens.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
