//
//  FSTAutoCookViewController.m
//  FirstBuild
//
//  Created by Myles Caley on 12/15/15.
//  Copyright © 2015 FirstBuild. All rights reserved.
//

#import "FSTAutoCookViewController.h"
#import "FSTReadyToReachTemperatureViewController.h"
#import "MobiNavigationController.h"
#import "FSTRevealViewController.h"

@interface FSTAutoCookViewController ()

@end

@implementation FSTAutoCookViewController
{
    IBOutlet UILabel *recipeNameLabel;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated {
    
    MobiNavigationController* controller = (MobiNavigationController*)self.navigationController;
    [controller setHeaderText:@"SETTINGS" withFrameRect:CGRectMake(0, 0, 120, 30)];
    [self updateLabels];
    
    self.continueTapGestureRecognizer.enabled = YES;
}

- (void)updateLabels
{
    recipeNameLabel.text = self.recipe.name;
    
    //temperature label
    UIFont *boldFont = [UIFont fontWithName:@"FSEmeric-SemiBold" size:17.0];
    NSDictionary *boldFontDict = [NSDictionary dictionaryWithObject: boldFont forKey:NSFontAttributeName];
    
    UIFont *labelFont = [UIFont fontWithName:@"FSEmeric-Thin" size:14.0];
    NSDictionary *labelFontDict = [NSDictionary dictionaryWithObject: labelFont forKey:NSFontAttributeName];
    
    UIFont *bigLabelFont = [UIFont fontWithName:@"FSEmeric-Thin" size:22.0];
    NSDictionary *bigLabelFontDict = [NSDictionary dictionaryWithObject: bigLabelFont forKey:NSFontAttributeName];
    
    FSTParagonCookingStage* stage = self.recipe.paragonCookingStages[0];
    
    // min time values
    
    NSNumber* hour = [NSNumber numberWithInt:[stage.cookTimeMinimum intValue]/60];
    NSNumber* minute = [NSNumber numberWithInt:[stage.cookTimeMinimum intValue]%60];
    
    // max time values
    NSNumber* maxHour = [NSNumber numberWithInt:[stage.cookTimeMaximum intValue]/60]  ;
    NSNumber* maxMinute = [NSNumber numberWithInt:[stage.cookTimeMaximum intValue]%60]   ;
    
    // min time labels
    NSMutableAttributedString *hourString = [[NSMutableAttributedString alloc] initWithString:[hour stringValue] attributes: boldFontDict];
    NSMutableAttributedString *minuteString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat: @"%02ld",(long)[minute integerValue]] attributes: boldFontDict];
    NSMutableAttributedString *hourLabel = [[NSMutableAttributedString alloc] initWithString:@":" attributes: labelFontDict];
    
    // max time labels
    NSMutableAttributedString *maxHourString = [[NSMutableAttributedString alloc] initWithString:[maxHour stringValue] attributes: boldFontDict];
    NSMutableAttributedString *maxMinuteString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat: @"%02ld",(long)[maxMinute integerValue]] attributes: boldFontDict];
    NSMutableAttributedString *maxHourLabel = [[NSMutableAttributedString alloc] initWithString:@":" attributes: labelFontDict];
    
    // temperature label
    NSMutableAttributedString *temperature = [[NSMutableAttributedString alloc] initWithString:[stage.targetTemperature stringValue] attributes: boldFontDict];
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
}

- (IBAction)continueTapGesture:(id)sender {
    
    self.continueTapGestureRecognizer.enabled = NO;
    
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

- (IBAction)menuToggleTapped:(id)sender {
    [self.revealViewController rightRevealToggle:self.currentParagon];
}

#pragma mark - <FSTParagonDelegate>
- (void)cookConfigurationSet:(NSError *)error
{
    if (error)
    {
        self.continueTapGestureRecognizer.enabled = YES;
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Press Rapid Precise"
                                                                                 message:@"The cooktop must have the Rapid Precise setting active before pressing CONTINUE."
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

@end
