//
//  FSTCookingStateViewController.m
//  FirstBuild
//
//  Created by John Nolan on 8/6/15.
//  Copyright (c) 2015 FirstBuild. All rights reserved.
//

#import "FSTCookingStateViewController.h"

@interface FSTCookingStateViewController ()

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
-(void) updatePercent { // hopefully when called wihthin the base class the sub classes should override it
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

-(double)calculatePercentWithTemp:(CGFloat)temp {
    CGFloat progress = 0; // defaults to this
    if (_targetTemp > _startingTemp) {
        if (temp > _startingTemp) {
            progress = (temp - _startingTemp)/(_targetTemp - _startingTemp);
            if ((progress * 100) > 100) {
                progress = 1.0f; // complete
            }
        }
    } else if (_targetTemp < _startingTemp) {
        // they should never be equal
        if (temp > _targetTemp) { // target temp is in the low range
            // want a positive denominator, and the percentage should reflect the distance to the target, although here it is negative
            progress = (_targetTemp - temp)/(_startingTemp - _targetTemp);
            if ((progress * 100) < -100) {
                progress = -1.0f;
                // complete blue tick marks
            } else if ((progress * 100) > 0) {
                progress = 0.0f;
                //pretty much cooled, but shot over, set it to zero
            }
        }
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

-(void)elapsedTimeChanged:(NSTimeInterval)elapsedTime {
    self.elapsedTime = elapsedTime;
    [self updatePercent];
    [self updateLabels];
}

-(void)burnerLevelChanged:(CGFloat)burnerLevel {
    self.burnerLevel = burnerLevel;
    [self updatePercent];
    [self updateLabels];
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
