//
//  FSTBleConnectingViewController.m
//  FirstBuild
//
//  Created by Myles Caley on 6/22/15.
//  Copyright (c) 2015 FirstBuild. All rights reserved.
//

#import "FSTBleConnectingViewController.h"
#import "FSTBleCentralManager.h"
#import "FSTBleFoundViewController.h"

@interface FSTBleConnectingViewController ()

@end

@implementation FSTBleConnectingViewController
{
    
    NSObject* _deviceConnectedObserver;
    CBCharacteristic* _manufacturerNameCharacteristic;
    BOOL _segueInProgress;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _segueInProgress = NO;
    // not loading?
        
    __weak typeof(self) weakSelf = self;
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];

    _deviceConnectedObserver = [center addObserverForName:FSTBleCentralManagerDeviceConnected
                                               object:nil
                                                queue:nil
                                           usingBlock:^(NSNotification *notification)
    {
        if (weakSelf.peripheral == (CBPeripheral*)notification.object)
        {
            weakSelf.peripheral.delegate = weakSelf;
            
            NSUUID* uuid = [[NSUUID alloc]initWithUUIDString:@"Device Information"];
            NSArray* services = [[NSArray alloc] initWithObjects:uuid, nil];
            
            [weakSelf.peripheral discoverServices:services];
        }
    }];
    
    NSMutableArray *imgListArray = [NSMutableArray array];
    for (int i=11; i <= 33; i++)
    {
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
    
    self.navigationItem.hidesBackButton = YES;

}

- (void) peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error
{
    NSArray * services;
    services = [peripheral services];
    for (CBService *service in services)
    {
        if ([[service.UUID UUIDString] isEqualToString:@"180A"])
        {
            DLog(@"found device service");
            [peripheral discoverCharacteristics:nil forService:service];
        }
      // TODO: hack, the pi isn't showing the 180A server for whatever reason, so
      // hardcoding the pizza oven
        else if ([[service.UUID UUIDString] isEqualToString:@"13333333-3333-3333-3333-333333333337"])
        {
          DLog(@"found device service");
          [peripheral discoverCharacteristics:nil forService:service];
        }
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service
             error:(NSError *)error {
    
    for (CBCharacteristic *characteristic in service.characteristics)
    {
        NSLog(@"Discovered characteristic %@", characteristic);
        if ([[characteristic.UUID UUIDString] isEqualToString:@"2A29"] || [[characteristic.UUID UUIDString] isEqualToString:@"2A27"])
        {
            _manufacturerNameCharacteristic = characteristic;
            [peripheral readValueForCharacteristic:_manufacturerNameCharacteristic];
        }
      // TODO: hack, the pi isn't showing the 180A server for whatever reason, so
      // hardcoding the pizza oven
      else if ([[characteristic.UUID UUIDString] isEqualToString:@"13333333-3333-3333-3333-333333330003"])
      {
        [peripheral readValueForCharacteristic:characteristic];
      }
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    if (!error && !_segueInProgress)
    {
        [self performSegueWithIdentifier:@"segueFound" sender:self]; 
        [[FSTBleCentralManager sharedInstance] savePeripheral:self.peripheral havingUUIDString:[self.peripheral.identifier UUIDString] withName:@"My Paragon" className:self.bleProductClass];
    }
    else if (!_segueInProgress)
    {
        [[FSTBleCentralManager sharedInstance]disconnectPeripheral:peripheral];
        [self performSegueWithIdentifier:@"segueError" sender:self];
        DLog(@"<<<<<<FAILED TO READ CHARACTERISTIC, TERMINATE CONNECTION>>>>>>>>>>");
    }
}

-(void)dealloc 
{
    NSLog(@"dealloc");
    [[NSNotificationCenter defaultCenter] removeObserver:_deviceConnectedObserver];
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    _segueInProgress = YES;
    
    if ([segue.identifier isEqualToString:@"segueFound"]) {
        FSTBleFoundViewController *vc = segue.destinationViewController;
        vc.peripheral = self.peripheral; // we have to do this for a while don't we, is there a better way? // why does this happen later? after the connected screen! maybe it goes through segues through the navigation controller? need to dealloc something else?
        vc.bleProductClass = self.bleProductClass;
    }

    
    [[NSNotificationCenter defaultCenter] removeObserver:_deviceConnectedObserver];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [[FSTBleCentralManager sharedInstance] connectToNewPeripheral:self.peripheral];
}

@end
