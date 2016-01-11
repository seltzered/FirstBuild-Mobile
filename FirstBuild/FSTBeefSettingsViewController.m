//
//  FSTBeefSettingsViewController.m
//  FirstBuild
//
//  Created by Myles Caley on 5/12/15.
//  Copyright (c) 2015 FirstBuild. All rights reserved.
//

#import "FSTBeefSettingsViewController.h"
#import "FSTBeefSousVideRecipe.h"
#import "FSTReadyToReachTemperatureViewController.h"
#import "MobiNavigationController.h"
#import "FSTRevealViewController.h"

@interface FSTBeefSettingsViewController ()


@end

const uint8_t TEMPERATURE_START_INDEX = 1;

@implementation FSTBeefSettingsViewController
{
    //data values for corresponding view relationships
    NSNumber* _currentThickness;
    NSNumber* _currentTemperature;

    FSTBeefSousVideRecipe* _beefRecipe;

    //array of possible cook times for the selected temperature
    NSArray* _currentCookTimeArray;

}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    _beefRecipe = (FSTBeefSousVideRecipe*)self.recipe;
    
    
    //set up for data objects
    _currentThickness =[NSNumber numberWithDouble:[self meatThicknessWithSliderValue:self.thicknessSlider.value]];
    _currentTemperature = [NSNumber numberWithDouble:[_beefRecipe.donenesses[TEMPERATURE_START_INDEX] doubleValue]];
    _currentCookTimeArray = ((NSArray*)([[_beefRecipe.cookingTimes objectForKey:_currentTemperature] objectForKey:_currentThickness]));
}

