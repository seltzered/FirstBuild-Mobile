//
//  FSTReadyToCookViewController.m
//  FirstBuild
//
//  Created by Myles Caley on 5/12/15.
//  Copyright (c) 2015 FirstBuild. All rights reserved.
//

#import "FSTReadyToCookViewController.h"
#import "UILabel+MultiLineAutoSize.h"
#import "FSTCookingViewController.h"

@interface FSTReadyToCookViewController ()


@end

@implementation FSTReadyToCookViewController

FSTParagonCookingStage* _cookingStage;
NSObject* _temperatureChangedObserver;


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.hidesBackButton = true;

    _cookingStage = (FSTParagonCookingStage*)(self.currentParagon.currentCookingMethod.session.paragonCookingStages[0]);
    
    __weak typeof(self) weakSelf = self;
    
    // Do any additional setup after loading the view.
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    _temperatureChangedObserver = [center addObserverForName:FSTActualTemperatureChangedNotification
                                                      object:weakSelf.currentParagon
                                                       queue:nil
                                                  usingBlock:^(NSNotification *notification)
    {
        [weakSelf.actualTemperatureLabel setText:[_cookingStage.actualTemperature stringValue]];
    }];
                                   
}

-(void)removeObservers
{
    [[NSNotificationCenter defaultCenter] removeObserver:_temperatureChangedObserver];
}

- (void)dealloc
{
    [self removeObservers];
}

-(void)viewWillAppear:(BOOL)animated
{
    //TODO BONEYARD
    //wrap bottom label
//    [self.bottomLabel adjustFontSizeToFitMultiLine];
//    
//    //temperature label
//    UIFont *boldFont = [UIFont fontWithName:@"PTSans-NarrowBold" size:22.0];
//    NSDictionary *boldFontDict = [NSDictionary dictionaryWithObject: boldFont forKey:NSFontAttributeName];
//    
//    UIFont *labelFont = [UIFont fontWithName:@"PT Sans Narrow" size:18.0];
//    NSDictionary *labelFontDict = [NSDictionary dictionaryWithObject: labelFont forKey:NSFontAttributeName];
//    
//    double totalMinutes =[_cookingStage.cookTimeRequested integerValue];
//    int hour = totalMinutes / 60;
//    int minutes = fmod(totalMinutes, 60.0);
//
//    
//    NSMutableAttributedString *hourString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%d",hour] attributes: boldFontDict];
//    NSMutableAttributedString *hourLabel = [[NSMutableAttributedString alloc] initWithString:@"H : " attributes: labelFontDict];
//    NSMutableAttributedString *minuteString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%d",minutes] attributes: boldFontDict];
//    NSMutableAttributedString *minuteLabel = [[NSMutableAttributedString alloc] initWithString:@"MIN" attributes: labelFontDict];
//    NSMutableAttributedString *separator = [[NSMutableAttributedString alloc] initWithString:@"  |  " attributes: boldFontDict];
//    NSMutableAttributedString *temperature = [[NSMutableAttributedString alloc] initWithString:[_cookingStage.targetTemperature stringValue] attributes: boldFontDict];
//    NSMutableAttributedString *degreeString = [[NSMutableAttributedString alloc] initWithString:@"\u00b0" attributes:boldFontDict];
//    NSMutableAttributedString *temperatureLabel = [[NSMutableAttributedString alloc] initWithString:@" F" attributes: boldFontDict];
//    
//    [hourString appendAttributedString:hourLabel];
//    [hourString appendAttributedString:minuteString];
//    [hourString appendAttributedString:minuteLabel];
//    [hourString appendAttributedString:separator];
//    [hourString appendAttributedString:temperature];
//    [hourString appendAttributedString:degreeString];
//    [hourString appendAttributedString:temperatureLabel];
//    
//    [self.tempLabel setAttributedText:hourString];
//    [self.cookingLabel setText:_cookingStage.cookingLabel];
//    
    [self.actualTemperatureLabel setText:[_cookingStage.actualTemperature stringValue]];
#ifdef SIMULATE_PARAGON
    [self.currentParagon setSimulatorHeatingUpdateInterval:3000];
    [self.currentParagon setSimulatorHeatingTemperatureIncrement:1];
#endif
}

//TODO error handling/segue if we can't set the cook time
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    [self removeObservers];
    if ([segue.destinationViewController isKindOfClass:[FSTCookingViewController class]])
    {
        ((FSTCookingViewController*)segue.destinationViewController).currentParagon = self.currentParagon;
        [self.currentParagon setCookingTime:_cookingStage.cookTimeRequested];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)continueButtonTap:(id)sender {
    //TODO BONEYARD
    //[self performSegueWithIdentifier:@"segueCooking" sender:self];
    
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:@"Return to Main Menu"
                          message:@"Please turn off the burner on your unit to start a new session."
                          delegate:self cancelButtonTitle:@"" otherButtonTitles:@"OK", nil];
    
    alert.cancelButtonIndex = -1;
    [alert show];
}

#pragma mark - <UIAlertViewDelegate>

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

//TODO BONEYARD
- (IBAction)cancelButtonTap:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end
