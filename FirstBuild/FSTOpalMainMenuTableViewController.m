//
//  FSTOpalMainMenuTableViewController.m
//  FirstBuild
//
//  Created by Myles Caley on 3/31/16.
//  Copyright © 2016 FirstBuild. All rights reserved.
//

#import "FSTOpalMainMenuTableViewController.h"
#import "FSTOpalScheduleTableViewController.h"
#import "FSTOpalScheduleViewController.h"

@interface FSTOpalMainMenuTableViewController ()

@end

@implementation FSTOpalMainMenuTableViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  [self.nightLightSwitchOutlet setOn:self.opal.nightLightOn];
  [self.scheduleEnabledSwitchOutlet setOn:self.opal.scheduleEnabled];
  self.statusLabelOutlet.text = self.opal.statusLabel;
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
  
  if ([tableView respondsToSelector:@selector(setSeparatorInset:)]) {
    [tableView setSeparatorInset:UIEdgeInsetsZero];
  }
  
  if ([tableView respondsToSelector:@selector(setLayoutMargins:)]) {
    [tableView setLayoutMargins:UIEdgeInsetsZero];
  }
  
  if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
    [cell setLayoutMargins:UIEdgeInsetsZero];
  }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
  if ([segue.destinationViewController isKindOfClass:[FSTOpalScheduleTableViewController class]])
  {
    FSTOpalScheduleTableViewController* vc = (FSTOpalScheduleTableViewController*)segue.destinationViewController;
    vc.opal = self.opal;
  }
  
  if([segue.destinationViewController isKindOfClass:[FSTOpalScheduleViewController class]])
  {
    FSTOpalScheduleViewController *vc = (FSTOpalScheduleViewController*)segue.destinationViewController;
    vc.opal = self.opal;
  }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return 4;
}


- (IBAction)nightLightSwitchAction:(id)sender {
  //hack, but re-enabled is in the opal delegate which is the FSTOpalViewController :( 
  self.nightLightSwitchOutlet.userInteractionEnabled = NO;
  [self.opal turnNightLightOn:!self.opal.nightLightOn];
}
- (IBAction)scheduleEnabledSwitchAction:(id)sender {
  self.scheduleEnabledSwitchOutlet.userInteractionEnabled = NO;
  [self.opal turnIceMakerScheduleOn:!self.opal.scheduleEnabled];
}

@end
