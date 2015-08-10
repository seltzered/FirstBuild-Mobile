//
//  FSTCookingStatePreheatingViewController.m
//  FirstBuild
//
//  Created by John Nolan on 8/6/15.
//  Copyright (c) 2015 FirstBuild. All rights reserved.
//

#import "FSTCookingStatePreheatingViewController.h"
#import "FSTCookingStatePreheatingLayer.h"

@interface FSTCookingStatePreheatingViewController ()

@property (weak, nonatomic) IBOutlet UILabel *targetLabel;

@property (weak, nonatomic) IBOutlet UILabel *currentLabel;


@end

@implementation FSTCookingStatePreheatingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //[self.progressView layoutSubviews];
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSLog(@"%f, %f", self.progressView.frame.size.height, self.progressView.frame.size.width);
    

    //self.progressView.progressLayer = [[FSTCookingStatePreheatingLayer alloc] init];
}

-(void)viewWillLayoutSubviews
{
    [self.circleProgressView setupViewsWithLayerClass:[FSTCookingStatePreheatingLayer class]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) updatePercent {
    [super updatePercent];
    self.progressView.progressLayer.percent = [self calculatePercentWithTemp:self.currentTemp];
}

-(void) updateLabels {
    [super updateLabels];
    
    UIFont* smallFont = [UIFont fontWithName:@"FSEmeric-Thin" size:22.0];
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
