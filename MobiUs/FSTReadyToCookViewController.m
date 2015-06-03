//
//  FSTReadyToCookViewController.m
//  FirstBuild
//
//  Created by Myles Caley on 5/12/15.
//  Copyright (c) 2015 FirstBuild. All rights reserved.
//

#import "FSTReadyToCookViewController.h"

@interface FSTReadyToCookViewController ()

@end

@implementation FSTReadyToCookViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)continueButtonTap:(id)sender {
    [self performSegueWithIdentifier:@"segueCooking" sender:self];
}


@end
