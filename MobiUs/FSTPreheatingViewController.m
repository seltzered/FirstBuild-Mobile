//
//  FSTPreheatingViewController.m
//  FirstBuild
//
//  Created by Myles Caley on 5/12/15.
//  Copyright (c) 2015 FirstBuild. All rights reserved.
//

#import "FSTPreheatingViewController.h"
#import "FSTReadyToCookViewController.h"

@interface FSTPreheatingViewController ()

@end

@implementation FSTPreheatingViewController

FSTParagonCookingStage* _cookingStage;

//bottom of the scrollview
CGFloat _scrollViewBottom;

//max size of the scrollview
CGFloat _scrollViewSizeYMax;

//min start temperature
CGFloat _minTemperatureDegrees = 72;

//target temperature - min temperature
CGFloat _rangeMinAndMaxTemperatures ;

//how much to change with each temperature increment
CGFloat _heightIncrementOnChange;

//the height of the label, need to discount that in our calculations
CGFloat _temperatureViewHeight;

NSObject* _temperatureChangedObserver;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    _cookingStage = (FSTParagonCookingStage*)(self.currentParagon.currentCookingMethod.session.paragonCookingStages[0]);
    _temperatureChangedObserver = [center addObserverForName:FSTActualTemperatureChangedNotification
                        object:self.currentParagon
                         queue:nil
                    usingBlock:^(NSNotification *notification)
    {
        
        NSNumber* actualTemperature = _cookingStage.actualTemperature;
        self.currentTemperatureLabel.text = [actualTemperature stringValue];
        
        if ([actualTemperature doubleValue] >= [_cookingStage.targetTemperature doubleValue])
        {
            [self performSegueWithIdentifier:@"segueReadyToCook" sender:self];
        }
        
        CGFloat newTemp = [actualTemperature doubleValue] ;
        
        //find the temperature in proportion to the view
        CGFloat newHeight = _heightIncrementOnChange*(newTemp - _minTemperatureDegrees) + _temperatureViewHeight;
        CGFloat newYOrigin = _scrollViewBottom - newHeight - _temperatureViewHeight;
        
        //create and set the new frame
        CGRect frame = self.temperatureScrollerView.frame;
        self.temperatureScrollerHeightConstraint.constant = newHeight;
        [self.temperatureScrollerView needsUpdateConstraints];
        frame.origin.y = newYOrigin;
        frame.size.height = newHeight;
        self.temperatureScrollerView.frame = frame;
        
        self.temperatureScrollerView.hidden = NO;
       
    }];
    
}

-(void)viewDidLayoutSubviews
{
    _scrollViewBottom = self.buttonWrapperView.frame.origin.y - _temperatureViewHeight - self.scrollerViewDistanceFromClosestUIElementConstraint.constant;

    CGFloat scrollViewTopMax = self.topOrangeBarView.frame.origin.y + self.topOrangeBarView.frame.size.height;
    CGFloat scrollViewSizeYMax = _scrollViewBottom - scrollViewTopMax;
    
    _rangeMinAndMaxTemperatures = [_cookingStage.targetTemperature doubleValue] - _minTemperatureDegrees;
    _heightIncrementOnChange = scrollViewSizeYMax / _rangeMinAndMaxTemperatures;
}

- (void)viewWillAppear:(BOOL)animated
{
    _cookingStage = (FSTParagonCookingStage*)(self.currentParagon.currentCookingMethod.session.paragonCookingStages[0]);
    FSTParagonCookingStage* stage = (FSTParagonCookingStage*)self.currentParagon.currentCookingMethod.session.paragonCookingStages[0];
    self.targetTemperatureLabel.text = [[stage.targetTemperature stringValue] stringByAppendingString:@"\u00b0 F"];
    self.temperatureScrollerView.hidden = YES;
     _temperatureViewHeight = self.temperatureBox.frame.origin.y + self.temperatureBox.frame.size.height;
   
#ifdef SIMULATE_PARAGON
    [self.currentParagon startSimulateHeating];
    [self.currentParagon setSimulatorHeatingTemperatureIncrement:1];
    [self.currentParagon setSimulatorHeatingUpdateInterval:50];
#endif
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    [[NSNotificationCenter defaultCenter] removeObserver:_temperatureChangedObserver];
    if ([segue.destinationViewController isKindOfClass:[FSTReadyToCookViewController class]])
    {
        ((FSTReadyToCookViewController*)segue.destinationViewController).currentParagon = self.currentParagon;
    }    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
