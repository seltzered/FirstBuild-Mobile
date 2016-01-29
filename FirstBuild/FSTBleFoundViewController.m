//
//  FSTBleFoundViewController.m
//  FirstBuild
//
//  Created by John Nolan on 6/24/15.
//  Copyright (c) 2015 FirstBuild. All rights reserved.
//

#import "FSTBleFoundViewController.h"
#import "FSTBleNamingViewController.h"

@interface FSTBleFoundViewController ()

@end

@implementation FSTBleFoundViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.hidesBackButton = true;
    [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(timedSegue:) userInfo:nil repeats:NO];
    // Do any additional setup after loading the view.
}

- (void)timedSegue:(NSTimer*)timer {
    
    [self performSegueWithIdentifier:@"segueNaming" sender:self];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"segueNaming"]) {
        FSTBleNamingViewController* vc = segue.destinationViewController;
        vc.peripheral = self.peripheral; // set the peripheral
        vc.bleProductClass = self.bleProductClass;
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    }
}


@end
