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
    NSMutableArray *pickerTimeData; // fixed for now
    // for cook time picker
    //NSArray *pickerViews;
    // keep track of all slide out views
    NSInteger tempIndex;
    // store the last row accssed in temperature
    NSInteger minHourIndex;
    // store the last row accessed in time hour column, minimum time picker
    NSInteger minMinuteIndex;
    
    NSInteger maxHourIndex; // index on its own respective picker, with a mutable start point
    
    NSInteger maxMinuteIndex;
    
    // need to know the hour and minute index on the minute data scale
    NSInteger maxHourActual;
    
    NSInteger maxMinuteActual;
    
    NSObject *_temperatureSetObserver;
    
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
    self.currentParagon.toBeCookingMethod = (FSTCookingMethod*) [[FSTSousVideCookingMethod alloc] init];
    [self.currentParagon.toBeCookingMethod createCookingSession]; 
    [self.currentParagon.toBeCookingMethod addStageToCookingSession];

    pickerTemperatureData = [[NSMutableArray alloc]init];
    
    for (NSInteger i = 90; i <= 220; i+=1) {
        [pickerTemperatureData addObject:[NSString stringWithFormat:@"%.01f", (float)i]];
    }
    //pickerTemperatureData = @[@"140.0", @"145.0", @"150.0"]; // initialize with for loop later
        
    pickerTimeData = [[NSMutableArray alloc] init];//@[@[@"0", @"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9"], @[@":00", @":15", @":30", @":45"]]; // hour and minutes
    NSMutableArray* timeRow1 = [[NSMutableArray alloc] init];
    NSMutableArray* timeRow2 = [[NSMutableArray alloc] init];
    for (int ih = 0; ih < 10; ih++) {
        [timeRow1 addObject:[NSString stringWithFormat:@"%i", ih]];
    }
    
    for (int im = 0; im < 60; im++) { // temporarily starts at one, should keep 0:00 off limits in code
        [timeRow2 addObject:[NSString stringWithFormat:@":%02i", im]];
    }
    
    [pickerTimeData addObject:timeRow1];
    [pickerTimeData addObject:timeRow2];
   
    self.minPicker.dataSource = self;
    self.minPicker.delegate = self; // pickers all use this view controller as a delegate, and the pickerview address lets us determine which picker member triggered the callback
    self.maxPicker.dataSource = self;
    self.maxPicker.delegate = self;
    self.tempPicker.dataSource = self;
    self.tempPicker.delegate = self;
    _selection = NONE; // set the initial states
    minHourIndex = 0;
    minMinuteIndex = 0; // initial selections (minimum values
    maxHourIndex = ((NSArray*)pickerTimeData[0]).count - 1;
    maxMinuteIndex = ((NSArray*)pickerTimeData[1]).count - 1; // maximum values in max
    maxHourActual = maxHourIndex;
    maxMinuteActual = maxMinuteIndex; // no difference between them (probably unnecessary)
    tempIndex = 0;

    // set them in every picker
    [self.minPicker selectRow:minHourIndex inComponent:0 animated:NO];
    [self.minPicker selectRow:minMinuteIndex inComponent:1 animated:NO];
    [self.maxPicker selectRow:maxHourIndex inComponent:0 animated:NO];
    [self.maxPicker selectRow:maxMinuteIndex inComponent:1 animated:NO];
    [self.tempPicker selectRow:tempIndex inComponent:0 animated:NO];
    
}

- (void)removeObservers
{
    [[NSNotificationCenter defaultCenter] removeObserver:_temperatureSetObserver];
}

- (void) viewWillDisappear:(BOOL)animated
{
    [self removeObservers];
}

