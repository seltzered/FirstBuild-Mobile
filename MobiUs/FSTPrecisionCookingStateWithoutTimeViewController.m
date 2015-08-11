//
//  FSTPrecisionCookingStateWithoutTimeViewController.m
//  FirstBuild
//
//  Created by John Nolan on 8/11/15.
//  Copyright (c) 2015 FirstBuild. All rights reserved.
//

#import "FSTPrecisionCookingStateWithoutTimeViewController.h"
#import "FSTPrecisionCookingStatePastMaxTimeLayer.h" // same as this layer, but could choose any other
@interface FSTPrecisionCookingStateWithoutTimeViewController ()

@property (weak, nonatomic) IBOutlet UILabel *currentTempLabel;

@end

@implementation FSTPrecisionCookingStateWithoutTimeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillLayoutSubviews {
    [self.circleProgressView setupViewsWithLayerClass:[FSTPrecisionCookingStatePastMaxTimeLayer class]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void) updatePercent {
    [super updatePercent];
    self.circleProgressView.progressLayer.percent = 1.0F;
}

- (void) updateLabels {
    UIFont* bigFont = [UIFont fontWithName:@"FSEmeric-SemiBold" size:41.0];
    NSMutableDictionary* bigFontDict = [NSMutableDictionary dictionaryWithObject:bigFont forKey:NSFontAttributeName];
    
    NSMutableAttributedString* temperatureString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%0.1f%@", self.currentTemp, @"\u00b0 F"] attributes:bigFontDict];
    
    [self.currentTempLabel setAttributedText:temperatureString];
}
@end
