//
//  FSTOpalViewController.m
//  FirstBuild
//
//  Created by Myles Caley on 3/22/16.
//  Copyright © 2016 FirstBuild. All rights reserved.
//

#import "FSTOpalViewController.h"
#import "FSTOpalMainMenuTableViewController.h"

@interface FSTOpalViewController ()


@end

@implementation FSTOpalViewController
{
  FSTOpalMainMenuTableViewController* tableVc;

  IBOutlet UIView *makeIceButtonOutlet;
  IBOutlet UILabel *iceMakerStatusLabelOutlet;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  self.opal.delegate = self;
  
  if (self.opal.iceMakerOn) {
    iceMakerStatusLabelOutlet.text = @"STOP MAKING ICE";
  } else {
    iceMakerStatusLabelOutlet.text = @"START MAKING ICE";
  }
  // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (IBAction)iceTapGestureAction:(id)sender {
  makeIceButtonOutlet.userInteractionEnabled = NO;
  [self.opal turnIceMakerOn:!self.opal.iceMakerOn];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
  if ([segue.destinationViewController isKindOfClass:[FSTOpalMainMenuTableViewController class]])
  {
    FSTOpalMainMenuTableViewController* vc = (FSTOpalMainMenuTableViewController*)segue.destinationViewController;
    tableVc = vc;
    vc.opal = self.opal;
  }
}

# pragma mark - delegate
-(void)iceMakerStatusChanged:(NSNumber *)status withLabel:(NSString *)label {
  NSLog(@"iceMakerStatusChanged: %d %@", status.intValue, label);
  tableVc.statusLabelOutlet.text = label;
}

#pragma mark - opal delegate
- (void)iceMakerLightChanged:(BOOL)on {
  NSLog(@"iceMakerLightChanged: %d", on);
  [tableVc.nightLightSwitchOutlet setOn:on];
  tableVc.nightLightSwitchOutlet.userInteractionEnabled = YES;
}

- (void)iceMakerModeChanged:(BOOL)on {
  makeIceButtonOutlet.userInteractionEnabled = YES;
  NSLog(@"iceMakerModeChanged: %d", on);
  if (self.opal.iceMakerOn) {
    iceMakerStatusLabelOutlet.text = @"STOP MAKING ICE";
  } else {
    iceMakerStatusLabelOutlet.text = @"START MAKING ICE";
  }
  //  [self.modeOutlet setOn:on];
  
}

#pragma mark - opal delegate
- (void)iceMakerCleanCycleChanged:(NSNumber *)cycle {
  NSLog(@"iceMakerCleanCycleChanged: %d", cycle.intValue);
  //  self.cleanCycleOutlet.text = cycle.stringValue;
}


@end
