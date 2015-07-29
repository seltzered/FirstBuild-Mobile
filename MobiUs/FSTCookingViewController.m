//
//  FSTCookingViewController.m
//  FirstBuild
//
//  Created by Myles Caley on 5/12/15.
//  Copyright (c) 2015 FirstBuild. All rights reserved.
//



//        HIERARCHY
//        +------------------------------------+
//        | FSTCookingViewController           |
//        |  +-------------------------------+ |
//        |  | FSTCookingProgressView        | |
//        |  | +---------------------------+ | |
//        |  | | FSTCookingProgressLayer   | | |
//        |  | |                           | | |
//        |  | |                           | | |
//        |  | |                           | | |
//        |  | |                           | | |
//        |  | |                           | | |
//        |  | |                           | | |
//        |  | +---------------------------+ | |
//        |  +-------------------------------+ |
//        +------------------------------------+
//
//        There are multiple states for the view
//                                                                      
//        VIEW STATES
//        +-------------------------------------------------------+
//        |                                                       |
//        |  +--------+  +---------+ +----------+  +-----------+  |
//        |  |preheat |  |ready    | |cooking   |  |done       |  |
//        |  |        |  |         | |          |  |           |  |
//        |  +--------+  +---------+ +----------+  +-----------+  |
//        |                                                       |
//        +-------------------------------------------------------+
//
//
//        BURNER STATE
//        +-------------------------------------------------------+
//        | PREHEAT     | SOUSVIDE                                |
//        +-------------------------------------------------------+
//                                                                      
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
#import "MobiNavigationController.h"

@interface FSTCookingViewController ()

@property (weak, nonatomic) IBOutlet FSTStageBarView *stageBar;

@property (weak, nonatomic) IBOutlet FSTStageCircleView *stageCircle;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *stageCirclePlace;
@property (strong, nonatomic) NSTimer *timer;
@property (nonatomic) Session *session;

@end

@implementation FSTCookingViewController

FSTParagonCookingStage* _cookingStage;
NSObject* _temperatureChangedObserver;
NSObject* _timeElapsedChangedObserver;
NSObject* _cookModeChangedObserver;
NSObject* _cookingTimeWriteConfirmationObserver;
NSObject* _targetTemperatureChangedObserver;

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.hidesBackButton = true;
    
    __weak typeof(self) weakSelf = self;

    _cookingStage = (FSTParagonCookingStage*)(self.currentParagon.currentCookingMethod.session.paragonCookingStages[0]);
    
    [self.cookingModeLabel.superview bringSubviewToFront:self.cookingModeLabel]; // setting all labels to front
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    
    _timeElapsedChangedObserver = [center addObserverForName:FSTElapsedTimeChangedNotification
                                                      object:weakSelf.currentParagon
                                                       queue:nil
                                                  usingBlock:^(NSNotification *notification)
    {
        weakSelf.cookingProgressView.elapsedTime = [_cookingStage.cookTimeElapsed doubleValue];
       [weakSelf makeAndSetTimeRemainingLabel];

    }];
    
    _cookingTimeWriteConfirmationObserver = [center addObserverForName:FSTCookTimeSetNotification
                                                   object:weakSelf.currentParagon
                                                    queue:nil
                                               usingBlock:^(NSNotification *notification)
    {
        weakSelf.progressState = kCooking;
    }];
    
    _cookModeChangedObserver = [center addObserverForName:FSTCookModeChangedNotification
                                                   object:weakSelf.currentParagon
                                                    queue:nil
                                               usingBlock:^(NSNotification *notification)
    {
        //if we are currently on the progress state of the view and we receive
        //a notification that the cooking mode has switched to heating then
        //transistion to the ready to cook progress state
        if(weakSelf.currentParagon.currentCookMode == kPARAGON_HEATING && weakSelf.progressState == kPreheating)
        { // the cooktop has finished preheating to begin heating, and the progress bar was in its preheating state. Ensures that the ready to cook appears once in a cycle
            // ready to transition to cooking
            weakSelf.progressState = kReadyToCook;
        }
        else if (weakSelf.currentParagon.currentCookMode == kPARAGON_OFF)
        {
            [weakSelf.navigationController popToRootViewControllerAnimated:YES];
        }
        else
        {
            DLog(@"cook mode changed, nothing to do");
        }
    }];
    
    _temperatureChangedObserver = [center addObserverForName:FSTActualTemperatureChangedNotification
                                                      object:weakSelf.currentParagon
                                                       queue:nil
                                                  usingBlock:^(NSNotification *notification)
   {
       NSNumber* actualTemperature = _cookingStage.actualTemperature;
       weakSelf.cookingProgressView.currentTemp = [actualTemperature doubleValue];
       [weakSelf makeAndSetTimeRemainingLabel];
   }];
    
    _targetTemperatureChangedObserver = [center addObserverForName:FSTTargetTemperatureChangedNotification
                                                      object:weakSelf.currentParagon
                                                       queue:nil
                                                  usingBlock:^(NSNotification *notification)
   {
       NSNumber* targetTemperature = _cookingStage.targetTemperature;
       weakSelf.cookingProgressView.targetTemp = [targetTemperature doubleValue];
       NSString *cookingModelLabelText = [NSString stringWithFormat:@"%@%@", [_cookingStage.targetTemperature stringValue], @"\u00b0 F"];
       self.cookingModeLabel.text = cookingModelLabelText;
   }];

    // needs to reposition behind lettering
    [self.cookingProgressView.superview sendSubviewToBack:self.cookingProgressView];
    
    self.cookingProgressView.timeLimit = [_cookingStage.cookTimeRequested doubleValue]; // set the value for reference with time elapsed
    self.cookingProgressView.elapsedTime = 0;  // elapsed time increments with cookingStage I suppose
    self.cookingProgressView.targetTemp =[_cookingStage.targetTemperature doubleValue];
    self.cookingProgressView.startingTemp = 72; // was hard coded in preheating
    [self makeAndSetTimeRemainingLabel];
}

