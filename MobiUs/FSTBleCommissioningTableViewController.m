//
//  FSTBleCommissioningTableViewController.m
//  FirstBuild
//
//  Created by Myles Caley on 6/19/15.
//  Copyright (c) 2015 FirstBuild. All rights reserved.
//

#import <CoreBluetooth/CoreBluetooth.h>

#import "FSTBleCommissioningTableViewController.h"
//#import "FSTBleCentralManager.h"
#import "FSTBleConnectingViewController.h"

@interface FSTBleCommissioningTableViewController ()

@end

@implementation FSTBleCommissioningTableViewController

//array that stores the data for the table view
NSMutableArray* _devices; // just pass the selection rather than the devices

/*//observers
NSObject* _discoveryObserver;
NSObject* _undiscoveryObserver;
*/
//UIAlertView* _friendlyNamePrompt;
//NSString* _friendlyName;


CBPeripheral* _currentlySelectedPeripheral;


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
    NSString* label = [NSString stringWithFormat:@"%@,%@", peripheral.name, [peripheral.identifier UUIDString]]; // was NSString*
    
    cell.textLabel.text = label;
    [cell.textLabel setTextColor:[UIColor whiteColor]];
    [cell.textLabel setHighlightedTextColor:UIColorFromRGB(0x02B7CC)]; // lighter color
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
     /*  _friendlyNamePrompt = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Enter a name for this device", @"") message:nil delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:NSLocalizedString(@"OK", @""), nil];
    [_friendlyNamePrompt setAlertViewStyle:UIAlertViewStylePlainTextInput];
    _friendlyNamePrompt.tag = 1;
    [_friendlyNamePrompt show];
      */
    _currentlySelectedPeripheral = (CBPeripheral*)(_devices[indexPath.item]);
    [self.delegate getSelectedPeripheral:_currentlySelectedPeripheral]; // could combine these delegate methods
    [self.delegate paragonSelected]; // this will call the segue method.
    //[self performSegueWithIdentifier:@"segueConnecting" sender:self];
}

/*
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
} // moved to commissioning view controller


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
*/

@end
