//
//  FSTCookSettingsViewController.m
//  FirstBuild
//
//  Created by Myles Caley on 8/4/15.
//  Copyright (c) 2015 FirstBuild. All rights reserved.
//

#import "FSTCookSettingsViewController.h"

@interface FSTCookSettingsViewController ()

@end

@implementation FSTCookSettingsViewController 

- (void)viewDidLoad {
    [super viewDidLoad];
    self.currentParagon.delegate = self;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
