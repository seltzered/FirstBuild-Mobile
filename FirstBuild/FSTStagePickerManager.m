//
//  FSTStagePickerManager.m
//  FirstBuild
//
//  Created by John Nolan on 8/14/15.
//  Copyright (c) 2015 FirstBuild. All rights reserved.
//

#import "FSTStagePickerManager.h"

@implementation FSTStagePickerManager
{
    NSArray *pickerTemperatureData; // append to this with for loop
    // holds values for temperature picker
    NSArray *pickerTimeData; // fixed for now
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
}

// still has seg fault when hitting max minute index at 0

-(instancetype)init {
    self = [super init];
    if (self) {
        pickerTemperatureData = [self tempDataInit];
        pickerTimeData = [self timeDataInit];
        minHourIndex = 0;
        
//        maxHourIndex = [pickerTimeData[0] count] - 1;
        maxHourIndex = 2;
        minMinuteIndex = 59;
        maxMinuteIndex = 0;
//        maxMinuteIndex = [pickerTimeData[1] count] - 1;
        maxHourActual = maxHourIndex;
        maxMinuteActual = maxMinuteIndex;
        tempIndex = 60;
        
    }
    return self;
}

-(NSAttributedString*)minLabel {
    NSMutableAttributedString* minHourString;
    
    NSMutableAttributedString* minMinuteString;
    
    UIFont* labelsFont = [UIFont fontWithName:@"FSEmeric-Thin" size:32.0];
    NSDictionary* labelFontDictionary = [NSDictionary dictionaryWithObject:labelsFont forKey:NSFontAttributeName];
    
    // set all strings according to the picker data
    minHourString = [[NSMutableAttributedString alloc] initWithString:pickerTimeData[0][minHourIndex] attributes:labelFontDictionary];
//    if (minHourIndex == 0) { // minute offset case
//        minMinuteString = [[NSMutableAttributedString alloc] initWithString:pickerTimeData[1][minMinuteIndex + 1] attributes:labelFontDictionary];
//    } else {
        minMinuteString = [[NSMutableAttributedString alloc] initWithString:pickerTimeData[1][minMinuteIndex] attributes:labelFontDictionary];
//    }
    [minHourString appendAttributedString:minMinuteString]; // put hours and minutes together
    return minHourString;

    
}

- (NSAttributedString*)maxLabel {
    
    NSMutableAttributedString* maxHourString;
    
    NSMutableAttributedString* maxMinuteString;
    
    
    UIFont* labelsFont = [UIFont fontWithName:@"FSEmeric-Thin" size:32.0];
    NSDictionary* labelFontDictionary = [NSDictionary dictionaryWithObject:labelsFont forKey:NSFontAttributeName];
    
    maxHourString = [[NSMutableAttributedString alloc] initWithString:pickerTimeData[0][maxHourActual] attributes:labelFontDictionary];
    // nit to offset this according to the minMinute selection (I might set these strings in the selection block)
    if (maxHourActual == 0) {
        maxMinuteString = [[NSMutableAttributedString alloc] initWithString:pickerTimeData[1][maxMinuteActual + 1] attributes:labelFontDictionary];
    } else {
        maxMinuteString = [[NSMutableAttributedString alloc] initWithString:pickerTimeData[1][maxMinuteActual] attributes:labelFontDictionary];
    }
    
    [maxHourString appendAttributedString:maxMinuteString];
    return maxHourString;
}

-(NSAttributedString*)tempLabel {

    NSMutableAttributedString* temperatureString;
    
    UIFont* labelsFont = [UIFont fontWithName:@"FSEmeric-Thin" size:32.0];
    NSDictionary* labelFontDictionary = [NSDictionary dictionaryWithObject:labelsFont forKey:NSFontAttributeName];

    temperatureString = [[NSMutableAttributedString alloc] initWithString:pickerTemperatureData[tempIndex] attributes:labelFontDictionary];
    
    NSMutableAttributedString* farenheitString = [[NSMutableAttributedString alloc]initWithString:@"\u00b0 F" attributes:labelFontDictionary];
    // append "degrees farenheit" to temp
    [temperatureString appendAttributedString:farenheitString];
    return temperatureString;

}

- (NSNumber*)minMinutesChosen {
    NSNumberFormatter* convert = [[NSNumberFormatter alloc] init];
    convert.numberStyle = NSNumberFormatterDecimalStyle;
    NSInteger minHourMinutes = [[convert numberFromString:pickerTimeData[0][minHourIndex]] integerValue] * 60;
    NSInteger minMinutes;
//    if (minHourIndex == 0) { // changed this to match the labels given
//        minMinutes = [[convert numberFromString:[pickerTimeData[1][minMinuteIndex + 1] substringFromIndex:1]] integerValue];
//    } else {
        minMinutes = [[convert numberFromString:[pickerTimeData[1][minMinuteIndex] substringFromIndex:1]] integerValue];
//    }
    return [NSNumber numberWithInt:(minHourMinutes + minMinutes)];
    
}

- (NSNumber*)maxMinutesChosen {
    NSNumberFormatter* convert = [[NSNumberFormatter alloc] init];
    convert.numberStyle = NSNumberFormatterDecimalStyle;
    NSInteger maxHourMinutes = [[convert numberFromString:pickerTimeData[0][maxHourActual]] integerValue] * 60; // maxHour value in minutes
    NSInteger maxMinutes;
    if (maxHourActual == 0) { // changed this to match the labels given
        maxMinutes = [[convert numberFromString:[pickerTimeData[1][maxMinuteActual + 1] substringFromIndex:1]] integerValue];
    } else {
        maxMinutes = [[convert numberFromString:[pickerTimeData[1][maxMinuteActual] substringFromIndex:1]] integerValue];
    }
    return [NSNumber numberWithInt:(maxHourMinutes + maxMinutes)];
}

