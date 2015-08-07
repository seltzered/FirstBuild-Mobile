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
    
    //[self.progressView layoutSubviews];
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSLog(@"%f, %f", self.progressView.frame.size.height, self.progressView.frame.size.width);
    

    //self.progressView.progressLayer = [[FSTCookingStatePreheatingLayer alloc] init];
}

-(void)viewWillLayoutSubviews
{
    [self.circleProgressView setupViewsWithLayerClass:[FSTCookingStatePreheatingLayer class]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) updatePercent {
    [super updatePercent];
    self.progressView.progressLayer.percent = [self calculatePercentWithTemp:self.currentTemp];
}

@end
