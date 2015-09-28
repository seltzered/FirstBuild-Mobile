//
//  FSTCookingViewController.m
//  FirstBuild
//
//  Created by Myles Caley on 5/12/15.
//  Copyright (c) 2015 FirstBuild. All rights reserved.
//

#import "FSTCookingViewController.h"
#import "Session.h"
#import "FSTStateBarView.h"
#import "FSTStateCircleView.h"
#import "MobiNavigationController.h"
#import "FSTRevealViewController.h"
#import "FSTCookingStateViewController.h"
#import "FSTContainerViewController.h"
#import "FSTSavedDisplayRecipeViewController.h"
#import "FSTSousVideRecipe.h"
#import "FSTMultiStageRecipe.h"

@interface FSTCookingViewController ()

@property (weak, nonatomic) IBOutlet FSTStateBarView *stageBar;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *popOutConstraint;
// this constant holds it against the side or protrudes it
@property (strong, nonatomic) NSTimer *timer;
@property (nonatomic) Session *session;

@end

@implementation FSTCookingViewController
{
    NSObject* _temperatureChangedObserver;
    NSObject* _timeElapsedChangedObserver;
    NSObject* _cookModeChangedObserver;
    NSObject* _targetTemperatureChangedObserver;
    //NSObject* _cookTimeChangedObserver;
    NSObject* _holdTimerSetObserver;
    NSObject* _currentCookStageChangedObserver;
    NSObject* _cookConfigurationChangedObserver;
    
    BOOL popped_out;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.hidesBackButton = YES;
    self.continueButton.hidden = YES;
    popped_out = NO;
    
    [self transitionToCurrentCookMode];
    [self setupEventHandlers];
    
    [self setStageBarStateCountForState:self.currentParagon.session.currentStage];
    
}


-(void)viewWillAppear:(BOOL)animated {
    MobiNavigationController* controller = (MobiNavigationController*)self.navigationController;
    [controller setHeaderText:@"ACTIVE" withFrameRect:CGRectMake(0, 0, 120, 30)];
}

-(void)setupEventHandlers
{
    __weak typeof(self) weakSelf = self;
//    __block FSTParagonCookingStage* _currentCookingStage = (FSTParagonCookingStage*)(self.currentParagon.session.currentStage);
    
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    
    //time elapsed
    _timeElapsedChangedObserver = [center addObserverForName:FSTElapsedTimeChangedNotification
                                                      object:weakSelf.currentParagon
                                                       queue:nil
                                                  usingBlock:^(NSNotification *notification)
    {
       [weakSelf.delegate elapsedTimeChanged:[weakSelf.currentParagon.session.currentStageCookTimeElapsed doubleValue]]; // set the elapsed time of whatever current segue
    }];
    
    //hold timer has started -- TODO: remove?
    _holdTimerSetObserver = [center addObserverForName:FSTHoldTimerSetNotification object:weakSelf.currentParagon queue:nil usingBlock:^(NSNotification *notification)
    {
        [weakSelf.delegate targetTimeChanged:[self.currentParagon.session.currentStage.cookTimeMinimum doubleValue] withMax:[self.currentParagon.session.currentStage.cookTimeMaximum doubleValue]];
    }];
    
    //cook stage changed, which contains all the information about the current session
    _currentCookStageChangedObserver = [center addObserverForName:FSTCurrentCookStageChangedNotification object:weakSelf.currentParagon.session queue:nil usingBlock:^(NSNotification * _Nonnull note) {
        [weakSelf.delegate targetTimeChanged:[self.currentParagon.session.currentStage.cookTimeMinimum doubleValue] withMax:[self.currentParagon.session.currentStage.cookTimeMaximum doubleValue]];
    }];
    
    _cookConfigurationChangedObserver = [center addObserverForName:FSTCookConfigurationChangedNotification object:weakSelf.currentParagon queue:nil usingBlock:^(NSNotification * _Nonnull note) {
        [weakSelf.delegate targetTimeChanged:[self.currentParagon.session.currentStage.cookTimeMinimum doubleValue] withMax:[self.currentParagon.session.currentStage.cookTimeMaximum doubleValue]];
    }];

    
    //TODO: GE Cooktop
    //    _cookTimeChangedObserver = [center addObserverForName:FSTCookTimeSetNotification object:weakSelf.currentParagon queue:nil usingBlock:^(NSNotification *notification)
    //    {
    //        [weakSelf.delegate targetTimeChanged:[_currentCookingStage.cookTimeMinimum doubleValue] withMax:[_currentCookingStage.cookTimeMaximum doubleValue]];
    //    }];
    
    
    //cook mode
    _cookModeChangedObserver = [center addObserverForName:FSTCookingModeChangedNotification
                                                   object:weakSelf.currentParagon
                                                    queue:nil
                                               usingBlock:^(NSNotification *notification)
    {
        [weakSelf transitionToCurrentCookMode];
    }];
    
    //current temperature
    _temperatureChangedObserver = [center addObserverForName:FSTActualTemperatureChangedNotification
                                                      object:weakSelf.currentParagon
                                                       queue:nil
                                                  usingBlock:^(NSNotification *notification)
    {
       NSNumber* actualTemperature = self.currentParagon.session.currentProbeTemperature;
       [weakSelf.delegate currentTemperatureChanged:[actualTemperature doubleValue]];
    }];
    
    
    //target temperature
    _targetTemperatureChangedObserver = [center addObserverForName:FSTTargetTemperatureChangedNotification
                                                            object:weakSelf.currentParagon
                                                             queue:nil
                                                        usingBlock:^(NSNotification *notification)
     {
         NSNumber* targetTemperature = self.currentParagon.session.currentStage.targetTemperature;
         [weakSelf.delegate targetTemperatureChanged:[targetTemperature doubleValue]];
     }];
    
}

