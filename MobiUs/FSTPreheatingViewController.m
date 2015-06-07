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

CGFloat _scrollViewTop;
CGFloat _scrollViewBottom;
CGFloat _scrollViewSizeY;
CGFloat _minTemperatureDegrees = 72;
CGFloat _rangeMinAndMaxTemperatures ;
CGFloat _heightIncrementOnChange;
CGFloat _temperatureViewHeight;
NSMutableArray* _tempHeightLookup;

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
        CGFloat newHeight = _heightIncrementOnChange*(newTemp - _minTemperatureDegrees) + _temperatureViewHeight;
        CGFloat newYOrigin = _scrollViewBottom - newHeight - _temperatureViewHeight;
        
        CGRect frame = self.temperatureScrollerView.frame;
        
        self.temperatureScrollerHeightConstraint.constant = newHeight;
        [self.temperatureScrollerView needsUpdateConstraints];
        frame.origin.y = newYOrigin;
        frame.size.height = newHeight;
        self.temperatureScrollerView.frame = frame;
        self.temperatureScrollerView.hidden = NO;
//        NSLog(@" y origin %f, newHeight %f, scrollViewBottom %f, scrollViewTop %f, scrollViewSize %f", frame.origin.y, newHeight, _scrollViewBottom, _scrollViewTop, _scrollViewSizeY);
       
    }];
    
}

-(void)viewDidLayoutSubviews
{
    _scrollViewTop = self.topOrangeBarView.frame.origin.y + self.topOrangeBarView.frame.size.height;
    _scrollViewBottom = self.buttonWrapperView.frame.origin.y - _temperatureViewHeight;
    _scrollViewSizeY = _scrollViewBottom - _scrollViewTop;

    _rangeMinAndMaxTemperatures = [_cookingStage.targetTemperature doubleValue] - _minTemperatureDegrees;
    _heightIncrementOnChange = _scrollViewSizeY / _rangeMinAndMaxTemperatures;
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
    // Dispose of any resources that can be recreated.
}


@end
