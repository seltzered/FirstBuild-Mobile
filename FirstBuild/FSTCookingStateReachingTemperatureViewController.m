//
//  FSTCookingStateReachingTemperatureViewController.m
//  FirstBuild
//
//  Created by John Nolan on 8/6/15.
//  Copyright (c) 2015 FirstBuild. All rights reserved.
//

#import "FSTCookingStateReachingTemperatureViewController.h"
#import "FSTCookingStateReachingTemperatureLayer.h"

@interface FSTCookingStateReachingTemperatureViewController ()

@property (weak, nonatomic) IBOutlet UILabel *targetLabel;

@property (weak, nonatomic) IBOutlet UILabel *currentLabel;

@property (weak, nonatomic) IBOutlet UILabel *preheatingLabel;


@end

@implementation FSTCookingStateReachingTemperatureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

-(void)viewWillLayoutSubviews
{
     [self.circleProgressView setupViewsWithLayerClass:[FSTCookingStateReachingTemperatureLayer class]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) updatePercent {
    self.circleProgressView.progressLayer.percent = [self calculatePercentWithTemp:self.currentTemp];
}

-(void) updateLabels {
    [super updateLabels];
    
    if (self.circleProgressView.progressLayer.percent >= 0) {
        self.preheatingLabel.textColor = UIColorFromRGB(0xF0663A);
        self.targetLabel.textColor = UIColorFromRGB(0xF0663A);
        self.currentLabel.textColor = UIColorFromRGB(0xF0663A);
    } else {
        self.preheatingLabel.textColor = [UIColor blueColor];
        self.targetLabel.textColor = [UIColor blueColor];
        self.currentLabel.textColor = [UIColor blueColor];
    }
    
    UIFont* smallFont = [UIFont fontWithName:@"FSEmeric-Thin" size:22.0]; // temporary, need to figure out the regular font
    NSDictionary* smallFontDict = [NSDictionary dictionaryWithObject:smallFont forKey:NSFontAttributeName];
    
    UIFont* bigFont = [UIFont fontWithName:@"FSEmeric-SemiBold" size:44.0];
    NSDictionary* bigFontDict = [NSDictionary dictionaryWithObject:bigFont forKey:NSFontAttributeName];

    double currentTemperature = self.currentTemp;
    NSMutableAttributedString *currentTempString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%0.0f %@", currentTemperature, @"\u00b0 F"] attributes: bigFontDict]; // with degrees fareinheit appended
    
    double targetTemperature = self.targetTemp;
    NSMutableAttributedString *targetTempString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"Target: %0.0f %@", targetTemperature, @"\u00b0 F"] attributes: smallFontDict];
    
    [self.targetLabel setAttributedText:targetTempString];
    [self.currentLabel setAttributedText:currentTempString];
}

@end
