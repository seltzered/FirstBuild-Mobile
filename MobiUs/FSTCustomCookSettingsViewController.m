//
//  FSTCustomCookSettingsViewController.m
//  FirstBuild
//
//  Created by Myles Caley on 5/12/15.
//  Copyright (c) 2015 FirstBuild. All rights reserved.
//

#import "FSTCustomCookSettingsViewController.h"

@interface FSTCustomCookSettingsViewController ()

@end

@implementation FSTCustomCookSettingsViewController
{
    NSArray *pickerTemperatureData;
    // holds values for temperature picker
    NSArray *pickerTimeData;
    // for cook time picker
    NSInteger tempIndex;
    // store the last row accssed in temperature
    NSInteger hourIndex;
    // store the last row accessed in time hour column
    NSInteger minuteIndex;
    
    NSMutableAttributedString* hourString;
    
    NSMutableAttributedString* minuteString;
    
    NSMutableAttributedString* temperatureString;
}
typedef enum variableSelections {
    TIME,
    TEMPERATURE
} VariableSelection;

VariableSelection _selection;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    pickerTemperatureData = @[@"140.0", @"145.0", @"150.0"]; // initialize with for loop later
    pickerTimeData = @[@[@"1", @"2", @"3", @"4", @"5", @"6"], @[@":0", @":15", @":30", @":45"]]; // hour and minutes
   
       self.picker.dataSource = self;
    self.picker.delegate = self;
    _selection = TIME;
    hourIndex = 0;
    minuteIndex = 1; // initial selections
    tempIndex = 0;
    [self.picker selectRow:0 inComponent:hourIndex animated:NO];
    [self.picker selectRow:2 inComponent:minuteIndex animated:NO];
    // select 1:30 time at beginning
    // set initial labels
   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// report the number of columns (1 for temp, 2 for time)
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    if (_selection == TIME) {
        return 2;
    } else {
        return 1;
    }
}

- (NSInteger) pickerView:(UIPickerView *) pickerView numberOfRowsInComponent:(NSInteger)component {
    
    if (_selection == TIME){
        return ((NSArray*)pickerTimeData[component]).count;
    } else {
        return pickerTemperatureData.count;
    }
}

- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (_selection == TIME) {
        return pickerTimeData[component][row];
    } else {
        return pickerTemperatureData[row];
    }
}

- (IBAction)timeTapGesture:(id)sender {
    if (_selection != TIME) { // only needs to run when a change should be made
        _selection = TIME;
        tempIndex = [self.picker selectedRowInComponent:0];
        [self.picker reloadAllComponents]; // need to reset after changing all this data
        [self.picker selectRow:hourIndex inComponent:0 animated:NO];
        [self.picker selectRow:minuteIndex inComponent:1 animated:NO];
    }
}
- (IBAction)temperatureTapGesture:(id)sender {
    if (_selection != TEMPERATURE) {
        _selection = TEMPERATURE;
        hourIndex = [self.picker selectedRowInComponent:0];
        minuteIndex = [self.picker selectedRowInComponent:1]; // store the time for next wheel
        [self.picker reloadAllComponents]; // reset the wheel before trying to access temperature again
        [self.picker selectRow:tempIndex inComponent:0 animated:NO];
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    // set labels now that value had settled
    if (_selection == TIME) {
        hourIndex = [self.picker selectedRowInComponent:0];
        minuteIndex = [self.picker selectedRowInComponent:1];
    } else {
        tempIndex = [self.picker selectedRowInComponent:0];
    }
    
    [self updateLabels];
}
         
- (void) updateLabels {
    UIFont* labelsFont = [UIFont fontWithName:@"PTSans-NarrowBold" size:43.0];
    NSDictionary* labelFontDictionary = [NSDictionary dictionaryWithObject:labelsFont forKey:NSFontAttributeName];
    hourString = [[NSMutableAttributedString alloc] initWithString:pickerTimeData[0][hourIndex] attributes:labelFontDictionary];
    minuteString = [[NSMutableAttributedString alloc] initWithString:pickerTimeData[1][minuteIndex] attributes:labelFontDictionary];
    temperatureString = [[NSMutableAttributedString alloc] initWithString:pickerTemperatureData[tempIndex] attributes:labelFontDictionary];
    [hourString appendAttributedString:minuteString]; // put hours and minutes together
    [self.timeLabel setAttributedText:hourString];
    [self.temperatureLabel setAttributedText:temperatureString]; // set the labels with the attributed strings of last recorded indices
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
