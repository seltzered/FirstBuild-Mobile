//
//  FSTCookingViewController.m
//  FirstBuild
//
//  Created by Myles Caley on 5/12/15.
//  Copyright (c) 2015 FirstBuild. All rights reserved.
//

#import "FSTCookingViewController.h"
#import "Session.h"
#import "FSTStageBarView.h"
#import "FSTStageCircleView.h"
#import "MobiNavigationController.h"
#import "FSTRevealViewController.h"
#import "FSTCookingStateViewController.h"
#import "FSTContainerViewController.h"

@interface FSTCookingViewController ()

@property (weak, nonatomic) IBOutlet FSTStageBarView *stageBar;

@property (strong, nonatomic) NSTimer *timer;
@property (nonatomic) Session *session;

@end

@implementation FSTCookingViewController

NSObject* _temperatureChangedObserver;
NSObject* _timeElapsedChangedObserver;
NSObject* _cookModeChangedObserver;
NSObject* _targetTemperatureChangedObserver;

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.hidesBackButton = YES;
    self.continueButton.hidden = YES;
    
    [self transitionToCurrentCookMode];
    [self setupEventHandlers];
}

-(void)setupEventHandlers
{
    __weak typeof(self) weakSelf = self;
    __block FSTParagonCookingStage* _currentCookingStage = (FSTParagonCookingStage*)(self.currentParagon.currentCookingMethod.session.paragonCookingStages[0]);
    
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    
    
    _timeElapsedChangedObserver = [center addObserverForName:FSTElapsedTimeChangedNotification
                                                      object:weakSelf.currentParagon
                                                       queue:nil
                                                  usingBlock:^(NSNotification *notification)
    {
       [weakSelf.delegate elapsedTimeChanged:[_currentCookingStage.cookTimeElapsed doubleValue]]; // set the elapsed time of whatever current segue
    }];
    
    _cookModeChangedObserver = [center addObserverForName:FSTCookingModeChangedNotification
                                                   object:weakSelf.currentParagon
                                                    queue:nil
                                               usingBlock:^(NSNotification *notification)
    {
        [self transitionToCurrentCookMode];
    }];
    
    
    _temperatureChangedObserver = [center addObserverForName:FSTActualTemperatureChangedNotification
                                                      object:weakSelf.currentParagon
                                                       queue:nil
                                                  usingBlock:^(NSNotification *notification)
    {
       NSNumber* actualTemperature = _currentCookingStage.actualTemperature;
       [weakSelf.delegate currentTemperatureChanged:[actualTemperature doubleValue]];
    }];
    
    _targetTemperatureChangedObserver = [center addObserverForName:FSTTargetTemperatureChangedNotification
                                                            object:weakSelf.currentParagon
                                                             queue:nil
                                                        usingBlock:^(NSNotification *notification)
     {
         NSNumber* targetTemperature = _currentCookingStage.targetTemperature;
         [weakSelf.delegate targetTemperatureChanged:[targetTemperature doubleValue]];
     }];
}

-(void)transitionToCurrentCookMode
{
    __weak typeof(self) weakSelf = self;

    NSString* stateIdentifier = nil;
    
    switch (weakSelf.currentParagon.cookMode) {
        case FSTParagonCookingStatePrecisionCookingPreheating:
            stateIdentifier = @"preheatingStateSegue";
            weakSelf.continueButton.hidden = YES;
            break;
        case FSTParagonCookingStatePrecisionCookingPreheatingReached:
            stateIdentifier = @"preheatingReachedStateSegue";
            self.continueButton.userInteractionEnabled = YES;
            weakSelf.continueButton.hidden = NO; // this should be hidden otherwise. What happens after it is pressed?
            break;
        case FSTParagonCookingStatePrecisionCookingReachingMinTime:
            stateIdentifier = @"reachingMinStateSegue";
            weakSelf.continueButton.hidden = YES;
            break;
        case FSTParagonCookingStatePrecisionCookingReachingMaxTime:
            stateIdentifier = @"reachingMaxStateSegue";
            weakSelf.continueButton.hidden = YES;
            break;
        case FSTParagonCookingStatePrecisionCookingPastMaxTime:
            stateIdentifier = @"pastMaxStateSegue";
            weakSelf.continueButton.hidden = YES;
            break;
        case FSTParagonCookingStateOff:
            stateIdentifier = nil;
            [self.navigationController popToRootViewControllerAnimated:NO];
            break;
        default:
            stateIdentifier = nil;
            break;
    }
    
    if (stateIdentifier)
    {
        [weakSelf.stateContainer segueToStateWithIdentifier:stateIdentifier sender:self];
    }
    else
    {
        DLog(@"unknown state in cook mode, or paragon was shut off");
    }
    
}

-(void)viewWillAppear:(BOOL)animated {
    MobiNavigationController* controller = (MobiNavigationController*)self.navigationController;
    [controller setHeaderText:@"ACTIVE" withFrameRect:CGRectMake(0, 0, 120, 30)];
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
    [[NSNotificationCenter defaultCenter] removeObserver:_targetTemperatureChangedObserver];
}

- (void)dealloc
{
    [self removeObservers];
}

- (IBAction)continueButtonTap:(id)sender {

    //write the cooking time, once the cooktime is written to the paragon
    //the appropriate state will automatically update in FSTParagon and
    //then dispatch the corresponding state, which the cookModeChangeObserver will
    //pickup and transition to the correct embeded view
    FSTParagonCookingStage* _cookingStage = (FSTParagonCookingStage*)(self.currentParagon.toBeCookingMethod.session.paragonCookingStages[0]);
    
    //TODO: HACK TESTING
    _cookingStage.cookTimeMinimum = [NSNumber numberWithInt:2];
    _cookingStage.cookTimeMaximum = [NSNumber numberWithInt:4];
    //END TODO
    
    [self.currentParagon setCookingTimesStartingWithMinimumTime:_cookingStage.cookTimeMinimum goingToMaximumTime:_cookingStage.cookTimeMaximum];
    
    //prevent double press, gets unset when it becomes visible again in transitionToCurrentCookMode
    self.continueButton.userInteractionEnabled = NO;
}
     
- (IBAction)menuToggleTapped:(id)sender {
    [self.revealViewController rightRevealToggle:self.currentParagon];
}

#pragma mark - segue

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // replaced this after it was commented out, segue also moved back to container
   if ([segue.identifier isEqualToString:@"containerSegue"]) {
       FSTContainerViewController* containerVC = (FSTContainerViewController*)segue.destinationViewController;
       [containerVC segueToStateWithIdentifier:@"preheatingStateSegue" sender:self]; // a default for the initial transition
       self.stateContainer = containerVC;
   }
}

#pragma mark - <UIAlertViewDelegate>

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}


@end
