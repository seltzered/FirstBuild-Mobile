//
//  FSTStageSettingsViewController.m
//  FirstBuild
//
//  Created by John Nolan on 8/26/15.
//  Copyright (c) 2015 FirstBuild. All rights reserved.
//

#import "FSTStageSettingsViewController.h"
#import "FSTSavedRecipeViewController.h"

@interface FSTStageSettingsViewController ()

@property (weak, nonatomic) IBOutlet UIView *saveButtonWrapper;

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (weak, nonatomic) IBOutlet UIPickerView *timePicker;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *timePickerHeight;

@property (weak, nonatomic) IBOutlet UIView *timeButtonWrapper;

@property (weak, nonatomic) IBOutlet UILabel *tempLabel;

@property (weak, nonatomic) IBOutlet UIPickerView *tempPicker;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tempPickerHeight;

@property (weak, nonatomic) IBOutlet UIView *tempButtonWrapper;

@property (weak, nonatomic) IBOutlet UILabel *speedLabel;

@property (weak, nonatomic) IBOutlet UIPickerView *speedPicker;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *speedPickerHeight;

@property (weak, nonatomic) IBOutlet UIView *speedButtonWrapper;

@property (weak, nonatomic) IBOutlet UISwitch *autoTransitionSwitch;

@property (weak, nonatomic) IBOutlet UITextView *directionsTextView;

@end

@implementation FSTStageSettingsViewController
{
    
    FSTStagePickerManager* pickerManager; // hopefully this will work fine just without the max time added in
    
}
//TODO rename
typedef enum stageVariableSelections {
    TIME,
    TEMP,
    SPEED,
    NONE
} StageVariableSelection;
// keeps track of the open picker views

StageVariableSelection _selection;

CGFloat const SEL_HEIGHT_S = 70;

- (void)viewDidLoad {
    [super viewDidLoad];
    pickerManager = [[FSTStagePickerManager alloc] init]; // just want this temporarily to initialize the data
    pickerManager.minPicker = self.timePicker;
    self.timePicker.delegate = pickerManager;
    self.timePicker.dataSource = pickerManager;
    pickerManager.tempPicker = self.tempPicker;
    self.tempPicker.delegate = pickerManager;
    self.tempPicker.dataSource = pickerManager;
    
    self.speedPicker.dataSource = self;
    self.speedPicker.delegate = self;
    [self.speedPicker selectRow:[self.activeStage.maxPowerLevel integerValue] inComponent:0 animated:NO];
    
    self.autoTransitionSwitch.on = [self.activeStage.automaticTransition boolValue];
    
    self.directionsTextView.delegate = self;
    pickerManager.delegate = self; // needs to update time and temp labels
    [self.directionsTextView setText:self.activeStage.cookingLabel]; // set the active text if it has been set in this stage
    [pickerManager selectAllIndices];
    [self registerKeyboardNotifications];
}

#pragma mark - keyboard events
- (void)registerKeyboardNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)keyboardWasShown:(NSNotification*)notification {
    NSDictionary* info = [notification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    //CGRect adjustedFrame = self.view.frame;
    //adjustedFrame.origin.y -= kbSize.height;
    CGAffineTransform keyboardUp = CGAffineTransformTranslate(self.view.transform, 0.0, -kbSize.height + 80); // the 80 is hard coded, just a slight offset
    [UIView animateWithDuration:0.2 animations:^(void) {
        [self.view setTransform:keyboardUp];
    }];
}

- (void)keyboardWillHide:(NSNotification*)notification {
    [self.view setTransform:CGAffineTransformIdentity];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    // I feel that it's better to catch this after all the pickers load
    [pickerManager selectMinMinutes:self.activeStage.cookTimeMinimum];
    [pickerManager selectTemperature:self.activeStage.targetTemperature];
    //[self.speedPicker selectRow:self.activeStage.speed inComponent:0 animated:NO];
    // speed still not set in the stages
    [self resetPickerHeights];
    [self updateLabels];
    [self updateSpeedLabel];
    if (![self.can_edit boolValue]) {
        // in display mode
        self.view.userInteractionEnabled = NO;
        
        //label backgrounds
        self.timeButtonWrapper.backgroundColor = [UIColor whiteColor];
        self.timeButtonWrapper.layer.borderColor = [UIColor blackColor].CGColor;
        self.timeButtonWrapper.layer.borderWidth = 2.0f;
        
        self.tempButtonWrapper.backgroundColor = [UIColor whiteColor];
        self.tempButtonWrapper.layer.borderColor = [UIColor blackColor].CGColor;
        self.tempButtonWrapper.layer.borderWidth = 2.0f;
        
        self.speedButtonWrapper.backgroundColor = [UIColor whiteColor];
        self.speedButtonWrapper.layer.borderColor = [UIColor blackColor].CGColor;
        self.speedButtonWrapper.layer.borderWidth = 2.0f;
        
        self.speedButtonWrapper.backgroundColor = [UIColor whiteColor];
        self.speedButtonWrapper.layer.borderColor = [UIColor blackColor].CGColor;
        self.speedButtonWrapper.layer.borderWidth = 2.0f;
        
        self.directionsTextView.backgroundColor = [UIColor whiteColor];
        self.directionsTextView.layer.borderColor = [UIColor blackColor].CGColor;
        self.directionsTextView.layer.borderWidth = 2.0f;
        
        // text colors
        self.timeLabel.textColor = [UIColor blackColor];
        self.tempLabel.textColor = [UIColor blackColor];
        self.speedLabel.textColor = [UIColor blackColor];
        self.directionsTextView.textColor = [UIColor blackColor];
        
        self.saveButtonWrapper.hidden = YES;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return 11; // this will always be the speed picker
}

-(NSInteger) numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}
-(NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [[NSNumber numberWithLong:row] stringValue]; // just need to number the rows 0 through 9
}
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    [self updateSpeedLabel];
}

