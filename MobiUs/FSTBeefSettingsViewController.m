//
//  FSTBeefSettingsViewController.m
//  FirstBuild
//
//  Created by Myles Caley on 5/12/15.
//  Copyright (c) 2015 FirstBuild. All rights reserved.
//

#import "FSTBeefSettingsViewController.h"
#import "FSTBeefSousVideCookingMethod.h"
#import "FSTReadyToPreheatViewController.h"
#import "MobiNavigationController.h"
#import "FSTRevealViewController.h"

@interface FSTBeefSettingsViewController ()

@end

const uint8_t TEMPERATURE_START_INDEX = 6;

@implementation FSTBeefSettingsViewController
{
    //data values for corresponding view relationships
    NSNumber* _currentThickness;
    NSNumber* _currentTemperature;
    FSTBeefSousVideCookingMethod* _beefCookingMethod;

    //array of possible cook times for the selected temperature
    NSArray* _currentCookTimeArray;
    
    NSObject* _temperatureSetObserver;

}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    //set up for data objects
    _beefCookingMethod = [[FSTBeefSousVideCookingMethod alloc]init];
    _currentThickness =[NSNumber numberWithDouble:[self meatThicknessWithSliderValue:self.thicknessSlider.value]];
    _currentTemperature = [NSNumber numberWithDouble:[_beefCookingMethod.donenesses[TEMPERATURE_START_INDEX] doubleValue]];
    _currentCookTimeArray = ((NSArray*)([[_beefCookingMethod.cookingTimes objectForKey:_currentTemperature] objectForKey:_currentThickness]));
}

-(void)viewWillAppear:(BOOL)animated {
    
    MobiNavigationController* controller = (MobiNavigationController*)self.navigationController;
    [controller setHeaderText:@"SETTINGS" withFrameRect:CGRectMake(0, 0, 120, 30)];
    [self updateLabels];
    
    self.continueTapGestureRecognizer.enabled = YES;

    //setup the observer so we know when the temperature wrote
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    __weak typeof(self) weakSelf = self;
    
    _temperatureSetObserver = [center addObserverForName:FSTTargetTemperatureSetNotification
                                                  object:weakSelf.currentParagon
                                                   queue:nil
                                              usingBlock:^(NSNotification *notification)
   {
       [self performSegueWithIdentifier:@"seguePreheat" sender:self];
   }];
}

- (void) viewWillDisappear:(BOOL)animated
{
    [self removeObservers];
}

- (void)removeObservers
{
    [[NSNotificationCenter defaultCenter] removeObserver:_temperatureSetObserver];
}