- (void) viewWillAppear:(BOOL)animated { //want to make the segue faster
    
    [self resetPickerHeights];
    [self updateLabels]; // set them to current selection (decided by preset hour, minute, temp index
    
    self.continueTapGesturerRecognizer.enabled = YES;
    
    //setup the observer so we know when the temperature wrote
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    __weak typeof(self) weakSelf = self;
    
    _temperatureSetObserver = [center addObserverForName:FSTTargetTemperatureSetNotification
                                                  object:weakSelf.currentParagon
                                                   queue:nil
                                              usingBlock:^(NSNotification *notification)
   {
       [self performSegueWithIdentifier:@"segueCustomPreheat" sender:self];
   }];
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
    
    if (pickerView == self.minPicker){
        if (component == 0) {
                return maxHourActual + 1; // includes everything throught the max hour selection
        } else if (component == 1) {
            //NSInteger count;
            if (minHourIndex == maxHourActual) {
                return maxMinuteActual + 1;
            } else {
                if (minHourIndex == 0) {
                    return ((NSArray*)pickerTimeData[component]).count - 1;
                    //return count - 1; // case where the minute 0 is excluded. always will be one less // problem was max minute actual is already one less than it seems in the 0 hour case
                } else {
                    return ((NSArray*)pickerTimeData[component]).count;
                }
            }
        }
    } // end the minTimePicker condition
    else if (pickerView == self.maxPicker) {
        if (component == 0) {
            return ((NSArray*)pickerTimeData[component]).count - minHourIndex; // list only extends from current minimum index to the end
        } else if (component == 1) {
            NSInteger count;
            if (minHourIndex == maxHourActual) { // if the hours are equal, ensure that users pick a greater minute index (so the max minutes will extend from min minute selection to the end)
                count = ((NSArray*)pickerTimeData[component]).count - minMinuteIndex;
            } else {
                count = ((NSArray*)pickerTimeData[component]).count; // otherwise give them every minute
            }
            if (maxHourActual == 0) {
                return count - 1;
            } else {
                return count;
            }
        }
    }
    else {
        return pickerTemperatureData.count;
    } // end the tempPicker else statement
    return 0; // default, don't load data (should not ever reach this
}

- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (pickerView == self.minPicker) {
        if (minHourIndex == 0 && component == 1) { // minutes in this exception
                return (NSString*)pickerTimeData[component][row + 1]; // offset for the hidden 1 minute value
        } else {
            return (NSString*)pickerTimeData[component][row];// offset max time data with minIndice, this stays constant
        }
    } // end min picker case
    else if (pickerView == self.maxPicker) {
        if (component == 0) {
            return (NSString*)pickerTimeData[component][row + minHourIndex];
        } else { // assuming only two components for now
                if (minHourIndex == maxHourActual) { // minutes must be greater or equal to the minPicker
                    if (maxHourActual == 0) {// should hide zero minute
                        return (NSString*)pickerTimeData[component][row + minMinuteIndex + 1]; // size should be one less
                    } else {
                        return (NSString*)pickerTimeData[component][row + minMinuteIndex];
                    }
                } else {
                    if (maxHourActual == 0) { // probably cannot ever happen since min Hour is held below max Hour, so they would have to be equal
                        return (NSString*)pickerTimeData[component][row + 1]; // offset by one to avoid showing the zero
                    } else {
                        return (NSString*)pickerTimeData[component][row];
                    }
                } // min hour different case
        } // end component 1 case
    } // end max picker case
    else {
        return (NSString*)pickerTemperatureData[row];//[[NSMutableAttributedString alloc] initWithString: pickerTemperatureData[row]attributes:@{NSForegroundColorAttributeName:UIColorFromRGB(0x00B5CC)}];
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    // set labels now that value had settled
    [self reloadData];
    if (pickerView == self.minPicker) {
        if (component == 0) {
            minHourIndex = row;
            maxHourIndex = maxHourActual - minHourIndex; // subtract to offset to get its index on the picker scale
            if (minHourIndex == 0 && minMinuteIndex >= ((NSMutableArray*)pickerTimeData[1]).count) { // past index for mintues
                    minMinuteIndex--; // set it back down if it is one too high // ideally this shifts down or up if there is a transition between 0 and other rows (but be careful of shooting too low or high the other way)
            }
            [self reloadData];
            [self.maxPicker selectRow:maxHourIndex inComponent:0 animated:NO]; // hour might need to update according to the changed range
            if ((maxHourActual == minHourIndex) && (minMinuteIndex > maxMinuteActual)) { // cases where the minute range went down below the current selection (label needs to update) (but only when the hours are equal so the range must change)
                minMinuteIndex = maxMinuteActual;
                [pickerView selectRow:minMinuteIndex inComponent:1 animated:NO];
            }
        } else if (component == 1) {
            minMinuteIndex = row;
        // need to reset the max index in case its minimum value changed (actual index stays the same.
            // if statement was here
        }
        if (maxHourActual == minHourIndex) {// difference comes down to minutes
            maxMinuteIndex = maxMinuteActual - minMinuteIndex;
            // reset the maxMinute to its new range
            [self reloadData]; // make sure it has the correct new range, or else it might go outside
            [self.maxPicker selectRow:maxMinuteIndex inComponent:1 animated:NO];
        } // should always rese thes
    } else if (pickerView == self.maxPicker) {
        if (component == 0) { // selected an hour
            maxHourIndex = row;
            // get the current selections
            maxHourActual = minHourIndex + maxHourIndex; // record the max Hour index with its starting offset
            if (maxHourActual == minHourIndex) { // hours lined up
                if (maxMinuteActual >= minMinuteIndex) {
                    maxMinuteIndex = maxMinuteActual - minMinuteIndex;
                } else { // dangerous exception
                    maxMinuteIndex = 0; // default to the first entry
                    maxMinuteActual = minMinuteIndex; // at the start of its range
                }
            } else {
                maxMinuteIndex = maxMinuteActual; // need to reset the selection to the current reading
            }
            if (maxHourActual == 0 && maxMinuteActual >= ((NSMutableArray*)pickerTimeData[1]).count - 1) { // needs to fall below the 1 through 59 index (runs 0 to 58)
                    maxMinuteIndex--;
                    maxMinuteActual--;
            }
            [self reloadData];
            [pickerView selectRow:maxMinuteIndex inComponent:1 animated:NO]; // update the selection in the minutes
        } else if (component == 1) { // selected a minute, track changes to the actual max minute index for reference when changing the hour
            maxMinuteIndex = row;
            if (maxHourActual == minHourIndex) { // the size should change in this case
                maxMinuteActual = minMinuteIndex + maxMinuteIndex; // this can some times be above four since the size of the minutes do not reset fast enough
            } else {
                maxMinuteActual = maxMinuteIndex; // default, set it on its normal scale
            }
        }
    } else if (pickerView == self.tempPicker) {
        tempIndex = [self.tempPicker selectedRowInComponent:0];
    }
    [self reloadData];
    [self updateLabels]; // indices needed for writing the labels from picker data
}

