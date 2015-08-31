//
//  FSTSavedRecipeSettingsViewController.m
//  FirstBuild
//
//  Created by John Nolan on 8/24/15.
//  Copyright (c) 2015 FirstBuild. All rights reserved.
//

#import "FSTSavedRecipeSettingsViewController.h"
#import "FSTSavedRecipeUnderLineView.h"

@interface FSTSavedRecipeSettingsViewController ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *underLineSpacing;

@property (weak, nonatomic) IBOutlet FSTSavedRecipeUnderLineView *underLineView;

@property (weak, nonatomic) IBOutlet UIPickerView *minPicker;

@property (weak, nonatomic) IBOutlet UIPickerView *maxPicker;

@property (weak, nonatomic) IBOutlet UIPickerView *tempPicker;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tempPickerHeight;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *maxPickerHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *minPickerHeight;

@property (weak, nonatomic) IBOutlet UILabel *minLabel;

@property (weak, nonatomic) IBOutlet UILabel *maxLabel;

@property (weak, nonatomic) IBOutlet UILabel *tempLabel;

@end

@implementation FSTSavedRecipeSettingsViewController

typedef enum variableSelections {
    MIN_TIME,
    MAX_TIME,
    TEMPERATURE,
    NONE
} VariableSelection;
// keeps track of the open picker views

VariableSelection _selection;


CGFloat const SEL_HEIGHT_T = 90; // the standard picker height for the current selection (equal to the constant picker height

- (void)viewDidLoad {
    [super viewDidLoad];
    self.pickerManager = [[FSTStagePickerManager alloc] init];
    [self.minPicker setDelegate:self.pickerManager];
    [self.maxPicker setDelegate:self.pickerManager];
    [self.tempPicker setDelegate:self.pickerManager]; // holds all the
    self.pickerManager.minPicker = self.minPicker;
    self.pickerManager.maxPicker = self.maxPicker;
    self.pickerManager.tempPicker = self.tempPicker;
    [self.pickerManager setDelegate:self];
    [self.pickerManager selectAllIndices];
    _selection = NONE;
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.pickerManager selectAllIndices];
    [self resetPickerHeights];
    [self updateLabels];
}

-(void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    self.underLineSpacing.constant = self.tabBarController.tabBar.frame.size.height;
    [self.underLineView setHorizontalPosition:5*self.view.frame.size.width/6];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - picker managing
-(void)updateLabels {
    
    [self.tempLabel setAttributedText:[self.pickerManager tempLabel]];
    [self.minLabel setAttributedText:[self.pickerManager minLabel]];
    [self.maxLabel setAttributedText:[self.pickerManager maxLabel]];
    
}

// top button pressed
- (IBAction)minTimeTapGesture:(id)sender {
    [self resetPickerHeights];
    if (_selection != MIN_TIME) { // only needs to run when a change should be made
        // set selection to MIN_TIME now that the new min picker is about to show
        _selection = MIN_TIME;
        self.minPickerHeight.constant = SEL_HEIGHT_T;
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
        self.maxPickerHeight.constant = SEL_HEIGHT_T;
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
        self.tempPickerHeight.constant = SEL_HEIGHT_T;
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
    self.minPickerHeight.constant = 0;
    self.maxPickerHeight.constant = 0;
    self.tempPickerHeight.constant = 0; // careful to reset the constants, not the pointers to the constraints
    // changes layout in a subsequent animation
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
