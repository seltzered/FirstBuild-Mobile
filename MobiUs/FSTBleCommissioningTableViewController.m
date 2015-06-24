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

//array that stores the data for the table view
NSMutableArray* _devices;

//observers
NSObject* _discoveryObserver;
NSObject* _undiscoveryObserver;

UIAlertView* _friendlyNamePrompt;
NSString* _friendlyName;


CBPeripheral* _currentlySelectedPeripheral;


- (void)viewDidLoad {
    [super viewDidLoad];
    
    _devices = [[NSMutableArray alloc]init];
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    
    //since we are using self in the block callback below we need to create a weak
    //reference so ARC can actually dealloc when the view  unload (and observers can removed in dealloc)
    __weak typeof(self) weakSelf = self;
    
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
            [weakSelf.tableView reloadData];
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
        [weakSelf.tableView reloadData];
    }];
    
    
    [[FSTBleCentralManager sharedInstance] scanForDevicesWithServiceUUIDString:@"e2779da7-0a82-4be7-b754-31ed3e727253"];
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
    NSString* label = [NSString stringWithFormat:@"%@,%@", peripheral.name, [peripheral.identifier UUIDString]]; // was NSString*
    
    cell.textLabel.text = label;
    [cell.textLabel setTextColor:[UIColor whiteColor]];
    [cell.textLabel setHighlightedTextColor:UIColorFromRGB(0x02B7CC)]; // lighter color
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
       _friendlyNamePrompt = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Enter a name for this device", @"") message:nil delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:NSLocalizedString(@"OK", @""), nil];
    [_friendlyNamePrompt setAlertViewStyle:UIAlertViewStylePlainTextInput];
    _friendlyNamePrompt.tag = 1;
    [_friendlyNamePrompt show];
    _currentlySelectedPeripheral = (CBPeripheral*)(_devices[indexPath.item]);
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    [self cleanup];
    
    if ([segue.identifier isEqualToString:@"segueConnecting"])
    {
        FSTBleConnectingViewController* vc = (FSTBleConnectingViewController*)segue.destinationViewController;
        vc.peripheral = _currentlySelectedPeripheral;
        vc.friendlyName = _friendlyName;
        
        [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
        // has a problem with dismissing the keyboard

    }
}


#pragma mark - UIAlertViewDelegate

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 1)
    {
        if (buttonIndex == 1)
        {
            _friendlyName =[alertView textFieldAtIndex:0].text;
            DLog(@"OK Pressed %@", _friendlyName);
            
            if (_friendlyName.length > 0)
            {
                [self.delegate paragonSelected]; // this will call the segue method.
                //[self performSegueWithIdentifier:@"segueConnecting" sender:self];
            }
            //TODO: error handling if friendlyName is empty
            //TODO: error handling if name already exists? overwrite?
        }
        else if (buttonIndex == 0)
        {
            DLog(@"Cancel Pressed");
        }
    }
}


@end
