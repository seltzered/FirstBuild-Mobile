//
//  FSTPrecisionCookingStatePastMaxTimeViewController.m
//  FirstBuild
//
//  Created by John Nolan on 8/7/15.
//  Copyright (c) 2015 FirstBuild. All rights reserved.
//

#import "FSTPrecisionCookingStatePastMaxTimeViewController.h"
#import "FSTPrecisionCookingStatePastMaxTimeLayer.h"

@interface FSTPrecisionCookingStatePastMaxTimeViewController ()

@end

@implementation FSTPrecisionCookingStatePastMaxTimeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.progressView.progressLayer = [[FSTPrecisionCookingStatePastMaxTimeLayer alloc] init];
    // Do any additional setup after loading the view.
}

- (void)viewWillLayoutSubviews {
    [self.progressView setupViewsWithLayerClass:[FSTPrecisionCookingStatePastMaxTimeLayer class]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)updatePercent {
    [super updatePercent];
    self.progressView.progressLayer.percent = 1.0F; // could just call drawPaths for percent here
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
