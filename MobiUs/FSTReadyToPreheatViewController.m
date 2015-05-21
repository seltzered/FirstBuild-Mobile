//
//  FSTReadyToPreheatViewController.m
//  FirstBuild
//
//  Created by Myles Caley on 5/12/15.
//  Copyright (c) 2015 FirstBuild. All rights reserved.
//

#import "FSTReadyToPreheatViewController.h"

@interface FSTReadyToPreheatViewController ()

@end

@implementation FSTReadyToPreheatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)cancelLabelClick:(id)sender {
    [self performSegueWithIdentifier:@"segueCancel" sender:self];
}
- (IBAction)tempTapMoveNextClick:(id)sender {
    [self performSegueWithIdentifier:@"seguePreheating" sender:self];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
