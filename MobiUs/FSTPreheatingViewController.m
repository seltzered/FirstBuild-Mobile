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

FSTParagonCookingStage* _cookingStage;


- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    self.currentParagon.delegate = self;
    _cookingStage = (FSTParagonCookingStage*)(self.currentParagon.currentCookingMethod.session.paragonCookingStages[0]);
    FSTParagonCookingStage* stage = (FSTParagonCookingStage*)self.currentParagon.currentCookingMethod.session.paragonCookingStages[0];
    self.targetTemperatureLabel.text = [[stage.targetTemperature stringValue] stringByAppendingString:@"\u00b0 F"];
    
#ifdef SIMULATE_PARAGON
    [self.currentParagon startSimulatePreheat];
#endif
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    self.currentParagon.delegate = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)actualTemperatureChanged:(NSNumber *)actualTemperature
{
    self.currentTemperatureLabel.text = [actualTemperature stringValue];
    
    if ([actualTemperature doubleValue] >= [_cookingStage.targetTemperature doubleValue])
    {
        [self performSegueWithIdentifier:@"segueReadyToCook" sender:self];
    }
}


@end
