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
@property (strong, nonatomic) IBOutlet UILabel *targetTempLabel;

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
    self.circleProgressView.progressLayer.percent = self.burnerLevel;
}

- (void) updateLabels {
    [super updateLabels];
    
    UIFont* smallFont = [UIFont fontWithName:@"FSEmeric-Thin" size:22.0]; // temporary, need to figure out the regular font
    NSDictionary* smallFontDict = [NSDictionary dictionaryWithObject:smallFont forKey:NSFontAttributeName];
    
    UIFont* bigFont = [UIFont fontWithName:@"FSEmeric-SemiBold" size:41.0];
    NSMutableDictionary* bigFontDict = [NSMutableDictionary dictionaryWithObject:bigFont forKey:NSFontAttributeName];
    
    NSMutableAttributedString* temperatureString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%0.0f%@", self.currentTemp, @"\u00b0 F"] attributes:bigFontDict];
    
    double targetTemperature = self.targetTemp;
    NSMutableAttributedString *targetTempString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"Target: %0.0f %@", targetTemperature, @"\u00b0 F"] attributes: smallFontDict];
    
    [self.targetTempLabel setAttributedText:targetTempString];
    [self.currentTempLabel setAttributedText:temperatureString];
    
}
@end