-(void)viewWillAppear:(BOOL)animated {
    
    MobiNavigationController* controller = (MobiNavigationController*)self.navigationController;
    [controller setHeaderText:self.recipe.name withFrameRect:CGRectMake(0, 0, 120, 30)];
    [self updateLabels];
    
    self.continueTapGestureRecognizer.enabled = YES;
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
    
    // min time values
    NSNumber* hour = (NSNumber*)(((NSArray*)([[_beefRecipe.cookingTimes objectForKey:_currentTemperature] objectForKey:_currentThickness]))[0]);
    NSNumber* minute = (NSNumber*)(((NSArray*)([[_beefRecipe.cookingTimes objectForKey:_currentTemperature] objectForKey:_currentThickness]))[1]);
    
    // max time values
    NSNumber* maxHour = (NSNumber*)(((NSArray*)([[_beefRecipe.cookingTimes objectForKey:_currentTemperature] objectForKey:_currentThickness]))[2]);
    NSNumber* maxMinute = (NSNumber*)(((NSArray*)([[_beefRecipe.cookingTimes objectForKey:_currentTemperature] objectForKey:_currentThickness]))[3]);
    
    // min time labels
    NSMutableAttributedString *hourString = [[NSMutableAttributedString alloc] initWithString:[hour stringValue] attributes: boldFontDict];
    NSMutableAttributedString *minuteString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat: @"%02ld",(long)[minute integerValue]] attributes: boldFontDict];
    NSMutableAttributedString *hourLabel = [[NSMutableAttributedString alloc] initWithString:@":" attributes: labelFontDict];
    
    // max time labels
    NSMutableAttributedString *maxHourString = [[NSMutableAttributedString alloc] initWithString:[maxHour stringValue] attributes: boldFontDict];
    NSMutableAttributedString *maxMinuteString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat: @"%02ld",(long)[maxMinute integerValue]] attributes: boldFontDict];
    NSMutableAttributedString *maxHourLabel = [[NSMutableAttributedString alloc] initWithString:@":" attributes: labelFontDict];
    
    // temperature label
    NSMutableAttributedString *temperature = [[NSMutableAttributedString alloc] initWithString:[_currentTemperature stringValue] attributes: boldFontDict];
    NSMutableAttributedString *degreeString = [[NSMutableAttributedString alloc] initWithString:@"\u00b0" attributes:boldFontDict];
    NSMutableAttributedString *temperatureLabel = [[NSMutableAttributedString alloc] initWithString:@" F" attributes: boldFontDict];
    
    // create the strings
    [hourString appendAttributedString:hourLabel];
    [hourString appendAttributedString:minuteString];
    [maxHourString appendAttributedString:maxHourLabel];
    [maxHourString appendAttributedString:maxMinuteString];
    [temperature appendAttributedString:degreeString];
    [temperature appendAttributedString:temperatureLabel];
    
    // set the strings on the label
    [self.beefSettingsLabel setAttributedText:hourString];
    [self.maxBeefSettingsLabel setAttributedText:maxHourString]; // hour string with one additional hour
    [self.tempSettingsLabel setAttributedText:temperature];
    
    NSMutableAttributedString* thicknessString = [[NSMutableAttributedString alloc] initWithString:[_currentThickness stringValue] attributes:bigLabelFontDict];
    NSMutableAttributedString* thicknessStringTag = [[NSMutableAttributedString alloc] initWithString:@"\"" attributes:bigLabelFontDict];
    [thicknessString appendAttributedString:thicknessStringTag];
    // number then '" Thickness'
    
    [self.thicknessLabel setAttributedText:thicknessString];
    
    // label above doneness slider
    [self.donenessLabel setAttributedText:[[NSAttributedString alloc] initWithString:[_beefRecipe.donenessLabels objectForKey:_currentTemperature] attributes:bigLabelFontDict]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)continueTapGesture:(id)sender {
    
    self.continueTapGestureRecognizer.enabled = NO;
    
    FSTParagonCookingStage* stage;

    if (_beefRecipe.paragonCookingStages.count == 0)
    {
        stage = [_beefRecipe addStage];
    }
    else
    {
        stage = _beefRecipe.paragonCookingStages[0];
    }
    
    stage.targetTemperature = _currentTemperature;
    double cookingMinutesMin = ([(NSNumber*)_currentCookTimeArray[0] integerValue] * 60) + ([(NSNumber*)_currentCookTimeArray[1] integerValue]);
    double cookingMinutesMax = ([(NSNumber*)_currentCookTimeArray[2] integerValue] * 60) + ([(NSNumber*)_currentCookTimeArray[3] integerValue]);
    stage.cookTimeMinimum = [NSNumber numberWithDouble:cookingMinutesMin];
    stage.cookTimeMaximum = [NSNumber numberWithDouble:cookingMinutesMax];
    stage.cookingLabel = [NSString stringWithFormat:@"%@ (%@)",@"Steak",[_beefRecipe.donenessLabels objectForKey:_currentTemperature]];
    stage.maxPowerLevel = [NSNumber numberWithInt:10];
    
    if (![self.currentParagon sendRecipeToCooktop:self.recipe])
    {
        self.continueTapGestureRecognizer.enabled = YES;
    }
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{    
    if ([segue.destinationViewController isKindOfClass:[FSTReadyToReachTemperatureViewController class]])
    {
        ((FSTReadyToReachTemperatureViewController*)segue.destinationViewController).currentParagon = self.currentParagon;
    }
}

- (IBAction)donenessSlid:(id)sender {
    
    UISlider* slider = sender;
    uint8_t donenessIndex;
    donenessIndex = floor((_beefRecipe.donenesses.count - 1)*slider.value); // donenesses mapped to the slider
    _currentTemperature = [NSNumber numberWithDouble:[_beefRecipe.donenesses[donenessIndex] doubleValue]];
    _currentCookTimeArray = ((NSArray*)([[_beefRecipe.cookingTimes objectForKey:_currentTemperature] objectForKey:_currentThickness]));
    [self updateLabels];
}

- (IBAction)thicknessSlid:(id)sender {
    // used the thicknessSlider
    UISlider* slider = sender; // get the slider
    _currentThickness =[NSNumber numberWithDouble:[self meatThicknessWithSliderValue: slider.value]];
    _currentCookTimeArray = ((NSArray*)([[_beefRecipe.cookingTimes objectForKey:_currentTemperature] objectForKey:_currentThickness]));
    [self updateLabels];
}

- (double) meatThicknessWithSliderValue: (CGFloat)value
{
    //find our closest index of thicknesss based on the height of the current view in relation
    //to the maximum size it can grow. that will then give a proportion we can use to search
    //in an array of thicknesses and find the closest one
    int index = floor(value*(_beefRecipe.thicknesses.count - 1));//floor((height-_meatHeightOffset)/(_maxHeight-_meatHeightOffset) * _beefRecipe.thicknesses.count); // just give it the range of a slider from 0 to 1. (need to subtract 1 to stay within bounds)
    if (index < _beefRecipe.thicknesses.count)
    {
        NSNumber *thickness = [_beefRecipe.thicknesses objectAtIndex:index];
        return [thickness doubleValue];
    }
    return 0;
}
- (IBAction)menuToggleTapped:(id)sender {
    [self.revealViewController rightRevealToggle:self.currentParagon];
}

#pragma mark - <FSTParagonDelegate>
- (void)cookConfigurationSet:(NSError *)error
{
    if (error)
    {
        self.continueTapGestureRecognizer.enabled = YES;
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Oops!"
                                                                                 message:@"The cooktop must not currently be cooking. Try pressing the Stop button and changing to the Rapid or Gentle Precise cooking mode."
                                                                          preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *actionOk = [UIAlertAction actionWithTitle:@"OK"
                                                           style:UIAlertActionStyleDefault
                                                         handler:nil];
        [alertController addAction:actionOk];
        [self presentViewController:alertController animated:YES completion:nil];
        return;
    }
    [self performSegueWithIdentifier:@"seguePreheat" sender:self];
}
-(void)pendingRecipeCancelled
{
    self.continueTapGestureRecognizer.enabled = YES;
}


@end
