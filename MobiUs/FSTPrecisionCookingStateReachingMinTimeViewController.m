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

- (void)viewDidLoad {
    [super viewDidLoad];
    self.progressView.progressLayer = [[FSTPrecisionCookingStateReachingMinTimeLayer alloc] init];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) updatePercent {
    [super updatePercent];
    self.progressView.progressLayer.percent = [self calculatePercent:self.elapsedTime toTime:self.targetTime];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

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
    
    double timeRemaining = self.targetTime - self.elapsedTime; // the min time required (set through a delegate method) minus the elapsed time to find when the stage will end
    //int hour = timeRemaining / 60;
    //int minutes = fmod(timeRemaining, 60.0);
    
    timeComplete = [[NSDate date] dateByAddingTimeInterval:timeRemaining*60];
    [self.currentTempLabel setAttributedText:currentTempString];
    [dateFormatter setDateFormat:@"hh:mm a"];
    self.endTimeLabel.text = [dateFormatter stringFromDate:timeComplete];
}


@end
