//
//  ProductTableViewController.m
//  FirstBuild-Mobile
//
//  Created by Myles Caley on 10/7/14.
//  Copyright (c) 2014 FirstBuild. All rights reserved.
//

#import "ProductTableViewController.h"
#import "ProductTableViewCell.h"
#import <SWRevealViewController.h>
#import <RBStoryboardLink.h>
#import "FirebaseShared.h"
#import "FSTChillHub.h"
#import "FSTParagon.h"
#import "FSTHumanaPillBottle.h"
#import "ChillHubViewController.h"
#import "MobiNavigationController.h"
#import "FSTRecipeSubSelectionViewController.h"
#import "FSTBleCentralManager.h"
#import "FSTCookingViewController.h"
#import "FSTBleProduct.h"
#import "ProductGradientView.h" // to control up or down gradient
#import "FSTBleSavedProduct.h"
#import "FSTHoodie.h"
#import "FSTHoodieViewController.h"

#import "FSTCookingProgressLayer.h" //TODO: TEMP

@interface ProductTableViewController ()

@end

@implementation ProductTableViewController

#pragma mark - Private

static NSString * const reuseIdentifier = @"ProductCell";
static NSString * const reuseIdentifierParagon = @"ProductCellParagon";
NSObject* _connectedToBleObserver;
NSObject* _deviceReadyObserver;
NSObject* _newDeviceBoundObserver;
NSObject* _deviceRenamedObserver;
NSObject* _deviceEssentialDataChangedObserver;
NSObject* _deviceDisconnectedObserver;
NSObject* _deviceBatteryChangedObserver;
NSObject* _deviceConnectedObserver;
NSObject* _deviceLoadProgressUpdated;

NSIndexPath *_indexPathForDeletion;

#pragma mark - <UIViewDelegate>

//TODO: firebase objects
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.products = [[NSMutableArray alloc] init];
    [self.delegate itemCountChanged:0];
    
    //get all the saved BLE peripherals
    [self configureBleDevices];
    
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:_connectedToBleObserver];
    [[NSNotificationCenter defaultCenter] removeObserver:_deviceReadyObserver];
    [[NSNotificationCenter defaultCenter] removeObserver:_newDeviceBoundObserver];
    [[NSNotificationCenter defaultCenter] removeObserver:_deviceRenamedObserver];
    [[NSNotificationCenter defaultCenter] removeObserver:_deviceDisconnectedObserver];
    [[NSNotificationCenter defaultCenter] removeObserver:_deviceBatteryChangedObserver];
    [[NSNotificationCenter defaultCenter] removeObserver:_deviceConnectedObserver];
    [[NSNotificationCenter defaultCenter] removeObserver:_deviceLoadProgressUpdated];
    [[NSNotificationCenter defaultCenter] removeObserver:_deviceEssentialDataChangedObserver];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Device Configuration

