//
//  FSTParagonMenuDiagnosticsViewController.m
//  FirstBuild
//
//  Created by Myles Caley on 11/9/15.
//  Copyright © 2015 FirstBuild. All rights reserved.
//

#import "FSTParagonMenuDiagnosticsViewController.h"
#import "FSTParagonMenuDiagnosticsStageTableViewController.h"

@interface FSTParagonMenuDiagnosticsViewController ()

@end

@implementation FSTParagonMenuDiagnosticsViewController
{
    id _oldParagonDelegate;
}
- (void)viewDidLoad {
    [super viewDidLoad];
//    _oldParagonDelegate = self.currentParagon.delegate;
//    self.currentParagon.delegate = self;

    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    ((FSTParagonMenuDiagnosticsStageTableViewController*)segue.destinationViewController).currentParagon = self.currentParagon;
    
    self.power.text = [self.currentParagon.session.currentPowerLevel stringValue];
    self.stage.text = [NSString stringWithFormat:@"%d", self.currentParagon.session.currentStageIndex];
    self.rawState.text = [NSString stringWithFormat:@"%d", self.currentParagon.session.cookState];
    self.temp.text = [self.currentParagon.session.currentProbeTemperature stringValue];
    switch (self.currentParagon.session.cookMode)
    {
        case FSTCookingDirectCooking:
            self.state.text = @"Direct";
            break;
        case FSTCookingStateOff:
            self.state.text = @"Off";
            break;
        case FSTCookingStatePrecisionCookingPastMaxTime:
            self.state.text = @"Past Max";
            break;
        case FSTCookingStatePrecisionCookingReachingMaxTime:
            self.state.text = @"Reach MaxT";
            break;
        case FSTCookingStatePrecisionCookingReachingMinTime:
            self.state.text = @"Reach MinT";
            break;
        case FSTCookingDirectCookingWithTime:
            self.state.text = @"D. Time";
            break;
        case FSTCookingStateUnknown:
            self.state.text = @"Unknown";
            break;
        case FSTCookingStatePrecisionCookingWithoutTime:
            self.state.text = @"P. No Time";
            break;
        case FSTCookingStatePrecisionCookingReachingTemperature:
            self.state.text = @"P. Reaching";
            break;
        case FSTCookingStatePrecisionCookingTemperatureReached:
            self.state.text = @"P. Reached";
            break;
    }
    
}

- (void)dealloc
{
//    self.currentParagon.delegate = _oldParagonDelegate;
}


@end