- (NSNumber*)temperatureChosen {
    
    NSNumberFormatter* convert = [[NSNumberFormatter alloc] init];
    convert.numberStyle = NSNumberFormatterDecimalStyle;
    return (NSNumber*)[convert numberFromString:pickerTemperatureData[tempIndex]];
    
}

-(NSArray*)tempDataInit {
    NSMutableArray* tempData = [[NSMutableArray alloc] init];
    
    for (NSInteger i = 80; i <= 375; i+=1) {
        [tempData addObject:[NSString stringWithFormat:@"%.01f", (float)i]];
    }
    
    return (NSArray*)tempData;
    
}

-(NSArray*)timeDataInit {
    NSMutableArray* timeData = [[NSMutableArray alloc] init];//@[@[@"0", @"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9"], @[@":00", @":15", @":30", @":45"]]; // hour and minutes
    NSMutableArray* timeRow1 = [[NSMutableArray alloc] init] ; // hours
    NSMutableArray* timeRow2 = [[NSMutableArray alloc] init]; // minutes
    for (int ih = 0; ih < 10; ih++) {
        [timeRow1 addObject:[NSString stringWithFormat:@"%i", ih]];
    }
    
    for (int im = 0; im < 60; im++) { // temporarily starts at one, should keep 0:00 off limits in code
        [timeRow2 addObject:[NSString stringWithFormat:@":%02i", im]];
    }
    
    [timeData addObject:timeRow1];
    [timeData addObject:timeRow2];
    
    return timeData;
    
}

#pragma mark - picker delegate


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
//        if (minHourIndex == 0 && component == 1) { // minutes in this exception
//            return (NSString*)pickerTimeData[component][row + 1]; // offset for the hidden 1 minute value
//        } else {
            return (NSString*)pickerTimeData[component][row];// offset max time data with minIndice, this stays constant
//        }
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
            if (minHourIndex == 0 && minMinuteIndex >= ((NSMutableArray*)pickerTimeData[1]).count - 1) { // past index for mintues
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
            } // this logic does not seem to work in the min picker (error was I forgot to subtract 1
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
    [self.delegate updateLabels]; // indices needed for writing the labels from picker data
}

// the following methods let the view controllers select the correct index
- (void) selectMinMinutes:(NSNumber *)minMinutes {
    [self selectMinutes:minMinutes inPicker:self.minPicker];
}

-(void) selectMinMinutes:(NSNumber *)minMinutes withMaxMinutes:(NSNumber*)maxMinutes {
    // if there are two temperatures, select both since it is much easier to set the maxMinutes first
    [self selectMinutes:[NSNumber numberWithInt:1] inPicker:self.minPicker];
    // make sure the maxMinutes has the maximum range first
    [self selectMinutes:maxMinutes inPicker:self.maxPicker];
    [self selectMinMinutes:minMinutes];
    // then just select the minMinutes the same way (this will move the maxMinutes up to the correct position
    // did select row calls to often
}

- (void) selectMinutes:(NSNumber *)minutes inPicker:(UIPickerView*)picker {
    NSInteger hour_pi = [minutes integerValue]/60; // hour picker index
    NSInteger minute_pi;
    [picker selectRow:hour_pi inComponent:0 animated:NO];
    [self pickerView:picker didSelectRow:hour_pi inComponent:0];
    if (hour_pi == 0) {
        if ([minutes integerValue] > 0) {
            minute_pi = [minutes integerValue] - 1;
        } else {
            minute_pi = 0;
        }
    } else {
        minute_pi = [minutes integerValue] % 60;
    }
    [picker selectRow:minute_pi inComponent:1 animated:NO];
    [self pickerView:picker didSelectRow:minute_pi inComponent:1];
    // hopefully this calls did select, other wise I will call it myself
}

-(void) selectTemperature:(NSNumber *)temperature {
    NSInteger min_temp = [((NSString*)[pickerTemperatureData objectAtIndex:0]) integerValue];
    NSInteger temp_pi;
    // picker index, offset from 0
    if ([temperature integerValue] >= min_temp) {
        temp_pi = [temperature integerValue] - min_temp;
        // take the value minus the minimum to find the index
    } else {
        temp_pi = 0;
        // default to the first value, 90
    }
    [self.tempPicker selectRow:temp_pi inComponent:0 animated:NO];
    [self pickerView:self.tempPicker didSelectRow:temp_pi inComponent:0];
    // tell it to update its variables
}

- (void)reloadData {
    [self.minPicker reloadAllComponents];
    [self.maxPicker reloadAllComponents];
    [self.tempPicker reloadAllComponents];
}

-(void)selectAllIndices {
    [self.minPicker selectRow:minHourIndex inComponent:0 animated:NO];
    [self.minPicker selectRow:minMinuteIndex inComponent:1 animated:NO];
    [self.maxPicker selectRow:maxHourIndex inComponent:0 animated:NO];
    [self.maxPicker selectRow:maxMinuteIndex inComponent:1 animated:NO];
    [self.tempPicker selectRow:tempIndex inComponent:0 animated:NO];
}

@end
