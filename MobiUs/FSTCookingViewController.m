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
#import "FSTStageBarView.h"
#import "FSTStageCircleView.h"

@interface FSTCookingViewController ()

@property (weak, nonatomic) IBOutlet FSTStageBarView *stageBar;

@property (weak, nonatomic) IBOutlet FSTStageCircleView *stageCircle;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *stageCirclePlace;

@property (nonatomic) ProgressState state;

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
    
    //__block ProgressState state = kPreheating; // should load a different layer in these states
    // this okay?
    //[self stateChanged:kPreheating];
    
    self.navigationItem.hidesBackButton = true;
    
    __weak typeof(self) weakSelf = self;

    _cookingStage = (FSTParagonCookingStage*)(self.currentParagon.currentCookingMethod.session.paragonCookingStages[0]);

    NSString *cookingModelLabelText = [NSString stringWithFormat:@"%@ at %@%@", _cookingStage.cookingLabel, [_cookingStage.targetTemperature stringValue], @"\u00b0 F"];
    self.cookingModeLabel.text = cookingModelLabelText;
    [self.cookingModeLabel.superview bringSubviewToFront:self.cookingModeLabel]; // setting all labels to front
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    
    _timeElapsedChangedObserver = [center addObserverForName:FSTElapsedTimeChangedNotification
                                                      object:weakSelf.currentParagon
                                                       queue:nil
                                                  usingBlock:^(NSNotification *notification)
    {
        weakSelf.circleProgressView.elapsedTime = [_cookingStage.cookTimeElapsed doubleValue];
       [weakSelf makeAndSetTimeRemainingLabel];

    }];
    
    _cookModeChangedObserver = [center addObserverForName:FSTCookModeChangedNotification
                                                   object:weakSelf.currentParagon
                                                    queue:nil
                                               usingBlock:^(NSNotification *notification)
                                {
                                    if(weakSelf.currentParagon.currentCookMode == kPARAGON_HEATING)
                                    { // ready to transition to cooking
                                    weakSelf.state = kCooking;
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
    self.circleProgressView.elapsedTime = 0;  // elapsed time increments with cookingStage I suppose
    // set the temperature ranges
    self.circleProgressView.targetTemp =[_cookingStage.targetTemperature doubleValue];
    self.circleProgressView.startingTemp = 72; // was hard coded in preheating
    [self makeAndSetTimeRemainingLabel];
    
#ifdef SIMULATE_PARAGON
    [self.currentParagon startSimulatingTimeWithTemperatureRegulating];
#endif

}

-(void)viewDidAppear:(BOOL)animated {
    [self updateStageBarForState:_state]; // set top bar to current global state
}

//-(void)stateChanged:(ProgressState)state { //might include old state variable, or just use seperate methods for each case,
-(void)setState:(ProgressState)state {
    _state = state;
    switch (state) {
        case kPreheating:
        case kReady:
        case kCooking:
        case kSitting: // something with labels, probably the transition phases, also set the initial values like starting/target temps
            break;
        default:
            NSLog(@"NO STATE SELECTED\n");
            break;
    }
    
    [self updateStageBarForState:state];
    self.circleProgressView.layerState = state; // set state of whole child view
}

-(void)updateStageBarForState:(ProgressState)state {
    CGFloat new_x = 0; // change x position of stageCircle
    CGFloat mid_x = self.stageBar.frame.size.width/2;
    CGFloat start_x = mid_x - self.stageBar.lineWidth/2; //start of bar
    switch (state) {
        case kPreheating:
            new_x = start_x; // beginning of bar
            break;
        // need a ready to cook stage for second point
        case kReady:
            new_x = start_x + self.stageBar.lineWidth/3;
            break;
        case kCooking:
            new_x = start_x + 2*self.stageBar.lineWidth/3;
            break;
        case kSitting:
            new_x = start_x + self.stageBar.lineWidth;
            break;
        default:
            NSLog(@"NO STATE FOR STAGE BAR\n");
            break;
    }
    self.stageCirclePlace.constant = new_x - self.stageCircle.frame.size.width/2; // update constraint, centered. Animate block here?
}
- (void)makeAndSetTimeRemainingLabel
{
    _cookingStage = (FSTParagonCookingStage*)(self.currentParagon.currentCookingMethod.session.paragonCookingStages[0]);
    
    // create every label first
    //Fonts
    UIFont *bigFont = [UIFont fontWithName:@"PTSans-NarrowBold" size:50.0];
    NSDictionary *bigFontDict = [NSDictionary dictionaryWithObject: bigFont forKey:NSFontAttributeName];
    
    UIFont *medFont = [UIFont fontWithName:@"PTSans-NarrowBold" size:43.0];
    NSDictionary *medFontDict = [NSDictionary dictionaryWithObject: medFont forKey:NSFontAttributeName];
    
    UIFont *smallFont = [UIFont fontWithName:@"PTSans-NarrowBold" size:23.0];
    NSDictionary *smallFontDict = [NSDictionary dictionaryWithObject: smallFont forKey:NSFontAttributeName];
    
    // temperature labels (target temperature already at top with cooking mode
    double currentTemperature = [_cookingStage.actualTemperature doubleValue];
    NSMutableAttributedString *currentTempString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%0.2f %@", currentTemperature, @"\u00b0 F"] attributes: bigFontDict]; // with degrees fareinheit appended
    
    double targetTemperature = [_cookingStage.targetTemperature doubleValue];
    NSMutableAttributedString *targetTempString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%0.2f %@", targetTemperature, @"\u00b0 F"] attributes: smallFontDict];
    
    double timeRemaining = [_cookingStage.cookTimeRequested doubleValue] - [_cookingStage.cookTimeElapsed doubleValue];
    int hour = timeRemaining / 60;
    int minutes = fmod(timeRemaining, 60.0);
    
    // create the time count down label (only shown during cooking or sitting states)
    NSMutableAttributedString *hourString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%d",hour]  attributes: bigFontDict];
    NSMutableAttributedString *hourLabel = [[NSMutableAttributedString alloc] initWithString:@"H" attributes: smallFontDict];
    NSMutableAttributedString *colonLabel = [[NSMutableAttributedString alloc] initWithString:@":" attributes: medFontDict];
    NSMutableAttributedString *minuteString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%d",minutes]  attributes: bigFontDict];
    NSMutableAttributedString *minuteLabel = [[NSMutableAttributedString alloc] initWithString:@"MIN" attributes: smallFontDict];
    
    [hourString appendAttributedString:hourLabel];
    [hourString appendAttributedString:colonLabel];
    [hourString appendAttributedString:minuteString];
    [hourString appendAttributedString:minuteLabel];
    
    //time to complete label
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSDate* timeComplete = [[NSDate date] dateByAddingTimeInterval:timeRemaining*60];

    // change label settings for each case
    self.topCircleLabel = false;
    self.boldOverheadLabel.hidden = false;
    self.boldLabel.hidden = false; // the default for each case
    self.instructionImage.hidden = true; // default not visible
    NSMutableAttributedString* topString = [[NSMutableAttributedString alloc] initWithString:@"Target: "]; // for preheating case
    [topString appendAttributedString:targetTempString];
    
    switch (_state) {

        case kPreheating: // need to change text above number labels as well
            [self.cookingStatusLabel setText:@"PREHEATING"];
            [self.topCircleLabel setAttributedText:topString]; // target label before target temperature
            //[self.currentLabel setAttributedText:currentTempString];
            [self.boldOverheadLabel setText:@"Current:"];
            [self.boldLabel setAttributedText:currentTempString];
            break;
        case kReady:
            [self.cookingModeLabel setText:@"READY TO COOK"];
            self.topCircleLabel.hidden = true;
            self.boldLabel.hidden = true;
            self.boldOverheadLabel.hidden = true;
            self.instructionImage.hidden = false;
            break;
        case kCooking:
            [self.cookingStatusLabel setText:@"COOKING"];
            [self.topCircleLabel setAttributedText:currentTempString];
            [dateFormatter setDateFormat:@"hh:mm a"];
            [self.boldOverheadLabel setText:@"Food Will Be Done By:"];
            self.boldLabel.text = [dateFormatter stringFromDate:timeComplete];
            break;
        case kSitting: // still need the maximum time to set the targetLabel, and the labels should change
            [self.cookingStatusLabel setText:@"DONE"];
            [self.topCircleLabel setAttributedText:currentTempString];
            [self.boldOverheadLabel setText:@"Take Food Out"];
            [self.boldLabel setText:@"NOW"];
            // set the instruction image as well with taking out png
            break;
        default:
            break;
    }
    
    [self.topCircleLabel.superview bringSubviewToFront:self.topCircleLabel];
    [self.boldLabel.superview bringSubviewToFront:self.boldLabel]; // pull labels before the circle // could change layers instead of hiding labels
    
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
