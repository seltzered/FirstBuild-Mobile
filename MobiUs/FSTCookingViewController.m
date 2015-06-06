//
//  FSTCookingViewController.m
//  FirstBuild
//
//  Created by Myles Caley on 5/12/15.
//  Copyright (c) 2015 FirstBuild. All rights reserved.
//

//
//  ProgressViewController.m
//  CircularProgressControl
//
//  Created by Carlos Eduardo Arantes Ferreira on 22/11/14.
//  Copyright (c) 2014 Mobistart. All rights reserved.
//

#import "FSTCookingViewController.h"
#import "Session.h"

@interface FSTCookingViewController ()

@property (strong, nonatomic) NSTimer *timer;
@property (nonatomic) Session *session;
@end

@implementation FSTCookingViewController

FSTParagonCookingStage* _cookingStage;
NSObject* _temperatureChangedObserver;
NSObject* _timeElapsedChangedObserver;

- (void)viewDidLoad {
    [super viewDidLoad];
    _cookingStage = (FSTParagonCookingStage*)(self.currentParagon.currentCookingMethod.session.paragonCookingStages[0]);

    NSString *cookingModelLabelText = [NSString stringWithFormat:@"%@ at %@%@", _cookingStage.cookingLabel, [_cookingStage.targetTemperature stringValue], @"\u00b0 F"];
    self.cookingModeLabel.text = cookingModelLabelText;
    
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    
    _temperatureChangedObserver = [center addObserverForName:FSTActualTemperatureChangedNotification
                                                      object:self.currentParagon
                                                       queue:nil
                                                  usingBlock:^(NSNotification *notification)
    {
        //um, do nothing right now view doesn't support anything
        //todo: remove ?
    }];
    
    _timeElapsedChangedObserver = [center addObserverForName:FSTActualTemperatureChangedNotification
                                                      object:self.currentParagon
                                                       queue:nil
                                                  usingBlock:^(NSNotification *notification)
   {
       self.circleProgressView.elapsedTime = [_cookingStage.cookTimeElapsed doubleValue];
       [self makeAndSetTimeRemainingLabel];

   }];
    
    self.circleProgressView.timeLimit = [_cookingStage.cookTimeRequested doubleValue];
    self.circleProgressView.elapsedTime = 0;
    
    UIColor *tintColor = UIColorFromRGB(0xD43326);
    self.circleProgressView.tintColor = tintColor;
    self.circleProgressView.elapsedTime = 0;
    
#ifdef SIMULATE_PARAGON
    [self.currentParagon startSimulatingTimeWithTemperatureRegulating];
#endif

}

- (void)makeAndSetTimeRemainingLabel
{
    _cookingStage = (FSTParagonCookingStage*)(self.currentParagon.currentCookingMethod.session.paragonCookingStages[0]);

    //temperature label
    UIFont *bigFont = [UIFont fontWithName:@"PTSans-NarrowBold" size:50.0];
    NSDictionary *bigFontDict = [NSDictionary dictionaryWithObject: bigFont forKey:NSFontAttributeName];
    
    UIFont *medFont = [UIFont fontWithName:@"PTSans-NarrowBold" size:43.0];
    NSDictionary *medFontDict = [NSDictionary dictionaryWithObject: medFont forKey:NSFontAttributeName];
    
    UIFont *smallFont = [UIFont fontWithName:@"PTSans-NarrowBold" size:23.0];
    NSDictionary *smallFontDict = [NSDictionary dictionaryWithObject: smallFont forKey:NSFontAttributeName];
    
    double timeRemaining = [_cookingStage.cookTimeRequested doubleValue] - [_cookingStage.cookTimeElapsed doubleValue];
    int hour = timeRemaining / 60;
    int minutes = fmod(timeRemaining, 60.0);
    
    
    
    NSMutableAttributedString *hourString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%d",hour]  attributes: bigFontDict];
    NSMutableAttributedString *hourLabel = [[NSMutableAttributedString alloc] initWithString:@"H" attributes: smallFontDict];
    NSMutableAttributedString *colonLabel = [[NSMutableAttributedString alloc] initWithString:@":" attributes: medFontDict];
    NSMutableAttributedString *minuteString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%d",minutes]  attributes: bigFontDict];
    NSMutableAttributedString *minuteLabel = [[NSMutableAttributedString alloc] initWithString:@"MIN" attributes: smallFontDict];
    
    [hourString appendAttributedString:hourLabel];
    [hourString appendAttributedString:colonLabel];
    [hourString appendAttributedString:minuteString];
    [hourString appendAttributedString:minuteLabel];

    [self.timeRemainingLabel setAttributedText:hourString];
    
    //time complete label
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSDate* timeComplete = [[NSDate date] dateByAddingTimeInterval:timeRemaining*60];
    
    [dateFormatter setDateFormat:@"HH:mm a"];
    self.doneAtLabel.text = [dateFormatter stringFromDate:timeComplete];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

// Copyright belongs to original author
// http://code4app.net (en) http://code4app.com (cn)
// From the most professional code share website: Code4App.net
