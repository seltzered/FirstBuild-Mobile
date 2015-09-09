//
//  FSTBleCommissioningTableViewController.h
//  FirstBuild
//
//  Created by Myles Caley on 6/19/15.
//  Copyright (c) 2015 FirstBuild. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FSTBleCommissioningTableViewControllerDelegate

-(void)paragonSelected;

-(void)getSelectedPeripheral:(CBPeripheral*)peripheral;

@end
@interface FSTBleCommissioningTableViewController : UITableViewController <UIAlertViewDelegate>

@property (nonatomic, weak) id<FSTBleCommissioningTableViewControllerDelegate>delegate;
@property (nonatomic, strong) NSMutableArray* devices;
@end