-(void)transitionToCurrentCookMode
{
    __weak typeof(self) weakSelf = self;
    __block FSTParagonCookingStage* _currentCookingStage = (FSTParagonCookingStage*)(self.currentParagon.session.currentStage);
    NSString* stateIdentifier = nil;
    
    switch (weakSelf.currentParagon.cookMode) {
        case FSTCookingStatePrecisionCookingReachingTemperature:
            stateIdentifier = @"preheatingStateSegue";
            weakSelf.continueButton.hidden = YES;
            
            //if we have a current cook time or a to-be recipe then we need the stage bar
            if (
                    weakSelf.currentParagon.session.toBeRecipe ||
                    [_currentCookingStage.cookTimeMinimum intValue] > 0
                )
            {
                weakSelf.stageBar.hidden = NO;
            }
            else
            {
                weakSelf.stageBar.hidden = YES;
            }
            break;
        case FSTCookingStatePrecisionCookingTemperatureReached:
            stateIdentifier = @"preheatingReachedStateSegue";
            weakSelf.continueButton.userInteractionEnabled = YES;
            weakSelf.continueButton.hidden = NO; // this should be hidden otherwise. What happens after it is pressed?
            weakSelf.stageBar.hidden = NO;
            break;
        case FSTCookingStatePrecisionCookingReachingMinTime:
            stateIdentifier = @"reachingMinStateSegue";
            weakSelf.continueButton.hidden = YES;
            weakSelf.stageBar.hidden = NO;
            break;
        case FSTCookingStatePrecisionCookingReachingMaxTime:
            stateIdentifier = @"reachingMaxStateSegue";
            weakSelf.continueButton.hidden = YES;
            weakSelf.stageBar.hidden = NO;
            break;
        case FSTCookingStatePrecisionCookingPastMaxTime:
            stateIdentifier = @"pastMaxStateSegue";
            weakSelf.continueButton.hidden = YES;
            weakSelf.stageBar.hidden = NO;
            break;
        case FSTCookingStatePrecisionCookingWithoutTime:
            stateIdentifier = @"withoutTimeStateSegue";
            weakSelf.continueButton.hidden = YES;
            weakSelf.stageBar.hidden = YES;
            break;
        case FSTCookingStateOff:
            stateIdentifier = nil;
            weakSelf.stageBar.hidden = YES;
            [weakSelf.navigationController popToRootViewControllerAnimated:NO];
            break;
        default:
            weakSelf.stageBar.hidden = YES;
            stateIdentifier = nil;
            break;
    }
    
    weakSelf.stageBar.circleState = weakSelf.currentParagon.cookMode;
    
    if (stateIdentifier)
    {
        [weakSelf.stateContainer segueToStateWithIdentifier:stateIdentifier sender:self.currentParagon];
    }
    else
    {
        DLog(@"unknown state in cook mode, or paragon was shut off");
    }
    
}

