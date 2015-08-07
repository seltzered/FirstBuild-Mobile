//
//  FSTCookingStatePreheatingViewController.m
//  FirstBuild
//
//  Created by John Nolan on 8/6/15.
//  Copyright (c) 2015 FirstBuild. All rights reserved.
//

#import "FSTCookingStatePreheatingViewController.h"
#import "FSTCookingStatePreheatingLayer.h"

@interface FSTCookingStatePreheatingViewController ()

@end

@implementation FSTCookingStatePreheatingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.progressView.progressLayer = [[FSTCookingStatePreheatingLayer alloc] init];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) updatePercent {
    [super updatePercent];
    self.progressView.progressLayer.percent = [self calculatePercentWithTemp:self.currentTemp];
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
