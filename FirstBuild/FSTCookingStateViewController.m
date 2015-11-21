//
//  FSTCookingStateViewController.m
//  FirstBuild
//
//  Created by John Nolan on 8/6/15.
//  Copyright (c) 2015 FirstBuild. All rights reserved.
//

#import "FSTCookingStateViewController.h"

@interface FSTCookingStateViewController ()
{
    CGFloat _startingTemp ;
}
@end

@implementation FSTCookingStateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

-(void) updatePercent {
}

-(void) updateLabels {
    
}

- (double)calculatePercent:(NSTimeInterval)fromTime toTime:(NSTimeInterval)toTime {

    if ((toTime > 0) && (fromTime > 0)) {
        
        CGFloat progress = 0;
        
        progress = fromTime / toTime;
        
        if ((progress * 100) > 100) {
            progress = 1.0f;
        }
        
        return progress;
    }
    else {
        return 0.0f;
    }
}

-(double)calculatePercentWithTemp {
    CGFloat progress = 0; // defaults to this
    
    // if target is greater than current then we are heating, thus
    // preheating, otherwise we are cooling down to temperature
    // and need to calculate the % diff
    if (_targetTemp > _currentTemp)
    {
        progress = (_currentTemp/_targetTemp);
        
        if ((progress * 100) > 100)
        {
            progress = 1.0f; // complete
        }
    }
    else
    {
        if (!_startingTemp)
        {
            _startingTemp = _currentTemp;
        }
        progress = 1 - (_startingTemp - _currentTemp)/(_startingTemp - _targetTemp);
        if (progress <=0)
        {
            progress = 0.0f; //complete
        }
        
        // kind of a hack, make it negative so the reaching temperature
        // layer knows this is a cooling view
        progress = progress * -1;
        
    }

    return progress;
}

#pragma mark - <CookingViewControllerDelegate>

-(void)targetTemperatureChanged:(CGFloat)targetTemperature {
    self.targetTemp = targetTemperature;
    [self updatePercent]; // write new value and update layer, happens for every variable
    [self updateLabels]; // same for the labels
}

-(void)currentTemperatureChanged:(CGFloat)currentTemperature {
    self.currentTemp = currentTemperature;
    [self updatePercent];
    [self updateLabels];
}

-(void)targetTimeChanged:(NSTimeInterval)minTime withMax:(NSTimeInterval) maxTime  {
    self.targetMinTime = minTime;
    self.targetMaxTime = maxTime;
    [self updatePercent];
    [self updateLabels];
}

-(void)remainingHoldTimeChanged:(NSTimeInterval)remainingHoldTime {
    self.remainingHoldTime = remainingHoldTime;
    [self updatePercent];
    [self updateLabels];
}

-(void)burnerLevelChanged:(CGFloat)burnerLevel {
    self.burnerLevel = burnerLevel;
    [self updatePercent];
    [self updateLabels];
}

@end