- (void)updateLabels
{
    //temperature label
    UIFont *boldFont = [UIFont fontWithName:@"FSEmeric-SemiBold" size:17.0];
    NSDictionary *boldFontDict = [NSDictionary dictionaryWithObject: boldFont forKey:NSFontAttributeName];
    
    UIFont *labelFont = [UIFont fontWithName:@"FSEmeric-Thin" size:14.0];
    NSDictionary *labelFontDict = [NSDictionary dictionaryWithObject: labelFont forKey:NSFontAttributeName];
    
    UIFont *bigLabelFont = [UIFont fontWithName:@"FSEmeric-Thin" size:22.0];
    NSDictionary *bigLabelFontDict = [NSDictionary dictionaryWithObject: bigLabelFont forKey:NSFontAttributeName];
    
    NSNumber* hour = (NSNumber*)(((NSArray*)([[_beefCookingMethod.cookingTimes objectForKey:_currentTemperature] objectForKey:_currentThickness]))[0]);
    NSNumber* minute = (NSNumber*)(((NSArray*)([[_beefCookingMethod.cookingTimes objectForKey:_currentTemperature] objectForKey:_currentThickness]))[1]);
    //TODO add actual data rather than this temporary demonstration, setting the max time one hour above
    NSNumber* maxHour = [NSNumber numberWithInteger:[hour integerValue] + 1];
    
    NSMutableAttributedString *hourString = [[NSMutableAttributedString alloc] initWithString:[hour stringValue] attributes: boldFontDict];
    NSMutableAttributedString *maxHourString = [[NSMutableAttributedString alloc] initWithString:[maxHour stringValue] attributes: boldFontDict];
    NSMutableAttributedString *hourLabel = [[NSMutableAttributedString alloc] initWithString:@":" attributes: labelFontDict];
    NSMutableAttributedString *minuteString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat: @"%02d",[minute integerValue]] attributes: boldFontDict];
    //NSMutableAttributedString *minuteLabel = [[NSMutableAttributedString alloc] initWithString:@"MIN" attributes: labelFontDict];
    //NSMutableAttributedString *separator = [[NSMutableAttributedString alloc] initWithString:@"  |  " attributes: boldFontDict];
    NSMutableAttributedString *temperature = [[NSMutableAttributedString alloc] initWithString:[_currentTemperature stringValue] attributes: boldFontDict];
    NSMutableAttributedString *degreeString = [[NSMutableAttributedString alloc] initWithString:@"\u00b0" attributes:boldFontDict];
    NSMutableAttributedString *temperatureLabel = [[NSMutableAttributedString alloc] initWithString:@" F" attributes: boldFontDict];
    
    [hourString appendAttributedString:hourLabel];
    [hourString appendAttributedString:minuteString];
    //[hourString appendAttributedString:minuteLabel];
    //[hourString appendAttributedString:separator];
    [maxHourString appendAttributedString:hourLabel];
    [maxHourString appendAttributedString:minuteString];
    //[maxHourString appendAttributedString:minuteLabel];
    [temperature appendAttributedString:degreeString];
    [temperature appendAttributedString:temperatureLabel];
    
    // two seperate labels now
    
    [self.beefSettingsLabel setAttributedText:hourString];
    [self.maxBeefSettingsLabel setAttributedText:maxHourString]; // hour string with one additional hour
    [self.tempSettingsLabel setAttributedText:temperature];
    
    NSMutableAttributedString* thicknessString = [[NSMutableAttributedString alloc] initWithString:[_currentThickness stringValue] attributes:bigLabelFontDict];
    NSMutableAttributedString* thicknessStringTag = [[NSMutableAttributedString alloc] initWithString:@"\"" attributes:bigLabelFontDict];
    [thicknessString appendAttributedString:thicknessStringTag];
    // number then '" Thickness'
    
    [self.thicknessLabel setAttributedText:thicknessString];
    
    // label above doneness slider
    [self.donenessLabel setAttributedText:[[NSAttributedString alloc] initWithString:[_beefCookingMethod.donenessLabels objectForKey:_currentTemperature] attributes:bigLabelFontDict]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)continueTapGesture:(id)sender {
    
    self.continueTapGestureRecognizer.enabled = NO;
    
    FSTParagonCookingStage* stage = (FSTParagonCookingStage*)(self.currentParagon.toBeCookingMethod.session.paragonCookingStages[0]);
    stage.targetTemperature = _currentTemperature;
    double cookingMinutes = ([(NSNumber*)_currentCookTimeArray[0] integerValue] * 60) + ([(NSNumber*)_currentCookTimeArray[1] integerValue]);
    stage.cookTimeMinimum = [NSNumber numberWithDouble:cookingMinutes];
    stage.cookTimeMaximum = [NSNumber numberWithDouble:cookingMinutes + 60];
    stage.cookingLabel = [NSString stringWithFormat:@"%@ (%@)",@"Steak",[_beefCookingMethod.donenessLabels objectForKey:_currentTemperature]];
    
    //once the temperature is confirmed to be set then it will segue above because
    [self.currentParagon startHeating];
    
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{    
    if ([segue.destinationViewController isKindOfClass:[FSTReadyToPreheatViewController class]])
    {
        ((FSTReadyToPreheatViewController*)segue.destinationViewController).currentParagon = self.currentParagon;
    }
}

- (IBAction)donenessSlid:(id)sender {
    
    UISlider* slider = sender;
    uint8_t donenessIndex;
    donenessIndex = floor((_beefCookingMethod.donenesses.count - 1)*slider.value); // donenesses mapped to the slider
    _currentTemperature = [NSNumber numberWithDouble:[_beefCookingMethod.donenesses[donenessIndex] doubleValue]];
    _currentCookTimeArray = ((NSArray*)([[_beefCookingMethod.cookingTimes objectForKey:_currentTemperature] objectForKey:_currentThickness]));
    [self updateLabels];
}

- (IBAction)thicknessSlid:(id)sender {
    // used the thicknessSlider
    UISlider* slider = sender; // get the slider
    _currentThickness =[NSNumber numberWithDouble:[self meatThicknessWithSliderValue: slider.value]];
    _currentCookTimeArray = ((NSArray*)([[_beefCookingMethod.cookingTimes objectForKey:_currentTemperature] objectForKey:_currentThickness]));
    [self updateLabels];
}

- (double) meatThicknessWithSliderValue: (CGFloat)value
{
    //find our closest index of thicknesss based on the height of the current view in relation
    //to the maximum size it can grow. that will then give a proportion we can use to search
    //in an array of thicknesses and find the closest one
    int index = floor(value*(_beefCookingMethod.thicknesses.count - 1));//floor((height-_meatHeightOffset)/(_maxHeight-_meatHeightOffset) * _beefCookingMethod.thicknesses.count); // just give it the range of a slider from 0 to 1. (need to subtract 1 to stay within bounds)
    if (index < _beefCookingMethod.thicknesses.count)
    {
        NSNumber *thickness = [_beefCookingMethod.thicknesses objectAtIndex:index];
        return [thickness doubleValue];
    }
    return 0;
}
- (IBAction)menuToggleTapped:(id)sender {
    [self.revealViewController rightRevealToggle:self.currentParagon];
}

@end
