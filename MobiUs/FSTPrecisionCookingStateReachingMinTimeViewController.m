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

NSDate* endTime;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

/*- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.view addSubview:self.circleProgressView]; 
    NSLog(@"COOKING: %f, %f", self.circleProgressView.frame.size.height, self.circleProgressView.frame.size.width);
} */ // no need when the subview is already in the storyboard

- (void)viewWillLayoutSubviews {
    [self.circleProgressView setupViewsWithLayerClass:[FSTPrecisionCookingStateReachingMinTimeLayer class]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) updatePercent {
    [super updatePercent];
    self.circleProgressView.progressLayer.percent = [self calculatePercent:self.elapsedTime toTime:self.targetMinTime];
    //[self.circleProgressView.progressLayer drawPathsForPercent]; must be drawing since it changes
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void) targetTimeChanged:(NSTimeInterval)minTime withMax:(NSTimeInterval)maxTime {
    [super targetTimeChanged:minTime withMax:maxTime];
}

-(void) updateLabels {
    [super updateLabels];
    
    UIFont* smallFont = [UIFont fontWithName:@"FSEmeric-Thin" size:22.0];
    NSDictionary* smallFontDict = [NSDictionary dictionaryWithObject:smallFont forKey:NSFontAttributeName];
    
    UIFont* bigFont = [UIFont fontWithName:@"FSEmeric-SemiBold" size:40.0];
    NSDictionary* bigFontDict = [NSDictionary dictionaryWithObject:bigFont forKey:NSFontAttributeName];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSDate* timeComplete;
    
    double currentTemperature = self.currentTemp;
    NSMutableAttributedString *currentTempString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%0.0f %@", currentTemperature, @"\u00b0 F"] attributes: smallFontDict]; // with degrees fareinheit appended
    
    double timeRemaining = self.targetMinTime - self.elapsedTime; // the min time required (set through a delegate method) minus the elapsed time to find when the stage will end
    //int hour = timeRemaining / 60;
    //int minutes = fmod(timeRemaining, 60.0);
    if (!endTime) {
        endTime = [NSDate dateWithTimeIntervalSinceNow:(self.targetMinTime - self.elapsedTime)*60]; // want a constant target time that sets once
    }
    timeComplete = [[NSDate date] dateByAddingTimeInterval:timeRemaining*60];
    [self.currentTempLabel setAttributedText:currentTempString];
    [dateFormatter setDateFormat:@"h:mm a"]; //testing, removed an h
    [self.endTimeLabel setText:[dateFormatter stringFromDate:endTime]];//timeComplete]]; // end time does not reset when you return to the app, needs to stay on the probe no the view controller. Or it could update once when the screen appears
}


@end
