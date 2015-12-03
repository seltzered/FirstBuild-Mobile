//
//  FSTPrecisionCookingStateReachingMinTimeNonSousVideViewController.m
//  FirstBuild
//
//  Created by Myles Caley on 12/2/15.
//  Copyright © 2015 FirstBuild. All rights reserved.
//

#import "FSTPrecisionCookingStateReachingMinTimeNonSousVideViewController.h"
#import "FSTPrecisionCookingStateReachingMinTimeLayer.h"

@interface FSTPrecisionCookingStateReachingMinTimeNonSousVideViewController ()
@property (weak, nonatomic) IBOutlet UILabel *currentTempLabel;

@property (weak, nonatomic) IBOutlet UILabel *endTimeLabel;
@end

@implementation FSTPrecisionCookingStateReachingMinTimeNonSousVideViewController
{
    NSDate* endTime;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self updateLabels];
}

- (void)viewWillLayoutSubviews {
    [self.circleProgressView setupViewsWithLayerClass:[FSTPrecisionCookingStateReachingMinTimeLayer class]];
    [self updatePercent]; // sublayer needs to exist first
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) updatePercent {
    [super updatePercent];

    self.circleProgressView.progressLayer.percent = [self calculatePercent:(self.targetMinTime - self.remainingHoldTime) toTime:self.targetMinTime];
}

-(void) targetTimeChanged:(NSTimeInterval)minTime withMax:(NSTimeInterval)maxTime {
    [super targetTimeChanged:minTime withMax:maxTime];
}

-(void) updateLabels {
    [super updateLabels];
    
    UIFont* smallFont = [UIFont fontWithName:@"FSEmeric-Thin" size:22.0];
    NSDictionary* smallFontDict = [NSDictionary dictionaryWithObject:smallFont forKey:NSFontAttributeName];
    
    double currentTemperature = self.currentTemp;
    NSMutableAttributedString *currentTempString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%0.0f %@", currentTemperature, @"\u00b0 F"] attributes: smallFontDict];

    
    [self.currentTempLabel setAttributedText:currentTempString];
    if (self.remainingHoldTime == 1)
    {
        [self.endTimeLabel setText:[NSString stringWithFormat:@"%d min", (int)self.remainingHoldTime]];
    }
    else
    {
        [self.endTimeLabel setText:[NSString stringWithFormat:@"%d mins", (int)self.remainingHoldTime]];
    }
}

@end
