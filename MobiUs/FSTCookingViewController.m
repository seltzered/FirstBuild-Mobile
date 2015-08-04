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
#import "FSTRevealViewController.h"

@interface FSTCookingViewController ()

@property (weak, nonatomic) IBOutlet FSTStageBarView *stageBar;

@property (strong, nonatomic) NSTimer *timer;
@property (nonatomic) Session *session;

@end

@implementation FSTCookingViewController

//FSTParagonCookingStage* _cookingStage;
NSObject* _temperatureChangedObserver;
NSObject* _timeElapsedChangedObserver;
NSObject* _cookModeChangedObserver;
NSObject* _cookingTimeWriteConfirmationObserver;
NSObject* _elapsedTimeWriteConfirmationObserver;
NSObject* _targetTemperatureChangedObserver;

BOOL gotWriteResponseForCookTime;
BOOL gotWriteResponseForElapsedTime;


- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.hidesBackButton = YES;
    gotWriteResponseForCookTime = NO;
    gotWriteResponseForElapsedTime = NO;
    
    __weak typeof(self) weakSelf = self;
    __block FSTParagonCookingStage* _currentCookingStage = (FSTParagonCookingStage*)(self.currentParagon.currentCookingMethod.session.paragonCookingStages[0]);
    
    [self.cookingModeLabel.superview bringSubviewToFront:self.cookingModeLabel]; // setting all labels to front
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    
    _timeElapsedChangedObserver = [center addObserverForName:FSTElapsedTimeChangedNotification
                                                      object:weakSelf.currentParagon
                                                       queue:nil
                                                  usingBlock:^(NSNotification *notification)
    {
        weakSelf.cookingProgressView.elapsedTime = [_currentCookingStage.cookTimeElapsed doubleValue];
       [weakSelf updateLabels];
    }];
    
    _cookingTimeWriteConfirmationObserver = [center addObserverForName:FSTCookTimeSetNotification
                                                   object:weakSelf.currentParagon
                                                    queue:nil
                                               usingBlock:^(NSNotification *notification)
    {
        gotWriteResponseForCookTime = YES;
        [self checkReadyToTransitionToCooking];
    }];
    
    _elapsedTimeWriteConfirmationObserver = [center addObserverForName:FSTElapsedTimeSetNotification
                                                                object:weakSelf.currentParagon
                                                                 queue:nil
                                                            usingBlock:^(NSNotification *notification)
     {
         gotWriteResponseForElapsedTime = YES;
         [self checkReadyToTransitionToCooking];
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
        if(weakSelf.currentParagon.currentCookMode == kPARAGON_HEATING && weakSelf.progressState == kPreheating)
        {
            //if we are currently on the progress state of the view and we receive
            //a notification that the cooking mode has switched to heating then
            //transistion to the ready to cook progress state
            // the cooktop has finished preheating to begin heating, and the progress bar was in its preheating state. Ensures that the ready to cook appears once in a cycle
            // ready to transition to cooking
            weakSelf.progressState = kReadyToCook;
        }
        else if (weakSelf.currentParagon.currentCookMode == kPARAGON_OFF)
        {
            //burner was shutoff transition back to the products screen
            [weakSelf.navigationController popToRootViewControllerAnimated:YES];
        }
        else if( weakSelf.currentParagon.currentCookMode == kPARAGON_HEATING && [_currentCookingStage.cookTimeElapsed doubleValue] >= [_currentCookingStage.cookTimeMaximum doubleValue] )
        {
            //the elapsed time has surpassed the maximum time, we need to move to the final screen
            weakSelf.progressState = kDone;
        }
        else if( weakSelf.currentParagon.currentCookMode == kPARAGON_HEATING && [_currentCookingStage.cookTimeElapsed doubleValue] > [_currentCookingStage.cookTimeMinimum doubleValue] )
        {
            //the elapsed time is greater the minimum time (..and less than max) so we are in the sitting stage, waiting to reach the maximum time
            weakSelf.progressState = kSitting;
        }
        else
        {
            DLog(@"cook mode (burner) changed, nothing to do");
        }
    }];
    
    _temperatureChangedObserver = [center addObserverForName:FSTActualTemperatureChangedNotification
                                                      object:weakSelf.currentParagon
                                                       queue:nil
                                                  usingBlock:^(NSNotification *notification)
   {
       NSNumber* actualTemperature = _currentCookingStage.actualTemperature;
       weakSelf.cookingProgressView.currentTemp = [actualTemperature doubleValue];
       [weakSelf updateLabels];
   }];
    
    _targetTemperatureChangedObserver = [center addObserverForName:FSTTargetTemperatureChangedNotification
                                                      object:weakSelf.currentParagon
                                                       queue:nil
                                                  usingBlock:^(NSNotification *notification)
   {
       NSNumber* targetTemperature = _currentCookingStage.targetTemperature;
       weakSelf.cookingProgressView.targetTemp = [targetTemperature doubleValue];
       NSString *cookingModelLabelText = [NSString stringWithFormat:@"%@%@", [_currentCookingStage.targetTemperature stringValue], @"\u00b0 F"];
       self.cookingModeLabel.text = cookingModelLabelText;
   }];

    // needs to reposition behind lettering
    [self.cookingProgressView.superview sendSubviewToBack:self.cookingProgressView];
    
    self.cookingProgressView.timeLimit = [_currentCookingStage.cookTimeMinimum doubleValue]; // set the value for reference with time elapsed
    self.cookingProgressView.elapsedTime = 0;  // elapsed time increments with cookingStage I suppose
    self.cookingProgressView.targetTemp =[_currentCookingStage.targetTemperature doubleValue];
    self.cookingProgressView.startingTemp = 72; // was hard coded in preheating
    [self updateLabels];
}

