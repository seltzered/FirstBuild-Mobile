//
//  FSTCustomCookSettingsViewController.m
//  FirstBuild
//
//  Created by Myles Caley on 5/12/15.
//  Copyright (c) 2015 FirstBuild. All rights reserved.
//

#import "FSTCustomCookSettingsViewController.h"
#import "FSTSousVideRecipe.h"
#import "FSTReadyToReachTemperatureViewController.h"

@interface FSTCustomCookSettingsViewController ()

@end

@implementation FSTCustomCookSettingsViewController
{
    NSObject *_cookConfigurationSetObserver;
    FSTStagePickerManager* pickerManager;
}

typedef enum variableSelections {
    MIN_TIME,
    MAX_TIME,
    TEMPERATURE,
    NONE
} VariableSelection;
// keeps track of the open picker views

VariableSelection _selection;

CGFloat const SEL_HEIGHT = 90; // the standard picker height for the current selection (equal to the constant picker height

- (void)viewDidLoad {
    [super viewDidLoad];

    //create a new cooking session
    self.currentParagon.session.toBeRecipe = (FSTRecipe*) [[FSTSousVideRecipe alloc] init];
    [self.currentParagon.session.toBeRecipe addStage];
    
    pickerManager = [[FSTStagePickerManager alloc] init];
        
    self.minPicker.dataSource = pickerManager;
    self.minPicker.delegate = pickerManager; // pickers all use this view controller as a delegate, and the pickerview address lets us determine which picker member triggered the callback
    self.maxPicker.dataSource = pickerManager;
    self.maxPicker.delegate = pickerManager;
    self.tempPicker.dataSource = pickerManager;
    self.tempPicker.delegate = pickerManager;
    pickerManager.minPicker = self.minPicker;
    pickerManager.maxPicker = self.maxPicker;
    pickerManager.tempPicker = self.tempPicker;
    pickerManager.delegate = self;
    
    [pickerManager selectAllIndices]; // hard set all the indices after initialization
    _selection = NONE; // set the initial states for the buttons
    
}

- (void) viewWillAppear:(BOOL)animated { //want to make the segue faster
    
    [self resetPickerHeights];
    [self updateLabels]; // set them to current selection (decided by preset hour, minute, temp index
    
    self.continueTapGesturerRecognizer.enabled = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)resetPickerHeights { // might want to save the current indices as well, but it should remain the same
    // should animate if the selection
    self.minPickerHeight.constant = 0;
    self.maxPickerHeight.constant = 0;
    self.tempPickerHeight.constant = 0; // careful to reset the constants, not the pointers to the constraints
    // changes layout in a subsequent animation
}

#pragma -mark IBActions

// top button pressed
- (IBAction)minTimeTapGesture:(id)sender {
    [self resetPickerHeights];
    if (_selection != MIN_TIME) { // only needs to run when a change should be made
        // set selection to MIN_TIME now that the new min picker is about to show
        _selection = MIN_TIME;
        self.minPickerHeight.constant = SEL_HEIGHT;
    } else {
        _selection = NONE;
    }// if it was MIN_TIME it should close, then change to NONE
    [UIView animateWithDuration:0.7 animations:^(void) {
        [self.view layoutIfNeeded];//[self updateViewConstraints]; // should tell the view to update heights to zero when something moves
    }]; // animate reset and new height or just reset

}

- (IBAction)maxTimeTapGesture:(id)sender {
    [self resetPickerHeights];
    if (_selection != MAX_TIME) { // only needs to run when a change should be made
        _selection = MAX_TIME;
        self.maxPickerHeight.constant = SEL_HEIGHT;
    } else {
        _selection = NONE;
    }
    [UIView animateWithDuration: 0.7 animations:^(void) {
        [self.view layoutIfNeeded];
        //[self updateViewConstraints]; // should tell the view to update heights to zero when something moves
    }];
}


- (IBAction)temperatureTapGesture:(id)sender {
    
    [self resetPickerHeights]; // always change picker heights to zero
    
    if (_selection != TEMPERATURE) {
        _selection = TEMPERATURE;
        self.tempPickerHeight.constant = SEL_HEIGHT;
    } else {
        _selection = NONE;
    }
    [UIView animateWithDuration:0.7 animations:^(void) {
        [self.view layoutIfNeeded];
        //[self updateViewConstraints]; // should tell the view to update heights to zero when something moves
    }];
}


- (IBAction)continueTapGesture:(id)sender {
    
    //TODO: progress indicator?
    //TODO: grey out the button?
    self.continueTapGesturerRecognizer.enabled = NO;
    
    FSTParagonCookingStage* stage = (FSTParagonCookingStage*)(self.currentParagon.session.toBeRecipe.paragonCookingStages[0]);

    stage.targetTemperature = [pickerManager temperatureChosen];
    stage.cookTimeMinimum = [pickerManager minMinutesChosen];
    stage.cookTimeMaximum = [pickerManager maxMinutesChosen];
    stage.cookingLabel = @"Custom Profile";
    //stage.cookingLabel = [NSString stringWithFormat:@"%@ (%@)",@"Steak",[_beefCookingMethod.donenessLabels objectForKey:_currentTemperature]];
    
    ////TODO: HACK TEMP
    FSTParagonCookingStage* stage1 = [self.currentParagon.session.toBeRecipe addStage];
    stage1.maxPowerLevel = [NSNumber numberWithInt:7];
    stage1.cookTimeMinimum = [NSNumber numberWithInt:20];
    stage1.cookTimeMaximum = [NSNumber numberWithInt:4000];
    stage1.targetTemperature = [NSNumber numberWithInt:350];
    stage1.automaticTransition = [NSNumber numberWithBool:YES];
    ////HACK TEMP

    [self.currentParagon sendRecipeToCooktop:self.currentParagon.session.toBeRecipe];
}

- (void)dealloc
{
    DLog(@"dealloc");
}

#pragma mark - Manager Delegate

- (void) updateLabels {
    [self.minTimeLabel setAttributedText:[pickerManager minLabel]];
    [self.maxTimeLabel setAttributedText:[pickerManager maxLabel]];
    [self.temperatureLabel setAttributedText:[pickerManager tempLabel]]; // set the labels with the attributed strings of last recorded indices
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

    if ([segue.destinationViewController isKindOfClass:[FSTReadyToReachTemperatureViewController class]])
    {
        ((FSTReadyToReachTemperatureViewController*)segue.destinationViewController).currentParagon = self.currentParagon;
    }
}

#pragma mark - <FSTParagonDelegate>
- (void)cookConfigurationSet
{
    [self performSegueWithIdentifier:@"segueCustomPreheat" sender:self];
}

@end