-(void)configureBleDevices
{
    NSDictionary* savedDevices = [[FSTBleCentralManager sharedInstance] getSavedPeripherals];
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    __weak typeof(self) weakSelf = self;
    
    //grab all our saved products and put them in a product array
    for (id key in savedDevices)
    {
        FSTBleSavedProduct* savedProduct = [savedDevices objectForKeyedSubscript:key];
        FSTBleProduct* product = [[NSClassFromString(savedProduct.classNameString) alloc] init];
        product.online = NO;
        product.savedUuid = [[NSUUID alloc]initWithUUIDString:key];
        product.friendlyName = savedProduct.friendlyName;
        [self.products addObject:product];
        [self.delegate itemCountChanged:self.products.count];
    }
    
    //attempt to connect to the BLE devices
    if ([[FSTBleCentralManager sharedInstance] isPoweredOn])
    {
        [self connectBleDevices];
    }
    
    //also listen for power on signal before connecting to devices
    _connectedToBleObserver = [center addObserverForName:FSTBleCentralManagerPoweredOn
                                                  object:nil
                                                   queue:nil
                                              usingBlock:^(NSNotification *notification)
    {
       [weakSelf connectBleDevices];
    }];
    
    //when a device is connected check and see if we have it in our products list
    //we may get messages here about devices that are connected that are not saved yet (commissioning)
    //in that case we listen to FSTBleCentralManagerNewDeviceBound
    _deviceConnectedObserver = [center addObserverForName:FSTBleCentralManagerDeviceConnected
                                               object:nil
                                                queue:nil
                                           usingBlock:^(NSNotification *notification)
    {
        CBPeripheral* peripheral = (CBPeripheral*)(notification.object);
        
        //search through attached products and mark online anything we already have stored
        for (FSTProduct* product in weakSelf.products)
        {
            if ([product isKindOfClass:[FSTBleProduct class]])
            {
                FSTBleProduct* bleProduct = (FSTBleProduct*)product;
                
                //need to compare the strings and not the actual object since they are not the same
                if ([[bleProduct.savedUuid UUIDString] isEqualToString:[peripheral.identifier UUIDString]])
                {
                    bleProduct.peripheral = peripheral;
                    bleProduct.peripheral.delegate = bleProduct;
                    bleProduct.online = YES;
                    bleProduct.loading = YES;
                    DLog(@"discovering services for peripheral %@", peripheral.identifier);
                    [peripheral discoverServices:nil];
                    [weakSelf.tableView reloadData];
                }
            }
        }
    }];
    
    
    //critical data changed on something
    _deviceEssentialDataChangedObserver = [center addObserverForName:FSTDeviceEssentialDataChangedNotification
                                                   object:nil
                                                    queue:nil
                                               usingBlock:^(NSNotification *notification)
    {
        [weakSelf.tableView reloadData];
    }];

    
    //device is already connected, but a percentage of how much data is read and ready
    _deviceLoadProgressUpdated = [center addObserverForName:FSTDeviceLoadProgressUpdated
                                                     object:nil
                                                      queue:nil
                                                 usingBlock:^(NSNotification *notification)
    {
        [weakSelf.tableView reloadData];
    }];
    
    
    
    //this is once a device is ready for action, it will be device dependented and there will
    //be a call in the appropriate product class to send the notifcation
    _deviceReadyObserver = [center addObserverForName:FSTDeviceReadyNotification
                                                   object:nil
                                                    queue:nil
                                               usingBlock:^(NSNotification *notification)
    {
        CBPeripheral* peripheral = (CBPeripheral*)(notification.object);
        
        //search through attached products and mark online anything we already have stored
        for (FSTProduct* product in weakSelf.products)
        {
            if ([product isKindOfClass:[FSTBleProduct class]])
            {
                FSTBleProduct* bleProduct = (FSTBleProduct*)product;
                
                //need to compare the strings and not the actual object since they are not the same
                if ([[bleProduct.savedUuid UUIDString] isEqualToString:[peripheral.identifier UUIDString]])
                {
                    bleProduct.peripheral = peripheral;
                    bleProduct.peripheral.delegate = bleProduct;
                    
                    bleProduct.loading = NO;
                    [weakSelf.tableView reloadData];
                }
            }
        }
    }];
    
    //notify us of any new BLE devices that were added
    _newDeviceBoundObserver = [center addObserverForName:FSTBleCentralManagerNewDeviceBound
                                                  object:nil
                                                   queue:nil
                                              usingBlock:^(NSNotification *notification)
    {
        CBPeripheral* peripheral = (CBPeripheral*)(notification.object);
        
        //read all the products from the saved devices and find the new one by its UUID
        //then create a new BLE product based on the class type stored in the saved device
        NSDictionary* savedDevices = [[FSTBleCentralManager sharedInstance] getSavedPeripherals];
        FSTBleSavedProduct* savedProduct = [savedDevices objectForKeyedSubscript:[peripheral.identifier UUIDString]];
        FSTBleProduct* product = [[NSClassFromString(savedProduct.classNameString) alloc] init];
        
        //setup its delegates and status, and read the friendly name from the stored information
        product.online = YES;
        product.peripheral = peripheral;
        product.peripheral.delegate = product;
        product.savedUuid = peripheral.identifier;
        [product.peripheral discoverServices:nil];
        product.friendlyName = savedProduct.friendlyName;
        [self.products addObject:product];
        [self.delegate itemCountChanged:self.products.count];
        [weakSelf.tableView reloadData];
    }];
    
    //notify us of any BLE devices that were renamed
    _deviceRenamedObserver = [center addObserverForName:FSTBleCentralManagerDeviceNameChanged
                                                  object:nil
                                                   queue:nil
                                              usingBlock:^(NSNotification *notification)
    {
        CBPeripheral* peripheral = (CBPeripheral*)(notification.object);
        NSDictionary* savedDevices = [[FSTBleCentralManager sharedInstance] getSavedPeripherals];
        for (FSTProduct* product in weakSelf.products)
        {
            //get all ble products in the local products array
            if ([product isKindOfClass:[FSTBleProduct class]])
            {
                FSTBleProduct* bleProduct = (FSTBleProduct*)product;
                
                //search for ble peripheral that was renamed
                if (bleProduct.peripheral.identifier == peripheral.identifier)
                {
                    FSTBleSavedProduct* savedProduct = [savedDevices objectForKeyedSubscript:[peripheral.identifier UUIDString]];
                    //grab it from the saved list
                    bleProduct.friendlyName = savedProduct.friendlyName;
                    [weakSelf.tableView reloadData];
                    break;
                }
            }
        }
    }];
    
    //disconnected
    _deviceDisconnectedObserver = [center addObserverForName:FSTBleCentralManagerDeviceDisconnected
                                                       object:nil
                                                        queue:nil
                                                   usingBlock:^(NSNotification *notification)
    {
        CBPeripheral* peripheral = (CBPeripheral*)notification.object;
        
        for (FSTProduct* product in self.products)
        {
            if ([product isKindOfClass:[FSTBleProduct class]])
            {
                FSTBleProduct* bleDevice = (FSTBleProduct*)product;
                
                if (bleDevice.peripheral == peripheral)
                {
                    //since it is still in our list lets reconnect
                    bleDevice.online = NO;
                    bleDevice.loading = NO;
                    [[FSTBleCentralManager sharedInstance] connectToSavedPeripheralWithUUID:bleDevice.peripheral.identifier];
                    [weakSelf.tableView reloadData];
                }
            }
        }
    }];
    
    _deviceBatteryChangedObserver = [center addObserverForName:FSTBatteryLevelChangedNotification
                                                        object:nil
                                                         queue:nil
                                                    usingBlock:^(NSNotification *notification)
    {
        [weakSelf.tableView reloadData];
    }];
}

