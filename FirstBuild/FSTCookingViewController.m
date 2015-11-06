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
    BOOL popped_out;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.currentParagon.delegate = self;

    self.navigationItem.hidesBackButton = YES;
    self.continueButton.hidden = YES;
    popped_out = NO;
    
    [self transitionToCurrentCookMode];
    [self setStageBarStateCountForState:self.currentParagon.session.currentStage];
}

-(void)viewWillAppear:(BOOL)animated {
    MobiNavigationController* controller = (MobiNavigationController*)self.navigationController;

    if (self.currentParagon.session.activeRecipe.paragonCookingStages.count > 1)
    {
        //TODO: hardcode stage for testing
        [controller setHeaderText:@"1" withFrameRect:CGRectMake(0, 0, 120, 30)];
    }
    else
    {
        [controller setHeaderText:@"ACTIVE" withFrameRect:CGRectMake(0, 0, 120, 30)];
    }
}

-(void)transitionToCurrentCookMode
{
    FSTParagonCookingStage* _currentCookingStage = (FSTParagonCookingStage*)(self.currentParagon.session.currentStage);
    NSString* stateIdentifier = nil;
    
    switch (self.currentParagon.cookMode) {
        case FSTCookingStatePrecisionCookingReachingTemperature:
            stateIdentifier = @"preheatingStateSegue";
            self.continueButton.hidden = YES;
            
            //if we have a current cook time or a to-be recipe then we need the stage bar
            if (
                    self.currentParagon.session.toBeRecipe ||
                    [_currentCookingStage.cookTimeMinimum intValue] > 0
                )
            {
                self.stageBar.hidden = NO;
            }
            else
            {
                self.stageBar.hidden = YES;
            }
            break;
        case FSTCookingStatePrecisionCookingTemperatureReached:
            stateIdentifier = @"preheatingReachedStateSegue";
            self.continueButton.userInteractionEnabled = YES;
            self.continueButton.hidden = NO; // this should be hidden otherwise. What happens after it is pressed?
            self.stageBar.hidden = NO;
            break;
        case FSTCookingStatePrecisionCookingReachingMinTime:
            stateIdentifier = @"reachingMinStateSegue";
            self.continueButton.hidden = YES;
            self.stageBar.hidden = NO;
            break;
        case FSTCookingStatePrecisionCookingReachingMaxTime:
            stateIdentifier = @"reachingMaxStateSegue";
            self.continueButton.hidden = YES;
            self.stageBar.hidden = NO;
            break;
        case FSTCookingStatePrecisionCookingPastMaxTime:
            stateIdentifier = @"pastMaxStateSegue";
            self.continueButton.hidden = YES;
            self.stageBar.hidden = NO;
            break;
        case FSTCookingStatePrecisionCookingWithoutTime:
            stateIdentifier = @"withoutTimeStateSegue";
            self.continueButton.hidden = YES;
            self.stageBar.hidden = YES;
            break;
        case FSTCookingDirectCooking:
            stateIdentifier = @"directStateSegue";
            self.continueButton.hidden = YES;
            self.stageBar.hidden = YES;
            break;
        case FSTCookingStateOff:
            stateIdentifier = nil;
            self.stageBar.hidden = YES;
            [self.navigationController popToRootViewControllerAnimated:NO];
            break;
        default:
            self.stageBar.hidden = YES;
            stateIdentifier = nil;
            break;
    }
    
    self.stageBar.circleState = self.currentParagon.cookMode;
    
    if (stateIdentifier)
    {
        [self.stateContainer segueToStateWithIdentifier:stateIdentifier sender:self.currentParagon];
    }
    else
    {
        DLog(@"unknown state in cook mode, or paragon was shut off");
    }
}

-(void)setStageBarStateCountForState: (FSTParagonCookingStage*) stage
{
    int stateCount = 1;
    
    if (stage.cookTimeMinimum && [stage.cookTimeMinimum intValue] > 0)
    {
        stateCount++;
    }
    
    if (stage.cookTimeMaximum && [stage.cookTimeMaximum intValue] > 0)
    {
        stateCount++;
    }
    
    if (stage.targetTemperature && [stage.targetTemperature intValue] > 0)
    {
        stateCount++;
    }
    
    self.stageBar.numberOfStates = [NSNumber numberWithInt:stateCount];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
   }
   else if ([segue.identifier isEqualToString:@"displayPopOut"])
   {
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

#pragma mark - <FSTParagonDelegate>

-(void)actualTemperatureChanged:(NSNumber *)temperature
{
    [self.delegate currentTemperatureChanged:[temperature doubleValue]];
}


- (void)holdTimerSet
{
    [self.delegate targetTimeChanged:[self.currentParagon.session.currentStage.cookTimeMinimum doubleValue] withMax:[self.currentParagon.session.currentStage.cookTimeMaximum doubleValue]];
}

- (void)cookModeChanged:(ParagonCookMode)cookMode
{
    [self transitionToCurrentCookMode];
}

-(void)currentPowerLevelChanged:(NSNumber *)powerLevel
{
    [self.delegate burnerLevelChanged:[powerLevel doubleValue]];
}

- (void)cookConfigurationChanged
{
    [self.delegate targetTimeChanged:[self.currentParagon.session.currentStage.cookTimeMinimum doubleValue] withMax:[self.currentParagon.session.currentStage.cookTimeMaximum doubleValue]];
}

- (void)currentStageIndexChanged:(NSNumber *)stage
{
    MobiNavigationController* controller = (MobiNavigationController*)self.navigationController;
    [controller setHeaderText:[stage stringValue] withFrameRect:CGRectMake(0, 0, 120, 30)];
    
    [self setStageBarStateCountForState:self.currentParagon.session.currentStage];
    [self.delegate targetTimeChanged:[self.currentParagon.session.currentStage.cookTimeMinimum doubleValue] withMax:[self.currentParagon.session.currentStage.cookTimeMaximum doubleValue]];
}

@end
