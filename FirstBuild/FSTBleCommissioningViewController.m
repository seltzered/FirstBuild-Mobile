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
#import "UIAlertView+Blocks.h"

#import "FSTParagon.h"
#import "FSTPizzaOven.h"
#import "FSTOpal.h"

@interface FSTBleCommissioningViewController ()

@end

@implementation FSTBleCommissioningViewController
{
    NSMutableArray* _devices;
    
    NSObject* _discoveryObserver;
    NSObject* _undiscoveryObserver;
    NSTimer* _maxDiscoveryTimer;
}



FSTBleCommissioningTableViewController* tableController; // need to hold it to access tableView

CBPeripheral* _currentlySelectedPeripheral;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.singletonView.hidden = false; //false; // defaults to searching view
    //--moved from commissioning view controller---//
    _devices = [[NSMutableArray alloc]init];
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    
    //since we are using self in the block callback below we need to create a weak
    //reference so ARC can actually dealloc when the view  unload (and observers can removed in dealloc)
    __weak typeof(self) weakSelf = self;
    __weak typeof(_devices) weakDevices = _devices;
    
    _discoveryObserver = [center addObserverForName:FSTBleCentralManagerDeviceFound
                                             object:nil
                                              queue:nil
                                         usingBlock:^(NSNotification *notification)
    {
        CBPeripheral* peripheral = (CBPeripheral*)notification.object;
        BOOL found = NO;

        DLog("found a peripheral and was notified in ble commissioning %@", [peripheral.identifier UUIDString]);

        for (CBPeripheral* p in weakDevices)
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
            [weakDevices addObject:peripheral];
            tableController.devices = weakDevices;
            [tableController.tableView reloadData];
        }
        else
        {
            DLog(@"peripheral already exists in table");
        }

        if ([weakDevices count] > 1) {
            weakSelf.singletonView.hidden = true;
        }
        else
        {
            weakSelf.singletonView.hidden = false;
            if ([weakDevices count] == 1)
            {
                _currentlySelectedPeripheral = weakDevices[0];
                [weakSelf performSegueWithIdentifier:@"plainConnectingSegue" sender:weakSelf];
            }
        }
    }];
    
    _undiscoveryObserver = [center addObserverForName:FSTBleCentralManagerDeviceUnFound
                                               object:nil
                                                queue:nil
                                           usingBlock:^(NSNotification *notification)
    {
        CBPeripheral* peripheral = (CBPeripheral*)notification.object;
        
        [weakDevices removeObject:peripheral];
        DLog(@"device undiscovered %@", [peripheral.identifier UUIDString]);
        tableController.devices = weakDevices; // reset table data
        [tableController.tableView reloadData];
        
        if ([weakDevices count] > 1)
        {
            weakSelf.singletonView.hidden = true;
        }
        else
        {
            weakSelf.singletonView.hidden = false;
            if ([weakDevices count] == 1)
            {
                _currentlySelectedPeripheral = weakDevices[0];
                [weakSelf performSegueWithIdentifier:@"plainConnectingSegue" sender:weakSelf];
            }
        }
    }];
    
    //TODO: rethink this approach / decouple a bit more
    //TODO: service advertisement is the same for paragon and BLE ACM
    if(self.bleProductClass == [FSTParagon class])
    {
        [[FSTBleCentralManager sharedInstance] scanForDevicesWithServiceUUIDString:@"e2779da7-0a82-4be7-b754-31ed3e727253"];
    }
    else if(self.bleProductClass == [FSTPizzaOven class])
    {
        [[FSTBleCentralManager sharedInstance] scanForDevicesWithServiceUUIDString:@"13333333-3333-3333-3333-333333333337"];
    }
    else if(self.bleProductClass == [FSTOpal class])
    {
      [[FSTBleCentralManager sharedInstance] scanForDevicesWithServiceUUIDString:@"E2779DA7-0A82-4BE7-B754-31ED3E727253"];
    }
    
    [self.wheelBackground.layer setCornerRadius:self.wheelBackground.frame.size.width/2]; // make it a circle
    
    // animate singleton view
    NSMutableArray *imgListArray = [NSMutableArray array];
    for (int i=11; i <= 33; i++) {
        NSString *strImgeName = [NSString stringWithFormat:@"pulsing rings_%05d.png", i];
        UIImage *image = [UIImage imageNamed:strImgeName];
        if (!image) {
            NSLog(@"Could not load image named: %@", strImgeName);
        }
        else {
            [imgListArray addObject:image];
        }
    }
    
    [self.searchingIcon setAnimationImages:imgListArray];
    [self.searchingIcon setAnimationDuration:.75];
    [self.searchingIcon startAnimating];
    
    _maxDiscoveryTimer = [NSTimer scheduledTimerWithTimeInterval:60 target:weakSelf selector:@selector(maxDiscoveryTimeoutHandler:) userInfo:nil repeats:NO];
}

-(void)viewWillDisappear:(BOOL)animated

{
    [super viewWillDisappear:animated];
    [_maxDiscoveryTimer invalidate];
    _maxDiscoveryTimer = nil;
}

- (void)maxDiscoveryTimeoutHandler:(NSTimer*)timer

{
    __weak typeof(self) weakSelf = self;

    [UIAlertView showWithTitle:@"Continue Searching?"
                       message:@"The device cannot be found, please be sure it is plugged in and you are close to the device."

             cancelButtonTitle:@"Cancel Search"
             otherButtonTitles:@[@"Continue Searching"]
                      tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
                          if (buttonIndex == [alertView cancelButtonIndex])
                          {
                              NSLog(@"search cancelled");
                              [weakSelf.navigationController popToRootViewControllerAnimated:YES];
                          }
                          else if ([[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:@"Continue Searching"])

                          {
                              NSLog(@"continue search");
                              _maxDiscoveryTimer = [NSTimer scheduledTimerWithTimeInterval:60 target:weakSelf selector:@selector(maxDiscoveryTimeoutHandler:) userInfo:nil repeats:NO];

                          }
                      }];
    
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
    if ([segue.identifier isEqualToString:@"connectingSegue"])
    {
        FSTBleConnectingViewController* vc = (FSTBleConnectingViewController*)segue.destinationViewController;
        vc.peripheral = _currentlySelectedPeripheral;
        vc.friendlyName = @"My Device 1";  // dummy name //_friendlyName;
        vc.bleProductClass = self.bleProductClass;
        [self cleanup];
       // [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
        // has a problem with dismissing the keyboard
        
    } else if ([segue.identifier isEqualToString:@"plainConnectingSegue"]) {
        FSTBleConnectingViewController* vc = (FSTBleConnectingViewController*)segue.destinationViewController;
        vc.peripheral = _currentlySelectedPeripheral;
        vc.bleProductClass = self.bleProductClass;
        [self cleanup];
        vc.friendlyName = @"My Device 1";  // dummy name //_friendlyName;
        
    }else if ([segue.identifier isEqualToString:@"tableSegue"]) {
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
