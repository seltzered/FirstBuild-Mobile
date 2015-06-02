//
//  FSTReadyToPreheatViewController.m
//  FirstBuild
//
//  Created by Myles Caley on 5/12/15.
//  Copyright (c) 2015 FirstBuild. All rights reserved.
//

#import "FSTReadyToPreheatViewController.h"

@interface FSTReadyToPreheatViewController ()

@end

@implementation FSTReadyToPreheatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    FSTParagonCookingStage* stage = (FSTParagonCookingStage*)self.cookingMethod.session.paragonCookingStages[0];
    self.temperatureLabel.text = [[stage.targetTemperature stringValue] stringByAppendingString:@"\u00b0"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)cancelLabelClick:(id)sender {
    [self performSegueWithIdentifier:@"segueCancel" sender:self];
}
- (IBAction)tempTapMoveNextClick:(id)sender {
    [self performSegueWithIdentifier:@"seguePreheating" sender:self];
}


@end
