//
//  FSTCustomCookSettingsViewController.m
//  FirstBuild
//
//  Created by Myles Caley on 5/12/15.
//  Copyright (c) 2015 FirstBuild. All rights reserved.
//

#import "FSTCustomCookSettingsViewController.h"
#import "FSTSousVideCookingMethod.h"
#import "FSTReadyToPreheatViewController.h"

@interface FSTCustomCookSettingsViewController ()

@end

@implementation FSTCustomCookSettingsViewController
{
    NSMutableArray *pickerTemperatureData; // append to this with for loop
    // holds values for temperature picker
    NSArray *pickerTimeData; // fixed for now
    // for cook time picker
    NSArray *pickerViews;
    // keep track of all slide out views
    NSInteger tempIndex;
    // store the last row accssed in temperature
    NSInteger minHourIndex;
    // store the last row accessed in time hour column, minimum time picker
    NSInteger minMinuteIndex;
    
    NSInteger maxHourIndex;
    
    NSInteger maxMinuteIndex;
    
    
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
    
    pickerTemperatureData = [[NSMutableArray alloc]init];
    
    for (NSInteger i = 90; i <= 220; i+=5) {
        [pickerTemperatureData addObject:[NSString stringWithFormat:@"%.01f", (float)i]];
    }
    //pickerTemperatureData = @[@"140.0", @"145.0", @"150.0"]; // initialize with for loop later
        
    pickerTimeData = @[@[@"0", @"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9"], @[@":00", @":15", @":30", @":45"]]; // hour and minutes
   
    self.minPicker.dataSource = self;
    self.minPicker.delegate = self; // pickers all use this view controller as a delegate, and the pickerview address lets us determine which picker member triggered the callback
    self.maxPicker.dataSource = self;
    self.maxPicker.delegate = self;
    self.tempPicker.dataSource = self;
    self.tempPicker.delegate = self;
    _selection = NONE; // set the initial states
    minHourIndex = 0;
    minMinuteIndex = 1; // initial selections
    maxHourIndex = 0;
    maxMinuteIndex = 1;
    tempIndex = 0;
    // set them in every picker
    [self.minPicker selectRow:minHourIndex inComponent:0 animated:NO];
    [self.minPicker selectRow:minMinuteIndex inComponent:1 animated:NO];
    [self.maxPicker selectRow:maxHourIndex inComponent:0 animated:NO];
    [self.maxPicker selectRow:maxMinuteIndex inComponent:1 animated:NO];
    [self.tempPicker selectRow:tempIndex inComponent:0 animated:NO];

    [self.currentParagon.currentCookingMethod createCookingSession]; // initialize the customized method
    [self.currentParagon.currentCookingMethod addStageToCookingSession];
    
}

- (void) viewWillAppear:(BOOL)animated { //want to make the segue faster
    
    [self resetPickerHeights];
    [self updateLabels]; // set them to current selection (decided by preset hour, minute, temp index
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// report the number of columns (1 for temp, 2 for time)
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    if ((pickerView == self.minPicker || pickerView == self.maxPicker)) {
        return 2;
    } else {
        return 1;
    }
}

- (NSInteger) pickerView:(UIPickerView *) pickerView numberOfRowsInComponent:(NSInteger)component {
    
    if (pickerView == self.minPicker || pickerView == self.maxPicker){
        return ((NSArray*)pickerTimeData[component]).count; // eventually, this will return the maxHourIndex for the minPicker when the component is 0, and the maxMinute Index if the minTime index is equal to the current MaxTimeIndex (the data must reload when this happens)
    } else {
        return pickerTemperatureData.count;
    }
}

- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (pickerView == self.minPicker|| pickerView == self.maxPicker) {
        return (NSString*)pickerTimeData[component][row];// will eventually offset max time data with minIndices
    } else {
        return (NSString*)pickerTemperatureData[row];//[[NSMutableAttributedString alloc] initWithString: pickerTemperatureData[row]attributes:@{NSForegroundColorAttributeName:UIColorFromRGB(0x00B5CC)}];
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    // set labels now that value had settled
    if (pickerView == self.minPicker) {
        minHourIndex = [self.minPicker selectedRowInComponent:0];
        minMinuteIndex = [self.minPicker selectedRowInComponent:1];
    } else if (pickerView == self.maxPicker) {
        maxHourIndex = [self.maxPicker selectedRowInComponent:0];
        maxMinuteIndex = [self.maxPicker selectedRowInComponent:1];
    } else if (pickerView == self.tempPicker) {
        tempIndex = [self.tempPicker selectedRowInComponent:0];
    }
    [self updateLabels]; // indices needed for writing the labels from picker data
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

- (void) updateLabels {
    // all label strings
    NSMutableAttributedString* minHourString;
    
    NSMutableAttributedString* minMinuteString;
    
    NSMutableAttributedString* maxHourString;
    
    NSMutableAttributedString* maxMinuteString;
    
    NSMutableAttributedString* temperatureString;
    
    UIFont* labelsFont = [UIFont fontWithName:@"FSEmeric-Thin" size:32.0];
    NSDictionary* labelFontDictionary = [NSDictionary dictionaryWithObject:labelsFont forKey:NSFontAttributeName];
    
    // set all strings according to the picker data
    minHourString = [[NSMutableAttributedString alloc] initWithString:pickerTimeData[0][minHourIndex] attributes:labelFontDictionary];
    minMinuteString = [[NSMutableAttributedString alloc] initWithString:pickerTimeData[1][minMinuteIndex] attributes:labelFontDictionary];
    maxHourString = [[NSMutableAttributedString alloc] initWithString:pickerTimeData[0][maxHourIndex] attributes:labelFontDictionary];
    maxMinuteString = [[NSMutableAttributedString alloc] initWithString:pickerTimeData[1][maxMinuteIndex] attributes:labelFontDictionary];
    temperatureString = [[NSMutableAttributedString alloc] initWithString:pickerTemperatureData[tempIndex] attributes:labelFontDictionary];
    
    NSMutableAttributedString* farenheitString = [[NSMutableAttributedString alloc]initWithString:@"\u00b0 F" attributes:labelFontDictionary];
    // append "degrees farenheit" to temp
    [temperatureString appendAttributedString:farenheitString];
    [minHourString appendAttributedString:minMinuteString]; // put hours and minutes together
    [maxHourString appendAttributedString:maxMinuteString];
    
    [self.minTimeLabel setAttributedText:minHourString];
    [self.maxTimeLabel setAttributedText:maxHourString];
    [self.temperatureLabel setAttributedText:temperatureString]; // set the labels with the attributed strings of last recorded indices
}

- (IBAction)continueTapGesture:(id)sender {
    FSTParagonCookingStage* stage = (FSTParagonCookingStage*)(self.currentParagon.currentCookingMethod.session.paragonCookingStages[0]); // THIS IS STILL nil (session onward)
    NSNumberFormatter* convert = [[NSNumberFormatter alloc] init];
    convert.numberStyle = NSNumberFormatterDecimalStyle;
    stage.targetTemperature = [convert numberFromString:pickerTemperatureData[tempIndex]];
    // time calculations
    double minCookingMinutes = ([(NSNumber*)[convert numberFromString:pickerTimeData[0][minHourIndex]] integerValue] * 60) + ([(NSNumber*)[convert numberFromString:[pickerTimeData[1][minMinuteIndex] substringFromIndex:1]] integerValue]);
    double maxCookingMinutes = ([(NSNumber*)[convert numberFromString:pickerTimeData[0][maxHourIndex]] integerValue] * 60) + ([(NSNumber*)[convert numberFromString:[pickerTimeData[1][maxMinuteIndex] substringFromIndex:1]] integerValue]);
    stage.cookTimeMinimum = [NSNumber numberWithDouble:minCookingMinutes];
    stage.cookTimeMaximum = [NSNumber numberWithDouble:maxCookingMinutes];
    stage.cookingLabel = @"Custom Profile";
    //stage.cookingLabel = [NSString stringWithFormat:@"%@ (%@)",@"Steak",[_beefCookingMethod.donenessLabels objectForKey:_currentTemperature]];
    [self performSegueWithIdentifier:@"segueCustomPreheat" sender:self]; // name of segue from custom view to ready to preheat
}

- (void)dealloc
{
    DLog(@"dealloc");
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

    if ([segue.destinationViewController isKindOfClass:[FSTReadyToPreheatViewController class]])
    {
        FSTParagonCookingStage* stage = (FSTParagonCookingStage*)(self.currentParagon.currentCookingMethod.session.paragonCookingStages[0]);
        [self.currentParagon startHeatingWithTemperature:stage.targetTemperature];
        
        ((FSTReadyToPreheatViewController*)segue.destinationViewController).currentParagon = self.currentParagon;
    }

}


@end
