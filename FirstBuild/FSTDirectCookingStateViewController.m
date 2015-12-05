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
    self.circleProgressView.progressLayer.percent = (self.cookingData.burnerLevel * 10)/100;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
