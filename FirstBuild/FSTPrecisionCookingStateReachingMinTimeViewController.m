//
//  FSTPrecisionCookingStateReachingMinTimeViewController.m
//  FirstBuild
//
//  Created by John Nolan on 8/6/15.
//  Copyright (c) 2015 FirstBuild. All rights reserved.
//

#import "FSTPrecisionCookingStateReachingMinTimeViewController.h"
#import "FSTPrecisionCookingStateReachingMinTimeLayer.h"

@interface FSTPrecisionCookingStateReachingMinTimeViewController ()

@property (weak, nonatomic) IBOutlet UILabel *currentTempLabel;

@property (weak, nonatomic) IBOutlet UILabel *endTimeLabel;

@end

@implementation FSTPrecisionCookingStateReachingMinTimeViewController
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
    if (endTime)
    {
        self.circleProgressView.progressLayer.percent = [self calculatePercent:(self.targetMinTime - self.remainingHoldTime) toTime:self.targetMinTime];
    }
}

-(void) targetTimeChanged:(NSTimeInterval)minTime withMax:(NSTimeInterval)maxTime {
    [super targetTimeChanged:minTime withMax:maxTime];
}

-(void) updateLabels {
    [super updateLabels];
    
    UIFont* smallFont = [UIFont fontWithName:@"FSEmeric-Thin" size:22.0];
    NSDictionary* smallFontDict = [NSDictionary dictionaryWithObject:smallFont forKey:NSFontAttributeName];
  
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    double currentTemperature = self.currentTemp;
    NSMutableAttributedString *currentTempString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%0.0f %@", currentTemperature, @"\u00b0 F"] attributes: smallFontDict]; // with degrees fareinheit appended
    
    // set only once. when the remainingTime and targetMinTime has been set.
    if (!endTime && self.remainingHoldTime > 0 && self.targetMinTime > 0)
    {
        // want a constant target time that sets once
        endTime = [NSDate dateWithTimeIntervalSinceNow:(self.remainingHoldTime)*60];
    }

    [self.currentTempLabel setAttributedText:currentTempString];
    
    if (endTime) {
        [dateFormatter setDateFormat:@"h:mm a"]; //testing, removed an h
        [self.endTimeLabel setText:[dateFormatter stringFromDate:endTime]];
    }
}


@end
