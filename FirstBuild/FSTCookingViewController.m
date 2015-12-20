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
    CookingStateModel* cookingData;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        cookingData = [CookingStateModel new];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.hidesBackButton = YES;
    self.continueButton.hidden = YES;
    popped_out = NO;
    
    self.currentParagon.delegate = self;
    [self transitionToCurrentCookMode];
    [self setStageBarStateCountForState:self.currentParagon.session.currentStage];

}

//TODO: Document
-(void)setRecipeStageInstructions
{
    FSTSavedRecipeManager* recipeManager = [FSTSavedRecipeManager sharedInstance];
    FSTRecipe* activeRecipeFromLocalDatabase = [recipeManager getRecipeForId:self.currentParagon.session.activeRecipe.recipeId];
    FSTParagonCookingStage* localDbStage;
    FSTParagonCookingStage* localDbNextStage;
    uint8_t trueIndex ;
    if (self.currentParagon.session.currentStageIndex==0)
    {
        trueIndex = 0;
    }
    else
    {
        trueIndex = self.currentParagon.session.currentStageIndex-1;
    }
    
    localDbStage = activeRecipeFromLocalDatabase.paragonCookingStages[trueIndex];
    
    if (trueIndex+1 < activeRecipeFromLocalDatabase.paragonCookingStages.count )
    {
        localDbNextStage = activeRecipeFromLocalDatabase.paragonCookingStages[trueIndex+1];
    }
    
    if (!localDbStage)
    {
        NSLog(@">>>>>>>>>> NO STAGE FOR THIS RECIPE IN DB <<<<<<<<<<<<<<<");
    }
    else
    {
        cookingData.directions = localDbStage.cookingLabel;
    }
    
    if (!localDbNextStage)
    {
        NSLog(@"no next stage available in order to set stage prep for next stage");
    }
    else
    {
        cookingData.stagePrep = localDbNextStage.cookingPrepLabel;
    }
}

-(void)viewWillAppear:(BOOL)animated {
    MobiNavigationController* controller = (MobiNavigationController*)self.navigationController;

    if (self.currentParagon.session.activeRecipe.paragonCookingStages.count > 1)
    {
        [controller setHeaderText:[NSString stringWithFormat:@"STAGE %d",self.currentParagon.session.currentStageIndex] withFrameRect:CGRectMake(0, 0, 120, 30)];
    }
    else
    {
        [controller setHeaderText:@"ACTIVE" withFrameRect:CGRectMake(0, 0, 120, 30)];
    }
}


