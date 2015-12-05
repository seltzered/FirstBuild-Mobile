//
//  FSTPrecisionCookingMinTimeReachedNonSousVideViewController.m
//  FirstBuild
//
//  Created by Myles Caley on 12/3/15.
//  Copyright © 2015 FirstBuild. All rights reserved.
//

#import "FSTPrecisionCookingMinTimeReachedNonSousVideViewController.h"
#import "FSTPrecisionCookingStateReachingMaxTimeLayer.h"

@interface FSTPrecisionCookingMinTimeReachedNonSousVideViewController ()

@property (weak, nonatomic) IBOutlet UILabel *currentTempLabel;
@property (weak, nonatomic) IBOutlet UILabel *italicTimeLabel;
@property (strong, nonatomic) IBOutlet UILabel *directionsLabel;

@end

@implementation FSTPrecisionCookingMinTimeReachedNonSousVideViewController
{
    NSDate* endMaxTime;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void) viewWillLayoutSubviews {
    [self.circleProgressView setupViewsWithLayerClass:[FSTPrecisionCookingStateReachingMaxTimeLayer class]];
    [self updatePercent];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self updateLabels];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc
{
    DLog(@"dealloc");
}

-(void) updateLabels {
    [super updateLabels];
    
    UIFont* smallFont = [UIFont fontWithName:@"FSEmeric-Thin" size:22.0];
    NSDictionary* smallFontDict = [NSDictionary dictionaryWithObject:smallFont forKey:NSFontAttributeName];
    
    double currentTemperature = self.cookingData.currentTemp;
    NSMutableAttributedString *currentTempString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%0.0f %@", currentTemperature, @"\u00b0 F"] attributes: smallFontDict]; // with degrees fareinheit appended
    [self.currentTempLabel setAttributedText:currentTempString];
    
    self.directionsLabel.text = self.cookingData.directions;
}


@end
