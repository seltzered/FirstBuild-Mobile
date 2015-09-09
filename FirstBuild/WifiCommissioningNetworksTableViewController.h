//
//  WifiCommissioningNetworksTableViewController.h
//  FirstBuild-Mobile
//
//  Created by Myles Caley on 1/13/15.
//  Copyright (c) 2015 FirstBuild. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WifiCommissioningNetworksTableViewController : UITableViewController
@property (nonatomic, strong) NSArray *networks;
- (void)loadNetworks;
@end
