//
//  FSTPrecisionCookingStateReachingMaxTimeViewController.m
//  
//
//  Created by John Nolan on 8/6/15.
//
//

#import "FSTPrecisionCookingStateReachingMaxTimeViewController.h"
#import "FSTPrecisionCookingStateReachingMaxTimeLayer.h"

@interface FSTPrecisionCookingStateReachingMaxTimeViewController ()
@property (weak, nonatomic) IBOutlet UILabel *currentTempLabel;
@property (weak, nonatomic) IBOutlet UILabel *italicTimeLabel;

@end

@implementation FSTPrecisionCookingStateReachingMaxTimeViewController

NSDate* endMaxTime;

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

- (void)updatePercent {
    [super updatePercent];
    self.circleProgressView.progressLayer.percent = [self calculatePercent:(self.targetMaxTime - self.remainingHoldTime) toTime:self.targetMaxTime];
}

-(void)targetTimeChanged:(NSTimeInterval)minTime withMax:(NSTimeInterval)maxTime {
    [super targetTimeChanged:minTime withMax:maxTime];

}

-(void) updateLabels {
    [super updateLabels];
    
    UIFont* smallFont = [UIFont fontWithName:@"FSEmeric-Thin" size:22.0];
    NSDictionary* smallFontDict = [NSDictionary dictionaryWithObject:smallFont forKey:NSFontAttributeName];
    
    UIFont* boldFont = [UIFont fontWithName:@"FSEmeric-SemiBold" size:21.0];
    NSDictionary* boldFontDict = [NSDictionary dictionaryWithObject:boldFont forKey:NSFontAttributeName];
    
    UIFont* italicFont = [UIFont fontWithName:@"FSEmeric-CoreItalic" size:21.0];
    NSDictionary* italicFontDict = [NSDictionary dictionaryWithObject:italicFont forKey:NSFontAttributeName];
    
    NSMutableAttributedString* maxTimeNotice = [[NSMutableAttributedString alloc] initWithString:@"Food can stay in until " attributes:italicFontDict]; // string reporting the date food should be taken out

    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    // only when the elapsedTime and targetMinTime has been set.
    if (!endMaxTime && self.remainingHoldTime > 0 && self.targetMaxTime > 0)
    {
        endMaxTime = [NSDate dateWithTimeIntervalSinceNow:(self.remainingHoldTime)*60]; // want a constant target time that sets once
    }

    [dateFormatter setDateFormat:@"hh:mm a"];
    if (endMaxTime) {
        [maxTimeNotice appendAttributedString:[[NSAttributedString alloc] initWithString: [dateFormatter stringFromDate:endMaxTime] attributes:boldFontDict]];
    
        [self.italicTimeLabel setAttributedText:maxTimeNotice];
    }
    
    double currentTemperature = self.currentTemp;
    NSMutableAttributedString *currentTempString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%0.0f %@", currentTemperature, @"\u00b0 F"] attributes: smallFontDict]; // with degrees fareinheit appended
    [self.currentTempLabel setAttributedText:currentTempString];
    
}

@end
