//
//  FSTBleCommissioningViewController.m
//  FirstBuild
//
//  Created by Myles Caley on 6/19/15.
//  Copyright (c) 2015 FirstBuild. All rights reserved.
//
#import <CoreBluetooth/CoreBluetooth.h>
#import "FSTBleCentralManager.h"
#import "FSTBleConnectingViewController.h"
#import "FSTBleCommissioningViewController.h"
#import "FSTBleCommissioningTableViewController.h"

@interface FSTBleCommissioningViewController ()

@end

@implementation FSTBleCommissioningViewController

NSMutableArray* _devices;

NSObject* _discoveryObserver;
NSObject* _undiscoveryObserver;

FSTBleCommissioningTableViewController* tableController; // need to hold it to access tableView

CBPeripheral* _currentlySelectedPeripheral;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //--moved from commissioning view controller---//
    _devices = [[NSMutableArray alloc]init];
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    
    //since we are using self in the block callback below we need to create a weak
    //reference so ARC can actually dealloc when the view  unload (and observers can removed in dealloc)
    //__weak typeof(self) weakSelf = self;
    
    _discoveryObserver = [center addObserverForName:FSTBleCentralManagerDeviceFound
                                             object:nil
                                              queue:nil
                                         usingBlock:^(NSNotification *notification)
                          {
                              CBPeripheral* peripheral = (CBPeripheral*)notification.object;
                              BOOL found = NO;
                              
                              DLog("found a peripheral and was notified in ble commissioning %@", [peripheral.identifier UUIDString]);
                              
                              for (CBPeripheral* p in _devices)
                              {
                                  if ([p isEqual:peripheral])
                                  {
                                      found = YES;
                                      return;
                                  }
                              }
                              
                              if (found==NO)
                              {
                                  DLog("peripheral doesn't exist adding to table");
                                  [_devices addObject:peripheral];
                                  //[weakSelf.tableView reloadData];
                                  tableController.devices = _devices; // reset table data
                                  [tableController.tableView reloadData]; // better way to do this? why only on second time
                                  //hopefully it doesn't happen before the segue (we could force the segue call earlier in this function)
                              }
                              else
                              {
                                  DLog(@"peripheral already exists in table");
                              }
                          }];
    
    _undiscoveryObserver = [center addObserverForName:FSTBleCentralManagerDeviceUnFound
                                               object:nil
                                                queue:nil
                                           usingBlock:^(NSNotification *notification)
                            {
                                CBPeripheral* peripheral = (CBPeripheral*)notification.object;
                                
                                [_devices removeObject:peripheral];
                                DLog(@"device undiscovered %@", [peripheral.identifier UUIDString]);
                                tableController.devices = _devices; // reset table data
                                [tableController.tableView reloadData];
                                //[weakSelf.tableView reloadData];
                            }];
    
    
    [[FSTBleCentralManager sharedInstance] scanForDevicesWithServiceUUIDString:@"e2779da7-0a82-4be7-b754-31ed3e727253"];
    
    [self.wheelBackground.layer setCornerRadius:self.wheelBackground.frame.size.width/2]; // make it a circle
}

-(void)dealloc
{
    [self cleanup];
}

-(void)cleanup
{
    [[FSTBleCentralManager sharedInstance] stopScanning];
    [[NSNotificationCenter defaultCenter] removeObserver:_discoveryObserver];
    [[NSNotificationCenter defaultCenter] removeObserver:_undiscoveryObserver];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    [self cleanup];
    
    if ([segue.identifier isEqualToString:@"connectingSegue"])
    {
        FSTBleConnectingViewController* vc = (FSTBleConnectingViewController*)segue.destinationViewController;
        vc.peripheral = _currentlySelectedPeripheral;
        vc.friendlyName = @"My Paragon 1";  // dummy name //_friendlyName;
        
        [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
        // has a problem with dismissing the keyboard
        
    } else if ([segue.identifier isEqualToString:@"tableSegue"]) {
        tableController = segue.destinationViewController; // this is where it initally sets
        tableController.devices = _devices;
        tableController.delegate = self;
    }
} // moved to commissioning view controller

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)getSelectedPeripheral:(CBPeripheral *)peripheral {
    _currentlySelectedPeripheral = peripheral; // peripherals between these two view controllers should be the same.
}
-(void)paragonSelected{
    [self performSegueWithIdentifier:@"connectingSegue" sender:self];
}

@end
