//
//  FSTPreheatingViewController.m
//  FirstBuild
//
//  Created by Myles Caley on 5/12/15.
//  Copyright (c) 2015 FirstBuild. All rights reserved.
//

#import "FSTPreheatingViewController.h"

@interface FSTPreheatingViewController ()

@end

@implementation FSTPreheatingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    self.currentParagon.delegate = self;
    FSTParagonCookingStage* stage = (FSTParagonCookingStage*)self.currentParagon.currentCookingMethod.session.paragonCookingStages[0];
    self.targetTemperatureLabel.text = [[stage.targetTemperature stringValue] stringByAppendingString:@"\u00b0 F"];
    
#ifdef SIMULATE_PARAGON
    [self.currentParagon startSimulatePreheat];
#endif
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)hackTapGesture:(id)sender {
    [self performSegueWithIdentifier:@"segueReadyToCook" sender:self];
}

- (void)actualTemperatureChanged:(NSNumber *)actualTemperature
{
    self.currentTemperatureLabel.text = [actualTemperature stringValue];
}


@end
