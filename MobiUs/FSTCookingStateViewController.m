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

- (void) viewWillAppear:(BOOL)animated {
    [self.view addSubview:self.progressView]; // I want this to add on after it has been set in the subclass's view did load
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) updatePercent { // hopefully when called wihthin the base class the sub classes should override it
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
    if (temp > _startingTemp) {
        progress = (temp - _startingTemp)/(_targetTemp - _startingTemp);
        if ((progress * 100) > 100) {
            progress = 1.0f; // complete
        }
    }
    return progress;
}

#pragma mark - <CookingViewControllerDelegate>

-(void)targetTemperatureChanged:(CGFloat)targetTemperature {
    self.targetTemp = targetTemperature;
    [self updatePercent]; // write new value and update layer, happens for every variable
}

-(void)currentTemperatureChanged:(CGFloat)currentTemperature {
    self.currentTemp = currentTemperature;
    [self updatePercent];
}

-(void)targetTimeChanged:(NSTimeInterval)targetTime {
    self.targetTime = targetTime;
    [self updatePercent];
}

-(void)elapsedTimeChanged:(NSTimeInterval)elapsedTime {
    self.elapsedTime = elapsedTime;
    [self updatePercent];
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