- (void)connectBleDevices
{
    for (FSTProduct* product in self.products)
    {
        if ([product isKindOfClass:[FSTBleProduct class]])
        {
            FSTBleProduct* bleDevice = (FSTBleProduct*)product;
            
            bleDevice.peripheral = [[FSTBleCentralManager sharedInstance] connectToSavedPeripheralWithUUID:bleDevice.savedUuid];
        }
    }
}

- (void) prepareForSegue: (UIStoryboardSegue *) segue sender: (id) sender
{
    RBStoryboardLink *destination = segue.destinationViewController;
    
    if ([sender isKindOfClass:[FSTParagon class]])
    {
        if ([destination.scene isKindOfClass:[FSTRecipeSubSelectionViewController class]])
        {
            FSTRecipeSubSelectionViewController *vc = (FSTRecipeSubSelectionViewController*)destination.scene;
            vc.currentParagon = sender;
        }
        else
        {
            DLog(@"seguing to nowhere...");
        }
    }
}

#pragma mark <UITableViewDataSource>

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.products.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FSTProduct * product = self.products[indexPath.row];
    ProductTableViewCell *productCell;
    
    if ([product isKindOfClass:[FSTParagon class]])
    {
        FSTParagon* paragon = (FSTParagon*)product; // cast it to check the cooking status
        productCell = [tableView dequeueReusableCellWithIdentifier:@"ProductCellParagon" forIndexPath:indexPath];
        productCell.friendlyName.text = product.friendlyName;
        
        
        if ([paragon.batteryLevel integerValue] == 0)
        {
            productCell.batteryLabel.text = @"probe\noffline";
        }
        else
        {
            productCell.batteryLabel.text = [NSString stringWithFormat:@"%ld%%", (long)[paragon.batteryLevel integerValue]];
        }
        
        productCell.batteryView.batteryLevel = [paragon.batteryLevel doubleValue]/100;
        [productCell.batteryView setNeedsDisplay]; // redraw
        //Taken out since those properties were not connected
        [productCell.statusLabel setText:@"---"];

        switch (paragon.session.cookMode)
        {
            case FSTCookingStateOff:
                [productCell.statusLabel setText:@"Off"];
                break;
            case FSTCookingStatePrecisionCookingReachingTemperature:
                if ([paragon.session.currentStage.targetTemperature intValue] > [paragon.session.currentProbeTemperature intValue])
                {
                    [productCell.statusLabel setText:@"Preheating"];
                }
                else
                {
                    [productCell.statusLabel setText:@"Cooling"];
                }
                break;
            case FSTCookingDirectCooking:
                [productCell.statusLabel setText:@"Direct"];
                break;
            case FSTCookingDirectCookingWithTime:
            case FSTCookingStatePrecisionCookingReachingMinTime:
            case FSTCookingStatePrecisionCookingWithoutTime:
                [productCell.statusLabel setText:@"Cooking"];
                break;
            case FSTCookingStatePrecisionCookingPastMaxTime:
            
            case FSTCookingStatePrecisionCookingReachingMaxTime:
                [productCell.statusLabel setText:@"Complete"];
                break;
            case FSTCookingStateUnknown:
                [productCell.statusLabel setText:@"-"];
                break;
            case FSTCookingStatePrecisionCookingCurrentStageDone:
            case FSTCookingStatePrecisionCookingTemperatureReached:
                [productCell.statusLabel setText:@"Waiting..."];
                break;
        }
    }
    
    // status label, online/offline etc
    if (product.online)
    {
        if (product.loading)
        {
            productCell.offlineLabel.hidden = YES;
            productCell.loadingProgressView.hidden = NO;
            productCell.loadingProgressView.progress = [((FSTParagon*)product).loadingProgress doubleValue];
            productCell.disabledView.hidden = NO;
            productCell.arrowButton.hidden = YES;
        }
        else
        {
            productCell.disabledView.hidden = YES;
            productCell.arrowButton.hidden = NO;
            productCell.loadingProgressView.hidden = YES;
            productCell.selectionStyle = UITableViewCellSelectionStyleDefault;
        }
    }
    else
    {
        productCell.offlineLabel.text = @"searching...";
        productCell.offlineLabel.hidden = NO;
        productCell.disabledView.hidden = NO;
        productCell.arrowButton.hidden = YES;
        productCell.loadingProgressView.hidden = YES;
        productCell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    return productCell;
}

