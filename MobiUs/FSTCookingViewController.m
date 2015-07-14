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
NSObject* _cookModeChangedObserver;



- (void)viewDidLoad {
    [super viewDidLoad];
    
    __block ProgressState state = kPreheating; // should load a different layer in these states
    // this okay?
    self.navigationItem.hidesBackButton = true;
    
    __weak typeof(self) weakSelf = self;

    _cookingStage = (FSTParagonCookingStage*)(self.currentParagon.currentCookingMethod.session.paragonCookingStages[0]);

    NSString *cookingModelLabelText = [NSString stringWithFormat:@"%@ at %@%@", _cookingStage.cookingLabel, [_cookingStage.targetTemperature stringValue], @"\u00b0 F"];
    self.cookingModeLabel.text = cookingModelLabelText;
    [self.cookingModeLabel.superview bringSubviewToFront:self.cookingModeLabel]; // setting all labels to front
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    
    _temperatureChangedObserver = [center addObserverForName:FSTActualTemperatureChangedNotification
                                                      object:weakSelf.currentParagon
                                                       queue:nil
                                                  usingBlock:^(NSNotification *notification)
    {
        //um, do nothing right now view doesn't support anything
        //todo: remove ?
    }];
    
    _timeElapsedChangedObserver = [center addObserverForName:FSTActualTemperatureChangedNotification //???
                                                      object:weakSelf.currentParagon
                                                       queue:nil
                                                  usingBlock:^(NSNotification *notification)
    {
        weakSelf.circleProgressView.elapsedTime = [_cookingStage.cookTimeElapsed doubleValue]; // good way to test the circle is changing this value to visualize some proportion
        /*weakSelf.circleProgressView.startingTemp = 0.0;
        weakSelf.circleProgressView.targetTemp = 100.0;
        weakSelf.circleProgressView.currentTemp = 35.0; // should call set current temp, and set ticks in preheating stage*/
        //[weakSelf stateChanged:kCooking]; // hard coding
        //[weakSelf stateChanged:kSitting]; // for testing
       [weakSelf makeAndSetTimeRemainingLabel];

    }];
    
    _cookModeChangedObserver = [center addObserverForName:FSTCookModeChangedNotification
                                                   object:weakSelf.currentParagon
                                                    queue:nil
                                               usingBlock:^(NSNotification *notification)
                                {
                                    if(weakSelf.currentParagon.currentCookMode == kPARAGON_HEATING)
                                    { // ready to transition to cooking
                                        state = kCooking;
                                        [weakSelf stateChanged:state];
                                    }
                                }];
    
    _temperatureChangedObserver = [center addObserverForName:FSTActualTemperatureChangedNotification
                                                      object:weakSelf.currentParagon
                                                       queue:nil
                                                  usingBlock:^(NSNotification *notification)
                                   {
                                       NSNumber* actualTemperature = _cookingStage.actualTemperature;
                                       weakSelf.circleProgressView.currentTemp = [actualTemperature doubleValue]; // set the current temp of the paragon
                                   }];
    
    [self.circleProgressView.superview sendSubviewToBack:self.circleProgressView]; // needs to reposition behind lettering
    self.circleProgressView.timeLimit = [_cookingStage.cookTimeRequested doubleValue]; // set the value for reference with time elapsed
    self.circleProgressView.elapsedTime = 0; // elapsed time increments with cookingStage I suppose
    // set the temperature ranges
    self.circleProgressView.targetTemp = [_cookingStage.targetTemperature doubleValue];
    self.circleProgressView.startingTemp = 72; // was hard coded in preheating
    
#ifdef SIMULATE_PARAGON
    [self.currentParagon startSimulatingTimeWithTemperatureRegulating];
#endif

}

-(void)stateChanged:(ProgressState)state { // might include old state variable, or just use seperate methods for each case,

    switch (state) {
        case kPreheating:
        case kCooking:
        case kSitting: // something with labels, probably the transition phases, also set the initial values like starting/target temps
            break;
    }
    self.circleProgressView.layerState = state;
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
    
    [dateFormatter setDateFormat:@"hh:mm a"];
    self.doneAtLabel.text = [dateFormatter stringFromDate:timeComplete];
    [self.doneAtLabel.superview bringSubviewToFront:self.doneAtLabel];
    [self.timeRemainingLabel.superview bringSubviewToFront:self.timeRemainingLabel]; // pull labels before the circle
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)removeObservers
{
    [[NSNotificationCenter defaultCenter] removeObserver:_temperatureChangedObserver];
    [[NSNotificationCenter defaultCenter] removeObserver:_timeElapsedChangedObserver];
}

- (void)dealloc
{
    [self removeObservers];
}


- (IBAction)completeButtonTap:(id)sender
{
    UIAlertView *alert = [[UIAlertView alloc]
                                initWithTitle:@"Return to Main Menu"
                                message:@"Please turn off the burner on your unit to start a new session."
                                delegate:self cancelButtonTitle:@"" otherButtonTitles:@"OK", nil];
    
    alert.cancelButtonIndex = -1;
    [alert show];

}

#pragma mark - <UIAlertViewDelegate>

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}
@end

// Copyright belongs to original author
// http://code4app.net (en) http://code4app.com (cn)
// From the most professional code share website: Code4App.net