- (void)reloadData {
    [self.minPicker reloadAllComponents];
    [self.maxPicker reloadAllComponents];
    [self.tempPicker reloadAllComponents];
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
    if (minHourIndex == 0) { // minute offset case
        minMinuteString = [[NSMutableAttributedString alloc] initWithString:pickerTimeData[1][minMinuteIndex + 1] attributes:labelFontDictionary];
    } else {
        minMinuteString = [[NSMutableAttributedString alloc] initWithString:pickerTimeData[1][minMinuteIndex] attributes:labelFontDictionary];
    }
    maxHourString = [[NSMutableAttributedString alloc] initWithString:pickerTimeData[0][maxHourActual] attributes:labelFontDictionary];
    // nit to offset this according to the minMinute selection (I might set these strings in the selection block)
    if (maxHourActual == 0) {
        maxMinuteString = [[NSMutableAttributedString alloc] initWithString:pickerTimeData[1][maxMinuteActual + 1] attributes:labelFontDictionary];
    } else {
        maxMinuteString = [[NSMutableAttributedString alloc] initWithString:pickerTimeData[1][maxMinuteActual] attributes:labelFontDictionary];
    }
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
    
    //TODO progress indicator?
    //TODO grey out the button?
    self.continueTapGesturerRecognizer.enabled = NO;
    
    FSTParagonCookingStage* stage = (FSTParagonCookingStage*)(self.currentParagon.toBeCookingMethod.session.paragonCookingStages[0]); 
    NSNumberFormatter* convert = [[NSNumberFormatter alloc] init];
    convert.numberStyle = NSNumberFormatterDecimalStyle;
    stage.targetTemperature = [convert numberFromString:pickerTemperatureData[tempIndex]];
    // time calculations
    double minCookingMinutes = ([(NSNumber*)[convert numberFromString:pickerTimeData[0][minHourIndex]] integerValue] * 60) + ([(NSNumber*)[convert numberFromString:[pickerTimeData[1][minMinuteIndex] substringFromIndex:1]] integerValue]);
    double maxCookingMinutes = ([(NSNumber*)[convert numberFromString:pickerTimeData[0][maxHourActual]] integerValue] * 60) + ([(NSNumber*)[convert numberFromString:[pickerTimeData[1][maxMinuteActual] substringFromIndex:1]] integerValue]);
    stage.cookTimeMinimum = [NSNumber numberWithDouble:minCookingMinutes];
    stage.cookTimeMaximum = [NSNumber numberWithDouble:maxCookingMinutes];
    stage.cookingLabel = @"Custom Profile";
    //stage.cookingLabel = [NSString stringWithFormat:@"%@ (%@)",@"Steak",[_beefCookingMethod.donenessLabels objectForKey:_currentTemperature]];
    
    [self.currentParagon startHeating];
}

- (void)dealloc
{
    DLog(@"dealloc");
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

    if ([segue.destinationViewController isKindOfClass:[FSTReadyToPreheatViewController class]])
    {
        ((FSTReadyToPreheatViewController*)segue.destinationViewController).currentParagon = self.currentParagon;
    }
}


@end