-(void)checkReadyToTransitionToCooking
{
    if (gotWriteResponseForElapsedTime && gotWriteResponseForCookTime)
    {
        self.progressState = kCooking;
    }
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
    [self updateLabels];
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
- (void)updateLabels
{
    FSTParagonCookingStage* _currentCookingStage = (FSTParagonCookingStage*)(self.currentParagon.currentCookingMethod.session.paragonCookingStages[0]);
    
    // create every label first
    //Fonts
    UIFont *bigFont = [UIFont fontWithName:@"PTSans-NarrowBold" size:50.0];
    NSDictionary *bigFontDict = [NSDictionary dictionaryWithObject: bigFont forKey:NSFontAttributeName];
    
    UIFont *medFont = [UIFont fontWithName:@"PTSans-NarrowBold" size:43.0];
    NSDictionary *medFontDict = [NSDictionary dictionaryWithObject: medFont forKey:NSFontAttributeName];
    
    UIFont *smallFont = [UIFont fontWithName:@"PTSans-NarrowBold" size:23.0];
    NSDictionary *smallFontDict = [NSDictionary dictionaryWithObject: smallFont forKey:NSFontAttributeName];
    
    // temperature labels (target temperature already at top with cooking mode
    double currentTemperature = [_currentCookingStage.actualTemperature doubleValue];
    NSMutableAttributedString *currentTempString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%0.0f %@", currentTemperature, @"\u00b0 F"] attributes: smallFontDict]; // with degrees fareinheit appended
    
    double targetTemperature = [_currentCookingStage.targetTemperature doubleValue];
    NSMutableAttributedString *targetTempString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%0.0f %@", targetTemperature, @"\u00b0 F"] attributes: smallFontDict];
    
    
    //time to complete label
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSDate* timeComplete;

    // change label settings for each case
    self.topCircleLabel.hidden = false;
    self.boldOverheadLabel.hidden = false;
    self.boldLabel.hidden = false; // the default for each case
    self.instructionImage.hidden = true;
    self.continueButton.hidden = true;// default not visible
    self.dividingLine.hidden = false;
    NSMutableAttributedString* topString = [[NSMutableAttributedString alloc] initWithString:@"Target: "]; // for preheating case
    [topString appendAttributedString:targetTempString];
    
    double timeRemaining;
    int hour;
    int minutes;
    
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
            self.dividingLine.hidden = true;
            break;
        case kCooking:
            timeRemaining = [_currentCookingStage.cookTimeMinimum doubleValue] - [_currentCookingStage.cookTimeElapsed doubleValue];
            hour = timeRemaining / 60;
            minutes = fmod(timeRemaining, 60.0);
            timeComplete = [[NSDate date] dateByAddingTimeInterval:timeRemaining*60];
            [self.cookingStatusLabel setText:@"COOKING"];
            [self.topCircleLabel setAttributedText:currentTempString];
            [dateFormatter setDateFormat:@"hh:mm a"];
            //TODO - update middle label, no bottom label
            [self.boldOverheadLabel setText:@"Food will be ready at"];
            self.boldLabel.text = [dateFormatter stringFromDate:timeComplete];
            break;
        case kSitting:
            timeRemaining = [_currentCookingStage.cookTimeMaximum doubleValue] - [_currentCookingStage.cookTimeElapsed doubleValue]; // We could also calculate this in the notifications
            hour = timeRemaining / 60;
            minutes = fmod(timeRemaining, 60.0);
            timeComplete = [[NSDate date] dateByAddingTimeInterval:timeRemaining*60];
            [self.cookingStatusLabel setText:@"DONE"];
            [self.topCircleLabel setAttributedText:currentTempString];
            [self.boldOverheadLabel setText:@"Food can stay in until "];
            self.boldLabel.text = [dateFormatter stringFromDate:timeComplete];
        case kDone:
            timeRemaining = [_currentCookingStage.cookTimeMaximum doubleValue] - [_currentCookingStage.cookTimeElapsed doubleValue];
            hour = timeRemaining / 60;
            minutes = fmod(timeRemaining, 60.0);
            timeComplete = [[NSDate date] dateByAddingTimeInterval:timeRemaining*60];
            [self.cookingStatusLabel setText:@"DONE"];
            [self.topCircleLabel setAttributedText:currentTempString];
            [self.boldOverheadLabel setText:@"TAKE FOOD OUT"];
            [self.boldLabel setText:@"NOW"];
            //TODO set the instruction image as well with taking out png, also hide some other views, set bottom label
            self.dividingLine.hidden = true;
            break;
        default:
            break;
    }
    
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
    [[NSNotificationCenter defaultCenter] removeObserver:_elapsedTimeWriteConfirmationObserver];
    [[NSNotificationCenter defaultCenter] removeObserver:_targetTemperatureChangedObserver];
}

- (void)dealloc
{
    [self removeObservers];
}

- (IBAction)continueButtonTap:(id)sender {
    self.continueButton.userInteractionEnabled = NO;
    FSTParagonCookingStage* _cookingStage = (FSTParagonCookingStage*)(self.currentParagon.toBeCookingMethod.session.paragonCookingStages[0]);
    [self.currentParagon setCookingTimesStartingWithMinimumTime:_cookingStage.cookTimeMinimum goingToMaximumTime:_cookingStage.cookTimeMaximum];
}
- (IBAction)menuToggleTapped:(id)sender {
    [self.revealViewController rightRevealToggle:self.currentParagon];
}

#pragma mark - <UIAlertViewDelegate>

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}
@end
