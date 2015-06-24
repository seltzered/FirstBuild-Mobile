//
//  FSTBleCommissioningViewController.m
//  FirstBuild
//
//  Created by Myles Caley on 6/19/15.
//  Copyright (c) 2015 FirstBuild. All rights reserved.
//
#import <CoreBluetooth/CoreBluetooth.h>
#import "FSTBleCommissioningViewController.h"
#import "FSTBleCommissioningTableViewController.h"

@interface FSTBleCommissioningViewController ()

@end

@implementation FSTBleCommissioningViewController

NSMutableArray* devices;

NSObject* _discoveryObserver;
NSObject* _undiscoveryObserver;

UIAlertView* _friendlyNamePrompt;
NSString* _friendlyName;


CBPeripheral* _currentlySelectedPeripheral;

- (void)viewDidLoad {
    [super viewDidLoad];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"tableSegue"]) {
        FSTBleCommissioningTableViewController* tableController = segue.destinationViewController;
        tableController.devices = devices;
    }
}

@end