#pragma mark <UITableViewDelegate>

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {

    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

-(void)viewDidLayoutSubviews
{
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    FSTProduct * product = self.products[indexPath.row];
    NSLog(@"selected %@", product);
    
    if ([product isKindOfClass:[FSTParagon class]])
    {
        FSTParagon* paragon = (FSTParagon*)product;
        UIStoryboard* board;
        
        switch (paragon.session.cookMode)
        {
            case FSTCookingStateUnknown:
            case FSTCookingStateOff:
                [self performSegueWithIdentifier:@"segueParagon" sender:product];
                break;
            case FSTCookingStatePrecisionCookingReachingTemperature:
            case FSTCookingStatePrecisionCookingReachingMinTime:
            case FSTCookingDirectCooking:
            case FSTCookingDirectCookingWithTime:
            case FSTCookingStatePrecisionCookingWithoutTime:
            case FSTCookingStatePrecisionCookingPastMaxTime:
            case FSTCookingStatePrecisionCookingReachingMaxTime:
            case FSTCookingStatePrecisionCookingTemperatureReached:
            case FSTCookingStatePrecisionCookingCurrentStageDone:
                board = [UIStoryboard storyboardWithName:@"FSTParagon" bundle:nil];
                FSTCookingViewController *vc = [board instantiateViewControllerWithIdentifier:@"FSTCookingViewController"] ;
                vc.currentParagon = paragon;
                [self.navigationController pushViewController:vc animated:YES];
                break;

        }
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120.0; // edit hight of table view cell
}

-(BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    FSTProduct *product = self.products[indexPath.row];
    
    if (!product.loading) {
        
        return true;
    } else {
        return false;
    }
}

-(BOOL)tableView: (UITableView*)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return true; // can delete all
}


-(void)tableView: (UITableView*)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSLog(@"delete");
        FSTBleProduct * deletedItem = self.products[indexPath.item];
        [self.products removeObjectAtIndex:indexPath.item];
        [[FSTBleCentralManager sharedInstance] deleteSavedPeripheralWithUUIDString: [deletedItem.peripheral.identifier UUIDString]];
        [[FSTBleCentralManager sharedInstance] disconnectPeripheral:deletedItem.peripheral];
        [self.tableView reloadData];
        
        if (self.products.count==0)
        {
            [self.delegate itemCountChanged:0];
        }
    }
}
@end
