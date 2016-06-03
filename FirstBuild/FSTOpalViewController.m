//
//  FSTOpalViewController.m
//  FirstBuild
//
//  Created by Myles Caley on 3/22/16.
//  Copyright © 2016 FirstBuild. All rights reserved.
//

#import "FSTOpalViewController.h"
#import "FSTOpalMainMenuTableViewController.h"
#import "MBProgressHUD.h"
#import "MobiNavigationController.h"
#import "FSTRevealViewController.h"


@interface FSTOpalViewController ()


@end

@implementation FSTOpalViewController
{
  FSTOpalMainMenuTableViewController* tableVc;

  IBOutlet UIView *makeIceButtonOutlet;
  IBOutlet UILabel *iceMakerStatusLabelOutlet;
  
  MBProgressHUD *userActivityHud;
}

- (void)viewDidLoad {
  [super viewDidLoad];
}

-(void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  self.opal.delegate = self;
  
  if (self.opal.iceMakerOn) {
    iceMakerStatusLabelOutlet.text = @"STOP MAKING ICE";
  } else {
    iceMakerStatusLabelOutlet.text = @"START MAKING ICE";
  }
  
  MobiNavigationController* navigation = (MobiNavigationController*)self.navigationController;
  [navigation setHeaderText:@"OPAL" withFrameRect:CGRectMake(0, 0, 120, 30)];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (IBAction)iceTapGestureAction:(id)sender {
  makeIceButtonOutlet.userInteractionEnabled = NO;
  [self.opal turnIceMakerOn:!self.opal.iceMakerOn];
  
  UIWindow *window = [[UIApplication sharedApplication] keyWindow];
  UIView *view = window.rootViewController.view;
  [MBProgressHUD hideAllHUDsForView:view animated:YES];
  userActivityHud = [MBProgressHUD showHUDAddedTo:view animated:YES];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
  if ([segue.destinationViewController isKindOfClass:[FSTOpalMainMenuTableViewController class]])
  {
    FSTOpalMainMenuTableViewController* vc = (FSTOpalMainMenuTableViewController*)segue.destinationViewController;
    tableVc = vc;
    vc.opal = self.opal;
  }
}

-(void)hideHud {
  UIWindow *window = [[UIApplication sharedApplication] keyWindow];
  UIView *view = window.rootViewController.view;
  [MBProgressHUD hideAllHUDsForView:view animated:YES];
}

#pragma mark - opal delegate

-(void)iceMakerStatusChanged:(NSNumber *)status withLabel:(NSString *)label {
  NSLog(@"iceMakerStatusChanged: %d %@", status.intValue, label);
  tableVc.statusLabelOutlet.text = label;
}

- (void)iceMakerLightChanged:(BOOL)on {
  NSLog(@"iceMakerLightChanged: %d", on);
  [tableVc.nightLightSwitchOutlet setOn:on];
  tableVc.nightLightSwitchOutlet.userInteractionEnabled = YES;
}

-(void)iceMakerScheduleEnabledChanged:(BOOL)on {
  NSLog(@"iceMakerScheduleEnabledChanged: %d", on);
  [tableVc.scheduleEnabledSwitchOutlet setOn:on];
  tableVc.scheduleEnabledSwitchOutlet.userInteractionEnabled = YES;
}

- (void)iceMakerModeChanged:(BOOL)on {
  makeIceButtonOutlet.userInteractionEnabled = YES;
  
  [self hideHud];
  
  NSLog(@"iceMakerModeChanged: %d", on);
  if (self.opal.iceMakerOn) {
    iceMakerStatusLabelOutlet.text = @"STOP MAKING ICE";
  } else {
    iceMakerStatusLabelOutlet.text = @"START MAKING ICE";
  }
  //  [self.modeOutlet setOn:on];
  
}

- (void)iceMakerNightLightWritten: (NSError *)error {
  if (error) {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Oops"
                                                                             message:@"Opal must be ON to change the night light mode."
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *actionOk = [UIAlertAction actionWithTitle:@"OK"
                                                       style:UIAlertActionStyleDefault
                                                     handler:nil];
    [alertController addAction:actionOk];
    [self presentViewController:alertController animated:YES completion:nil];
  }
}

- (void)iceMakerScheduleWritten: (NSError *)error {
  // do nothing
}

- (void)iceMakerModeWritten: (NSError *)error {
    [self hideHud];
}

- (void)iceMakerCleanCycleChanged:(NSNumber *)cycle {
  NSLog(@"iceMakerCleanCycleChanged: %d", cycle.intValue);
}

- (IBAction)menuToggleTapAction:(id)sender {
  [self.revealViewController rightRevealToggle:self.opal]; 
}

@end
