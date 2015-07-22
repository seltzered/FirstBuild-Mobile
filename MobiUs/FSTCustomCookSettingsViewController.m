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
    
    pickerTemperatureData = [[NSMutableArray alloc]init];
    
    for (NSInteger i = 90; i <= 220; i+=5) {
        [pickerTemperatureData addObject:[NSString stringWithFormat:@"%.01f", (float)i]];
    }
    //pickerTemperatureData = @[@"140.0", @"145.0", @"150.0"]; // initialize with for loop later
        
    pickerTimeData = @[@[@"0", @"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9"], @[@":00", @":15", @":30", @":45"]]; // hour and minutes
   
    self.picker.dataSource = self;
    self.picker.delegate = self;
    _selection = TIME;
    hourIndex = 0;
    minuteIndex = 1; // initial selections
    tempIndex = 0;
    [self.picker selectRow:hourIndex inComponent:0 animated:NO];
    [self.picker selectRow:minuteIndex inComponent:1 animated:NO];
    // select 1:30 time at beginning
    // set initial labels
    [self.currentParagon.currentCookingMethod createCookingSession]; // initialize the customized method
    [self.currentParagon.currentCookingMethod addStageToCookingSession];
    
}

- (void) viewWillAppear:(BOOL)animated { //want to make the segue faster
    
    self.timeButtonHolder.layer.borderWidth = self.temperatureButtonHolder.layer.borderWidth;
    self.timeButtonHolder.layer.borderColor = self.temperatureButtonHolder.layer.borderColor;
    // give them the same stroke (this is a bit rough, but I could not find the stroke in storyboard
    [self updateLabels]; // set them to current selection (decided by preset hour, minute, temp index
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
        return (NSString*)pickerTimeData[component][row];//[[NSMutableAttributedString alloc] initWithString: pickerTimeData[component][row] attributes:@{NSForegroundColorAttributeName:UIColorFromRGB(0x00B5CC)}];
    } else {
        return (NSString*)pickerTemperatureData[row];//[[NSMutableAttributedString alloc] initWithString: pickerTemperatureData[row]attributes:@{NSForegroundColorAttributeName:UIColorFromRGB(0x00B5CC)}];
    }
}

- (IBAction)timeTapGesture:(id)sender {
    if (_selection != TIME) { // only needs to run when a change should be made
        _selection = TIME;
        tempIndex = [self.picker selectedRowInComponent:0];
        [self.picker reloadAllComponents]; // need to reset after changing all this data
        [self.picker selectRow:hourIndex inComponent:0 animated:NO];
        [self.picker selectRow:minuteIndex inComponent:1 animated:NO];
        [self.timeButtonHolder setBackgroundColor:UIColorFromRGB(0x00B5CC)];
        [self.timeButtonLabel setTextColor:[UIColor whiteColor]];
        [self.temperatureButtonHolder setBackgroundColor:[UIColor whiteColor]];
        [self.temperatureButtonLabel setTextColor:UIColorFromRGB(0x00B5CC)];
    }
}
- (IBAction)temperatureTapGesture:(id)sender {
    if (_selection != TEMPERATURE) {
        _selection = TEMPERATURE;
        hourIndex = [self.picker selectedRowInComponent:0];
        minuteIndex = [self.picker selectedRowInComponent:1]; // store the time for next wheel
        [self.picker reloadAllComponents]; // reset the wheel before trying to access temperature again
        [self.picker selectRow:tempIndex inComponent:0 animated:NO];
        [self.temperatureButtonHolder setBackgroundColor:UIColorFromRGB(0x00B5CC)];
        [self.temperatureButtonLabel setTextColor:[UIColor whiteColor]];
        [self.timeButtonHolder setBackgroundColor:[UIColor whiteColor]];
        [self.timeButtonLabel setTextColor:UIColorFromRGB(0x00B5CC)];
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
    NSMutableAttributedString* farenheitString = [[NSMutableAttributedString alloc]initWithString:@"\u00b0 F" attributes:labelFontDictionary];
    // append "degrees farenheit" to temp
    [temperatureString appendAttributedString:farenheitString];
    [hourString appendAttributedString:minuteString]; // put hours and minutes together
    [self.timeLabel setAttributedText:hourString];
    [self.temperatureLabel setAttributedText:temperatureString]; // set the labels with the attributed strings of last recorded indices
}

- (IBAction)continueTapGesture:(id)sender {
    FSTParagonCookingStage* stage = (FSTParagonCookingStage*)(self.currentParagon.currentCookingMethod.session.paragonCookingStages[0]); // THIS IS STILL nil (session onward)
    NSNumberFormatter* convert = [[NSNumberFormatter alloc] init];
    convert.numberStyle = NSNumberFormatterDecimalStyle;
    stage.targetTemperature = [convert numberFromString:pickerTemperatureData[tempIndex]];
    double cookingMinutes = ([(NSNumber*)[convert numberFromString:pickerTimeData[0][hourIndex]] integerValue] * 60) + ([(NSNumber*)[convert numberFromString:[pickerTimeData[1][minuteIndex] substringFromIndex:1]] integerValue]);
    stage.cookTimeRequested = [NSNumber numberWithDouble:cookingMinutes];
    stage.cookingLabel = @"Custom Profile";
    //stage.cookingLabel = [NSString stringWithFormat:@"%@ (%@)",@"Steak",[_beefCookingMethod.donenessLabels objectForKey:_currentTemperature]];
    [self performSegueWithIdentifier:@"segueCustomPreheat" sender:self]; // name of segue from custom view to ready to preheat
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
