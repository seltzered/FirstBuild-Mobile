//
//  FSTOpalMainMenuTableViewController.m
//  FirstBuild
//
//  Created by Myles Caley on 3/31/16.
//  Copyright © 2016 FirstBuild. All rights reserved.
//

#import "FSTOpalMainMenuTableViewController.h"
#import "FSTOpalScheduleTableViewController.h"

@interface FSTOpalMainMenuTableViewController ()

@end

@implementation FSTOpalMainMenuTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

-(void)viewWillAppear:(BOOL)animated {
   self.opal.delegate = self;
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
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

#pragma mark - opal delegate
- (void)iceMakerLightChanged:(BOOL)on {
  NSLog(@"iceMakerLightChanged: %d", on);
  //  [self.lightOutlet setOn:on];
}

- (void)iceMakerModeChanged:(BOOL)on {
  NSLog(@"iceMakerModeChanged: %d", on);
  //  [self.modeOutlet setOn:on];
  
}

@end