-(void)updateSpeedLabel {
    UIFont* labelsFont = [UIFont fontWithName:@"FSEmeric-Thin" size:32.0];
    NSDictionary* labelFontDictionary = [NSDictionary dictionaryWithObject:labelsFont forKey:NSFontAttributeName];
    
    NSMutableAttributedString* speedText = [[NSMutableAttributedString alloc] initWithString:[[NSNumber numberWithLong:[self.speedPicker selectedRowInComponent:0]] stringValue] attributes:labelFontDictionary];
    
    [self.speedLabel setAttributedText:speedText]; // this is the only time we need to update the speed label
}

// manager delegate method
-(void)updateLabels {
    [self.timeLabel setAttributedText:[pickerManager minLabel]]; // there is no max time here
    [self.tempLabel setAttributedText:[pickerManager tempLabel]];
    
}

// top button pressed
- (IBAction)timeTapGesture:(id)sender {
    [self resetPickerHeights];
    if (_selection != TIME) { // only needs to run when a change should be made
        // set selection to MIN_TIME now that the new min picker is about to show
        _selection = TIME;
        self.timePickerHeight.constant = SEL_HEIGHT_S;
    } else {
        _selection = NONE;
    }// if it was MIN_TIME it should close, then change to NONE
    [UIView animateWithDuration:0.7 animations:^(void) {
        [self.view layoutIfNeeded];//[self updateViewConstraints]; // should tell the view to update heights to zero when something moves
    }]; // animate reset and new height or just reset
    
}


- (IBAction)tempTapGesture:(id)sender {
    [self resetPickerHeights];
    if (_selection != TEMP) { // only needs to run when a change should be made
        _selection = TEMP;
        self.tempPickerHeight.constant = SEL_HEIGHT_S;
    } else {
        _selection = NONE;
    }
    [UIView animateWithDuration: 0.7 animations:^(void) {
        [self.view layoutIfNeeded];
        //[self updateViewConstraints]; // should tell the view to update heights to zero when something moves
    }];
}


- (IBAction)speedTapGesture:(id)sender {
    
    [self resetPickerHeights]; // always change picker heights to zero
    
    if (_selection != SPEED) {
        _selection = SPEED;
        self.speedPickerHeight.constant = SEL_HEIGHT_S;
    } else {
        _selection = NONE;
    }
    [UIView animateWithDuration:0.7 animations:^(void) {
        [self.view layoutIfNeeded];
        //[self updateViewConstraints]; // should tell the view to update heights to zero when something moves
    }];
}

- (void)resetPickerHeights { // might want to save the current indices as well, but it should remain the same
    // should animate if the selection
    self.timePickerHeight.constant = 0;
    self.speedPickerHeight.constant = 0;
    self.tempPickerHeight.constant = 0; // careful to reset the constants, not the pointers to the constraints
    // changes layout in a subsequent animation
}

- (IBAction)saveButtonTapped:(id)sender {
    self.activeStage.maxPowerLevel = [NSNumber numberWithInteger:[self.speedPicker selectedRowInComponent:0]];
    self.activeStage.cookTimeMinimum = [pickerManager minMinutesChosen];
    self.activeStage.targetTemperature = [pickerManager temperatureChosen];
    self.activeStage.cookingLabel = self.directionsTextView.text; // is cookingLabel the correct variable
    self.activeStage.automaticTransition = [NSNumber numberWithBool:self.autoTransitionSwitch];
    //this needs to be 0 since we can't set a maximum time for a non sous-vide stage
    self.activeStage.cookTimeMaximum = 0;
    [self.navigationController popViewControllerAnimated:YES];
}

//TODO: the recipes need to actually save these stages

#pragma mark - Text View delegate

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    } else {
        return YES;
    }
}

-(BOOL)textViewShouldEndEditing:(UITextView *)textView {
    // must set active recipe when parent segues
    return YES;
}

@end