-(void)viewWillAppear:(BOOL)animated {
    MobiNavigationController* controller = (MobiNavigationController*)self.navigationController;
    [controller setHeaderText:@"ACTIVE" withFrameRect:CGRectMake(0, 0, 120, 30)];
}

-(void)viewDidAppear:(BOOL)animated {
    [self updateStageBarForState:self.progressState]; // set top bar to current global state
}

//-(void)stateChanged:(ProgressState)state { //might include old state variable, or just use seperate methods for each case,
-(void)setProgressState:(ProgressState)state { // might just make a setter here
    _progressState = state; // wasn't actually setting the value
    
    self.continueButton.userInteractionEnabled = YES;
    
    [self updateStageBarForState:state];
    [self makeAndSetTimeRemainingLabel];
    self.cookingProgressView.layerState = state; // set state of whole child view
}

-(void)updateStageBarForState:(ProgressState)state { // this could be scrapped soon
    [self.stageBar setCircleState:state];
}

/*- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    [self.stageBar drawRect:CGRectMake(0, 0, size.width, size.height)];
    [self updateStageBarForState:self.progressState];
} // trying to update lineWidth on rotation
*/
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
    NSMutableAttributedString *currentTempString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%0.0f %@", currentTemperature, @"\u00b0 F"] attributes: smallFontDict]; // with degrees fareinheit appended
    
    double targetTemperature = [_cookingStage.targetTemperature doubleValue];
    NSMutableAttributedString *targetTempString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%0.0f %@", targetTemperature, @"\u00b0 F"] attributes: smallFontDict];
    
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
    self.topCircleLabel.hidden = false;
    self.boldOverheadLabel.hidden = false;
    self.boldLabel.hidden = false; // the default for each case
    self.instructionImage.hidden = true;
    self.continueButton.hidden = true;// default not visible
    NSMutableAttributedString* topString = [[NSMutableAttributedString alloc] initWithString:@"Target: "]; // for preheating case
    [topString appendAttributedString:targetTempString];
    
    switch (self.progressState) {

        case kPreheating: // need to change text above number labels as well
            [self.cookingStatusLabel setText:@"PREHEATING"];
            [self.topCircleLabel setAttributedText:topString]; // target label before target temperature
            [self.boldOverheadLabel setText:@"Current:"];
            [self.boldLabel setAttributedText:currentTempString];
            break;
        case kReadyToCook:
            [self.cookingStatusLabel setText:@"READY TO COOK"];
            self.topCircleLabel.hidden = true;
            self.boldLabel.hidden = true;
            self.boldOverheadLabel.hidden = true;
            self.instructionImage.hidden = false;
            self.continueButton.hidden = false;
            break;
        case kCooking:
            [self.cookingStatusLabel setText:@"COOKING"];
            [self.topCircleLabel setAttributedText:currentTempString];
            [dateFormatter setDateFormat:@"hh:mm a"];
            [self.boldOverheadLabel setText:@"Food Will Be Done By:"];
            self.boldLabel.text = [dateFormatter stringFromDate:timeComplete];
            break;
        case kSitting:
            //TODO still need the maximum time to set the targetLabel, and the labels should change
            [self.cookingStatusLabel setText:@"DONE"];
            [self.topCircleLabel setAttributedText:currentTempString];
            [self.boldOverheadLabel setText:@"Take Food Out"];
            [self.boldLabel setText:@"NOW"];
            // set the instruction image as well with taking out png
            break;
        default:
            break;
    }
    
    //[self.topCircleLabel.superview bringSubviewToFront:self.topCircleLabel];
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
    [[NSNotificationCenter defaultCenter] removeObserver:_cookModeChangedObserver];
    [[NSNotificationCenter defaultCenter] removeObserver:_cookingTimeWriteConfirmationObserver];
    [[NSNotificationCenter defaultCenter] removeObserver:_targetTemperatureChangedObserver];
}

- (void)dealloc
{
    [self removeObservers];
}

- (IBAction)continueButtonTap:(id)sender {
    self.continueButton.userInteractionEnabled = NO;
    [self.currentParagon setCookingTime:_cookingStage.cookTimeRequested];
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
