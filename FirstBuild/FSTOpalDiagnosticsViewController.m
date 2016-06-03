//
//  FSTOpalDiagnosticsViewController.m
//  FirstBuild
//
//  Created by Myles Caley on 4/27/16.
//  Copyright © 2016 FirstBuild. All rights reserved.
//

#import "FSTOpalDiagnosticsViewController.h"
#import "FSTOpalTemperatureViewController.h"

@implementation FSTOpalDiagnosticsViewController
{
  IBOutlet UILabel *bucketStatusOutlet;
  id previousOpalDelegate;
  IBOutlet UILabel *temperatureOutlet;
}

-(void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  previousOpalDelegate = self.currentOpal.delegate;
  self.currentOpal.delegate = self;
  [self setBucketLabel];
  temperatureOutlet.text = [NSString stringWithFormat:@"%d",self.currentOpal.temperature];
}

- (void)dealloc
{
  self.currentOpal.delegate = previousOpalDelegate;
}

-(void)setBucketLabel
{
  if (self.currentOpal.opalErrorCode == 0) {
    bucketStatusOutlet.text = @"Closed";
  } else if (self.currentOpal.opalErrorCode == 1) {
    bucketStatusOutlet.text = @"Open";
  } else {
    bucketStatusOutlet.text = @"Unknown";
  }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
  UINavigationController* nc = segue.destinationViewController;
  ((FSTOpalTemperatureViewController*)nc.viewControllers[0]).opal = self.currentOpal;

}

-(void) iceMakerErrorChanged
{
  [self setBucketLabel];
}

-(void) iceMakerTemperatureChanged:(int)temperature
{
  temperatureOutlet.text = [NSString stringWithFormat:@"%d",temperature];
}
- (IBAction)emailTapAction:(id)sender
{
  [self.currentOpal compileOpalLog];
  
}

@end
