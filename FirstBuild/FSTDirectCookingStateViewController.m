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
{
    
    IBOutlet UILabel *labelPowerLevel;
    float _powerLevel;
}

@end

@implementation FSTDirectCookingStateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _powerLevel =(self.cookingData.burnerLevel * 10)/100;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 0.1 * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        self.circleProgressView.progressLayer.percent = _powerLevel;
    });
                   
    
}

-(void)viewWillLayoutSubviews
{
    [self.circleProgressView setupViewsWithLayerClass:[FSTPrecisionCookingStateReachingMinTimeLayer class]];
    [self updatePercent];
}

- (void) updatePercent {
    [super updatePercent];
    _powerLevel =(self.cookingData.burnerLevel * 10)/100;
    labelPowerLevel.text = [NSString stringWithFormat:@"Power\n%d",(int)self.cookingData.burnerLevel];
    self.circleProgressView.progressLayer.percent = _powerLevel;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
