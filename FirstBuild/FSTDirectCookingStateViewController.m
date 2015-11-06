//
//  FSTDirectCookingStateViewController.m
//  FirstBuild
//
//  Created by John Nolan on 8/12/15.
//  Copyright (c) 2015 FirstBuild. All rights reserved.
//

#import "FSTDirectCookingStateViewController.h"
#import "FSTPrecisionCookingStateReachingMinTimeLayer.h"

@interface FSTDirectCookingStateViewController ()

@end

@implementation FSTDirectCookingStateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillLayoutSubviews {
    [self.circleProgressView setupViewsWithLayerClass:[FSTPrecisionCookingStateReachingMinTimeLayer class]];
}

- (void) updatePercent {
    self.circleProgressView.progressLayer.percent = (self.burnerLevel * 10)/100;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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
