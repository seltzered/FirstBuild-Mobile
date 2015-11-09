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
    
    switch (self.currentParagon.cookMode)
    {
        case FSTCookingDirectCooking:
            self.state.text = @"Direct Cooking";
            break;
        case FSTCookingStateOff:
            self.state.text = @"Off";
            break;
        case FSTCookingStatePrecisionCookingPastMaxTime:
            self.state.text = @"Cooking Past Max Time";
            break;
        case FSTCookingStatePrecisionCookingReachingMaxTime:
            self.state.text = @"Cooking Reaching Max TIme";
            break;
        case FSTCookingStatePrecisionCookingReachingMinTime:
            self.state.text = @"Cooking Reaching Min Time";
            break;
        case FSTCookingDirectCookingWithTime:
            self.state.text = @"Direct Cooking - With Time";
            break;
        case FSTCookingStateUnknown:
            self.state.text = @"Unknown";
            break;
        case FSTCookingStatePrecisionCookingWithoutTime:
            self.state.text = @"Cooking Without Time";
            break;
        case FSTCookingStatePrecisionCookingReachingTemperature:
            self.state.text = @"Cooking Reaching Temperature";
            break;
        case FSTCookingStatePrecisionCookingTemperatureReached:
            self.state.text = @"Temperature Reached";
            break;
    }
    
}

- (void)dealloc
{
//    self.currentParagon.delegate = _oldParagonDelegate;
}


@end
