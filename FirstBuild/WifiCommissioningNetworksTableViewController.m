//
//  WifiCommissioningNetworksTableViewController.m
//  FirstBuild-Mobile
//
//  Created by Myles Caley on 1/13/15.
//  Copyright (c) 2015 FirstBuild. All rights reserved.
//

#import "WifiCommissioningNetworksTableViewController.h"
#import "WifiCommissioningNetworkListViewController.h"
#import "WifiCommissioningNetworkTableViewCell.h"
#import <RestKit.h>
#import "FSTNetwork.h"

@interface WifiCommissioningNetworksTableViewController ()

@end

@implementation WifiCommissioningNetworksTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self loadNetworks];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.networks.count;
}

- (void)loadNetworks
{
    [[RKObjectManager sharedManager] getObjectsAtPath:@"/networks"
                                           parameters:nil
                                              success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                                  _networks = mappingResult.array;
                                                  [self.tableView reloadData];
                                                  if (_networks.count==0)
                                                  {
                                                      [self.parentViewController performSegueWithIdentifier:@"segueErrorNetworks" sender:self];
                                                  }
                                              }
                                              failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                                  [self.parentViewController performSegueWithIdentifier:@"segueErrorNetworks" sender:self];
                                              }];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    WifiCommissioningNetworkTableViewCell *cell = (WifiCommissioningNetworkTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"NetworkCell" forIndexPath:indexPath];
    FSTNetwork *network = _networks[indexPath.item];
    cell.label.text = network.ssid;
    return cell;
}

 -(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    WifiCommissioningNetworkListViewController* parentController = (WifiCommissioningNetworkListViewController*)self.parentViewController;
    parentController.selectedNetwork = _networks[indexPath.item];
    [parentController performSegueWithIdentifier:@"passwordSegue" sender:self];
}

@end