-(void)setStageBarStateCountForState: (FSTParagonCookingStage*) stage
{
    int stateCount = 1;
    
    if (stage.cookTimeMinimum && stage.cookTimeMinimum > 0)
    {
        stateCount++;
    }
    
    if (stage.cookTimeMaximum && stage.cookTimeMaximum > 0)
    {
        stateCount++;
    }
    
    if (stage.targetTemperature && stage.targetTemperature > 0)
    {
        stateCount++;
    }
    
    self.stageBar.numberOfStates = [NSNumber numberWithInt:stateCount];
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
    [[NSNotificationCenter defaultCenter] removeObserver:_holdTimerSetObserver];
    [[NSNotificationCenter defaultCenter] removeObserver:_targetTemperatureChangedObserver];
    [[NSNotificationCenter defaultCenter] removeObserver:_currentCookStageChangedObserver];
}

- (void)dealloc
{
    [self removeObservers];
}

- (IBAction)continueButtonTap:(id)sender {
    
    [self.currentParagon startTimerForCurrentStage];
    //TODO: GE COOKTOP[self.currentParagon setCookingTimesWithStage:self.currentParagon.session.toBeRecipe.paragonCookingStages[0]];
    
    //prevent double press, gets unset when it becomes visible again in transitionToCurrentCookMode
    self.continueButton.userInteractionEnabled = NO;
}

- (IBAction)recipeTabTapped:(id)sender {
    // tapped on orange view to po the recipe out
    if (popped_out) {
        self.popOutConstraint.constant = -17.0; // for some reason the trailing constraint appears this far offset.
        popped_out = NO;
    } else {
        self.popOutConstraint.constant = 5*self.view.frame.size.width/6;
        popped_out = YES;
    }
    [UIView animateWithDuration:0.5 animations:^(void) {
        [self.view layoutIfNeeded];
    }];
}

- (IBAction)menuToggleTapped:(id)sender {
    [self.revealViewController rightRevealToggle:self.currentParagon];
}

#pragma mark - segue

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // replaced this after it was commented out, segue also moved back to container
   if ([segue.identifier isEqualToString:@"containerSegue"])
   {
       FSTContainerViewController* containerVC = (FSTContainerViewController*)segue.destinationViewController;
       containerVC.paragon = self.currentParagon;
       //[containerVC segueToStateWithIdentifier:@"preheatingStateSegue" sender:self]; // a default for the initial transition
       self.stateContainer = containerVC;
   } else if ([segue.identifier isEqualToString:@"displayPopOut"]) {
       FSTSavedDisplayRecipeViewController* displayVC = (FSTSavedDisplayRecipeViewController*)segue.destinationViewController;
       displayVC.activeRecipe = self.currentParagon.session.toBeRecipe;
       displayVC.will_hide_cook = [NSNumber numberWithBool:YES]; // don't want them to select this and push on another cooking session.
       if ([self.currentParagon.session.toBeRecipe isKindOfClass:[FSTSousVideRecipe class]]) {
           displayVC.is_multi_stage = [NSNumber numberWithBool:NO];
       } else if ([self.currentParagon.session.toBeRecipe isKindOfClass:[FSTMultiStageRecipe class]]) {
           displayVC.is_multi_stage = [NSNumber numberWithBool:YES];
       } // this tells it what third view controller to load
       // I could just set is_multi_stage by checking the activeRecipe in the display Maybe that does not happen soon enough
   }
}

#pragma mark - <UIAlertViewDelegate>

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}


@end
