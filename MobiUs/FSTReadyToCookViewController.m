//
//  FSTReadyToCookViewController.m
//  FirstBuild
//
//  Created by Myles Caley on 5/12/15.
//  Copyright (c) 2015 FirstBuild. All rights reserved.
//

#import "FSTReadyToCookViewController.h"
#import "UILabel+MultiLineAutoSize.h"
#import "FSTCookingViewController.h"

@interface FSTReadyToCookViewController ()


@end

@implementation FSTReadyToCookViewController

FSTParagonCookingStage* _cookingStage;
NSObject* _temperatureChangedObserver;


- (void)viewDidLoad {
    [super viewDidLoad];
    _cookingStage = (FSTParagonCookingStage*)(self.currentParagon.currentCookingMethod.session.paragonCookingStages[0]);
    
    // Do any additional setup after loading the view.
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    _temperatureChangedObserver = [center addObserverForName:FSTActualTemperatureChangedNotification
                                                      object:self.currentParagon
                                                       queue:nil
                                                  usingBlock:^(NSNotification *notification)
    {
        [self.actualTemperatureLabel setText:[_cookingStage.actualTemperature stringValue]];
    }];
                                   
}

-(void)viewWillAppear:(BOOL)animated
{
    //wrap bottom label
    [self.bottomLabel adjustFontSizeToFitMultiLine];
    
    //temperature label
    UIFont *boldFont = [UIFont fontWithName:@"PTSans-NarrowBold" size:22.0];
    NSDictionary *boldFontDict = [NSDictionary dictionaryWithObject: boldFont forKey:NSFontAttributeName];
    
    UIFont *labelFont = [UIFont fontWithName:@"PT Sans Narrow" size:18.0];
    NSDictionary *labelFontDict = [NSDictionary dictionaryWithObject: labelFont forKey:NSFontAttributeName];
    
    double totalMinutes =[_cookingStage.cookTimeRequested integerValue];
    int hour = totalMinutes / 60;
    int minutes = fmod(totalMinutes, 60.0);

    
    NSMutableAttributedString *hourString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%d",hour] attributes: boldFontDict];
    NSMutableAttributedString *hourLabel = [[NSMutableAttributedString alloc] initWithString:@"H : " attributes: labelFontDict];
    NSMutableAttributedString *minuteString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%d",minutes] attributes: boldFontDict];
    NSMutableAttributedString *minuteLabel = [[NSMutableAttributedString alloc] initWithString:@"MIN" attributes: labelFontDict];
    NSMutableAttributedString *separator = [[NSMutableAttributedString alloc] initWithString:@"  |  " attributes: boldFontDict];
    NSMutableAttributedString *temperature = [[NSMutableAttributedString alloc] initWithString:[_cookingStage.targetTemperature stringValue] attributes: boldFontDict];
    NSMutableAttributedString *degreeString = [[NSMutableAttributedString alloc] initWithString:@"\u00b0" attributes:boldFontDict];
    NSMutableAttributedString *temperatureLabel = [[NSMutableAttributedString alloc] initWithString:@" F" attributes: boldFontDict];
    
    [hourString appendAttributedString:hourLabel];
    [hourString appendAttributedString:minuteString];
    [hourString appendAttributedString:minuteLabel];
    [hourString appendAttributedString:separator];
    [hourString appendAttributedString:temperature];
    [hourString appendAttributedString:degreeString];
    [hourString appendAttributedString:temperatureLabel];
    
    [self.tempLabel setAttributedText:hourString];
    [self.cookingLabel setText:_cookingStage.cookingLabel];
    
    [self.actualTemperatureLabel setText:[_cookingStage.actualTemperature stringValue]];
#ifdef SIMULATE_PARAGON
    [self.currentParagon setSimulatorHeatingUpdateInterval:3000];
    [self.currentParagon setSimulatorHeatingTemperatureIncrement:1];
#endif
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    [[NSNotificationCenter defaultCenter] removeObserver:_temperatureChangedObserver];
    if ([segue.destinationViewController isKindOfClass:[FSTCookingViewController class]])
    {
        ((FSTCookingViewController*)segue.destinationViewController).currentParagon = self.currentParagon;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)continueButtonTap:(id)sender {
    [self performSegueWithIdentifier:@"segueCooking" sender:self];
}


@end
