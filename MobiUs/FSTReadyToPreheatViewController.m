//
//  FSTReadyToPreheatViewController.m
//  FirstBuild
//
//  Created by Myles Caley on 5/12/15.
//  Copyright (c) 2015 FirstBuild. All rights reserved.
//

#import "FSTReadyToPreheatViewController.h"
#import "FSTPreheatingViewController.h"

@interface FSTReadyToPreheatViewController ()

@end

@implementation FSTReadyToPreheatViewController

NSObject* _cookModeChangedObserver;


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    
    _cookModeChangedObserver = [center addObserverForName:FSTCookModeChangedNotification
                                                      object:nil
                                                       queue:nil
                                                  usingBlock:^(NSNotification *notification)
                                   {
                                       [self performSegueWithIdentifier:@"seguePreheating" sender:self];
                                   }];

}

- (void)viewWillAppear:(BOOL)animated
{
    //self.currentParagon.delegate = self;
    FSTParagonCookingStage* stage = (FSTParagonCookingStage*)self.currentParagon.currentCookingMethod.session.paragonCookingStages[0];
    self.temperatureLabel.text = [[stage.targetTemperature stringValue] stringByAppendingString:@"\u00b0"];
    
#ifdef SIMULATE_PARAGON
    [self.currentParagon startSimulateCookModeChanged];
#endif
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.destinationViewController isKindOfClass:[FSTPreheatingViewController class]])
    {
        ((FSTPreheatingViewController*)segue.destinationViewController).currentParagon = self.currentParagon;
    }
    [[NSNotificationCenter defaultCenter] removeObserver:_cookModeChangedObserver];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)cancelLabelClick:(id)sender {
    [self performSegueWithIdentifier:@"segueCancel" sender:self];
}


@end