-(void)transitionToCurrentCookMode
{
    NSString* stateIdentifier = nil;
    
    switch (self.currentParagon.session.cookMode) {
        case FSTCookingStatePrecisionCookingReachingTemperature:
            stateIdentifier = @"preheatingStateSegue";
            self.continueButton.hidden = YES;
            self.stageBar.hidden = NO;
//            if (
//                    [_currentCookingStage.cookTimeMinimum intValue] > 0 ||
//                    self.currentParagon.session.currentStage.targetTemperature > 0
//                )
//            {
//                self.stageBar.hidden = NO;
//            }
//            else
//            {
//                self.stageBar.hidden = YES;
//            }
            break;
            
        case FSTCookingStatePrecisionCookingTemperatureReached:
            if ([self.currentParagon.session.activeRecipe.recipeType intValue] == FSTRecipeTypeFirstBuildSousVide)
            {
                stateIdentifier = @"preheatingReachedStateSegue";
                self.continueButtonText.text = @"     CONTINUE";
            }
            else
            {
                self.continueButtonText.text = @"     START TIMER";
                stateIdentifier = @"preheatingNonSousVideReachedStateSegue";
            }
            
            self.continueButton.userInteractionEnabled = YES;
            self.continueButton.hidden = NO; // this should be hidden otherwise. What happens after it is pressed?
            self.stageBar.hidden = NO;
            break;
        case FSTCookingStatePrecisionCookingReachingMinTime:
            if ([self.currentParagon.session.activeRecipe.recipeType intValue] == FSTRecipeTypeFirstBuildMultiStage)
            {
                stateIdentifier = @"reachingMinNonSousVideStateSegue";
            }
            else
            {
                stateIdentifier = @"reachingMinStateSegue";
            }
            
            self.continueButton.hidden = YES;
            self.stageBar.hidden = NO;
            break;
        case FSTCookingStatePrecisionCookingCurrentStageDone:
            // small workaround here, when there is only one item in the stage table
            // the paragon is not incrementing the index
            if (
                    (self.currentParagon.session.currentStageIndex == self.currentParagon.session.activeRecipe.paragonCookingStages.count ||
                     self.currentParagon.session.currentStageIndex ==0)
                     &&
                    (self.currentParagon.session.cookMode == FSTCookingStatePrecisionCookingCurrentStageDone)
                )
            {
                // entire recipe is complete
                self.continueButtonText.text = @"     COMPLETE";
            }
            else
            {
                // only stage is complete
                self.continueButtonText.text = @"     DONE";
            }
            stateIdentifier = @"reachedMinTimeNonSousVideStateSegue";
            
            self.continueButton.userInteractionEnabled = YES;
            self.continueButton.hidden = NO;
            self.stageBar.hidden = NO;
            break;
        case FSTCookingStatePrecisionCookingReachingMaxTime:
            stateIdentifier = @"reachingMaxStateSegue";
            self.continueButton.hidden = YES;
            self.stageBar.hidden = NO;
            break;
        case FSTCookingStatePrecisionCookingPastMaxTime:
            self.continueButtonText.text = @"     COMPLETE";
            self.continueButton.userInteractionEnabled = YES;
            stateIdentifier = @"pastMaxStateSegue";
            self.continueButton.hidden = NO;
            self.stageBar.hidden = NO;
            break;
        case FSTCookingStatePrecisionCookingWithoutTime:
            stateIdentifier = @"withoutTimeStateSegue";
            self.continueButton.hidden = YES;
            //self.stageBar.hidden = YES;
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
    
    self.stageBar.circleState = self.currentParagon.session.cookMode;
    
    if (stateIdentifier)
    {
        [self.stateContainer segueToStateWithIdentifier:stateIdentifier sender:nil];
    }
    else
    {
        DLog(@"unknown state in cook mode, or paragon was shut off");
    }
}


-(void)setStageBarStateCountForState: (FSTParagonCookingStage*) stage
{
    if ([self.currentParagon.session.activeRecipe.recipeType intValue] == FSTRecipeTypeFirstBuildMultiStage)
    {
        self.stageBar.numberOfStates = @3;
    }
    else if (self.currentParagon.session.userSelectedCookMode == FSTParagonUserSelectedCookModeRemote)
    {
        self.stageBar.numberOfStates = @4;
    }
    else if (self.currentParagon.session.userSelectedCookMode == FSTParagonUserSelectedCookModeGentle||
             self.currentParagon.session.userSelectedCookMode == FSTParagonUserSelectedCookModeRapid)
    {
        self.stageBar.numberOfStates = @2;
    }
    else {
        self.stageBar.numberOfStates = @0;
    }
//    int stateCount = 1;
//    
//    if (stage.cookTimeMinimum && [stage.cookTimeMinimum intValue] > 0)
//    {
//        stateCount++;
//    }
//    
//    if (stage.cookTimeMaximum && [stage.cookTimeMaximum intValue] > 0)
//    {
//        stateCount++;
//    }
//    
//    if (stage.targetTemperature && [stage.targetTemperature intValue] > 0)
//    {
//        stateCount++;
//    }
    
//    self.stageBar.numberOfStates = [NSNumber numberWithInt:stateCount];
//    NSLog(@"calculated %d states", stateCount);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)continueButtonTap:(id)sender
{
    //TODO: use an enum to track the button state instead of this hack
    // small workaround here, when there is only one item in the stage table
    // the paragon is not incrementing the index
    if (
        (self.currentParagon.session.currentStageIndex == self.currentParagon.session.activeRecipe.paragonCookingStages.count ||
         self.currentParagon.session.currentStageIndex ==0)
        &&
        (self.currentParagon.session.cookMode == FSTCookingStatePrecisionCookingCurrentStageDone)
        )
    {
        // entire recipe is complete
        self.continueButton.userInteractionEnabled = NO;
        self.continueButton.hidden = YES;
        self.stageBar.hidden = YES;
        [self.stateContainer segueToStateWithIdentifier:@"recipeComplete" sender:nil];
    }
    else if ( self.currentParagon.session.cookMode == FSTCookingStatePrecisionCookingCurrentStageDone &&
             [self.continueButtonText.text isEqualToString:@"     DONE"])
    {
        // current stage is complete
        self.continueButtonText.text = @"     NEXT STAGE";
        self.continueButton.userInteractionEnabled = YES;
        self.continueButton.hidden = NO;
        self.stageBar.hidden = NO;
        [self.stateContainer segueToStateWithIdentifier:@"stageCompleteSegue" sender:nil];
//        [self.delegate directionLabelsChangedWithPrepDirections:self.currentParagon.session.currentStage.cookingPrepLabel andCookingDirections:self.currentParagon.session.currentStage.cookingLabel];
    }
    else if ( self.currentParagon.session.cookMode == FSTCookingStatePrecisionCookingCurrentStageDone &&
             [self.continueButtonText.text isEqualToString:@"     NEXT STAGE"])
    {
        // stage is complete and user acknwoledged
        self.continueButton.userInteractionEnabled = NO;
        self.continueButton.hidden = YES;
        self.stageBar.hidden = YES;
        [self.currentParagon moveNextStage];
    }
    else if (self.currentParagon.session.cookMode == FSTCookingStatePrecisionCookingPastMaxTime)
    {
        // entire recipe is complete
        self.continueButton.userInteractionEnabled = NO;
        self.continueButton.hidden = YES;
        self.stageBar.hidden = YES;
        [self.stateContainer segueToStateWithIdentifier:@"recipeComplete" sender:nil];
    }
    else
    {
        [self.currentParagon startTimerForCurrentStage];
        self.continueButton.userInteractionEnabled = NO;
    }
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
       FSTParagonCookingStage* currentStage = self.currentParagon.session.currentStage;
       cookingData.targetTemp = [currentStage.targetTemperature intValue];
       cookingData.targetMaxTime = [currentStage.cookTimeMaximum intValue];
       cookingData.targetMinTime = [currentStage.cookTimeMinimum intValue];
       cookingData.burnerLevel = [self.currentParagon.session.currentPowerLevel intValue];
       cookingData.remainingHoldTime = [self.currentParagon.session.remainingHoldTime intValue];
       cookingData.currentTemp = [self.currentParagon.session.currentProbeTemperature intValue];
       [self setRecipeStageInstructions];
       containerVC.cookingData = cookingData;
       self.stateContainer = containerVC;
   }
   else if ([segue.identifier isEqualToString:@"displayPopOut"])
   {
       //TODO: tidy up here, is_multi_stage should not be set here, but rather in the init/viewDidLoad
       FSTSavedDisplayRecipeViewController* displayVC = (FSTSavedDisplayRecipeViewController*)segue.destinationViewController;
       displayVC.currentParagon = self.currentParagon;
       displayVC.activeRecipe = [[FSTSavedRecipeManager sharedInstance] getRecipeForId:self.currentParagon.session.activeRecipe.recipeId];
       displayVC.will_hide_cook = [NSNumber numberWithBool:YES]; // don't want them to select this and push on another cooking session.
       if ([displayVC.activeRecipe isKindOfClass:[FSTSousVideRecipe class]]) {
           displayVC.is_multi_stage = [NSNumber numberWithBool:NO];
       } else if ([displayVC.activeRecipe isKindOfClass:[FSTMultiStageRecipe class]]) {
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
    cookingData.currentTemp = [temperature intValue];
    [self.delegate dataChanged:cookingData];
}

-(void)remainingHoldTimeChanged:(NSNumber *)holdTime
{
    cookingData.remainingHoldTime = [holdTime intValue];
    [self.delegate dataChanged:cookingData];
}

- (void)holdTimerSet
{
    cookingData.targetMinTime = [self.currentParagon.session.currentStage.cookTimeMinimum doubleValue];
    cookingData.targetMaxTime = [self.currentParagon.session.currentStage.cookTimeMaximum doubleValue];
    [self.delegate dataChanged:cookingData];
}

- (void)cookModeChanged:(ParagonCookMode)cookMode
{
    [self transitionToCurrentCookMode];
}

-(void)currentPowerLevelChanged:(NSNumber *)powerLevel
{
    cookingData.burnerLevel = [powerLevel doubleValue];
    [self.delegate dataChanged:cookingData];
}

- (void)cookConfigurationChanged
{
    cookingData.targetTemp = [self.currentParagon.session.currentStage.targetTemperature doubleValue];
    cookingData.targetMinTime = [self.currentParagon.session.currentStage.cookTimeMinimum doubleValue];
    cookingData.targetMaxTime = [self.currentParagon.session.currentStage.cookTimeMaximum doubleValue];
    [self.delegate dataChanged:cookingData];
}

- (void)currentStageIndexChanged:(NSNumber *)stage
{
    if (self.currentParagon.session.activeRecipe.paragonCookingStages.count > 1)
    {
        MobiNavigationController* controller = (MobiNavigationController*)self.navigationController;
        [controller setHeaderText:[NSString stringWithFormat:@"STAGE %d",self.currentParagon.session.currentStageIndex] withFrameRect:CGRectMake(0, 0, 120, 30)];
        
        [self setStageBarStateCountForState:self.currentParagon.session.currentStage];
        cookingData.targetTemp =[self.currentParagon.session.currentStage.targetTemperature doubleValue];
        cookingData.targetMinTime = [self.currentParagon.session.currentStage.cookTimeMinimum doubleValue];
        cookingData.targetMaxTime = [self.currentParagon.session.currentStage.cookTimeMaximum doubleValue];
        [self setRecipeStageInstructions];
        [self.delegate dataChanged:cookingData];
    }
}

@end
