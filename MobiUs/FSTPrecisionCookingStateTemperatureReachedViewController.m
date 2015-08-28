//
//  FSTPrecisionCookingStateTemperatureReachedViewController.m
//  FirstBuild
//
//  Created by John Nolan on 8/6/15.
//  Copyright (c) 2015 FirstBuild. All rights reserved.
//

#import "FSTPrecisionCookingStateTemperatureReachedViewController.h"
#import "FSTPrecisionCookingStateTemperatureReachedLayer.h"

@interface FSTPrecisionCookingStateTemperatureReachedViewController ()

@end

@implementation FSTPrecisionCookingStateTemperatureReachedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

-(void) viewWillLayoutSubviews {
    [self.circleProgressView setupViewsWithLayerClass:[FSTPrecisionCookingStateTemperatureReachedLayer class]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) updatePercent {
    [super updatePercent];
    self.circleProgressView.progressLayer.percent = 1.0F; // percent insignificant
    //[self.circleProgressView.progressLayer drawPathsForPercent];
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
