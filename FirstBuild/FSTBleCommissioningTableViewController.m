//
//  FSTBleCommissioningTableViewController.m
//  FirstBuild
//
//  Created by Myles Caley on 6/19/15.
//  Copyright (c) 2015 FirstBuild. All rights reserved.
//

#import <CoreBluetooth/CoreBluetooth.h>

#import "FSTBleCommissioningTableViewController.h"
#import "FSTBleCentralManager.h"
#import "FSTBleConnectingViewController.h"

@interface FSTBleCommissioningTableViewController ()

@end

@implementation FSTBleCommissioningTableViewController
{
    //array that stores the data for the table view
    NSMutableArray* _devices; // just pass the selection rather than the devices
    CBPeripheral* _currentlySelectedPeripheral;
}

- (void)viewDidLoad {
    [super viewDidLoad];
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
    // Return the number of rows in the section.
    return _devices.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"bleDeviceCell" forIndexPath:indexPath];
    
    CBPeripheral* peripheral = (CBPeripheral*)(_devices[indexPath.item]);
    NSString* label = [NSString stringWithFormat:@"%@,%@", peripheral.name, [peripheral.identifier UUIDString]];
    
    cell.textLabel.text = label;
    [cell.textLabel setTextColor:[UIColor whiteColor]];
    [cell.textLabel setHighlightedTextColor:UIColorFromRGB(0x02B7CC)]; // lighter color
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    _currentlySelectedPeripheral = (CBPeripheral*)(_devices[indexPath.item]);
    [self.delegate getSelectedPeripheral:_currentlySelectedPeripheral]; // could combine these delegate methods
    [self.delegate paragonSelected]; // this will call the segue method.

}


@end
