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

NSObject* _deviceConnectedObserver;
CBCharacteristic* _manufacturerNameCharacteristic;

- (void)viewDidLoad {
    [super viewDidLoad];
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
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service
             error:(NSError *)error {
    
    for (CBCharacteristic *characteristic in service.characteristics)
    {
        NSLog(@"Discovered characteristic %@", characteristic);
        if ([[characteristic.UUID UUIDString] isEqualToString:@"2A29"])
        {
            _manufacturerNameCharacteristic = characteristic;
            [peripheral readValueForCharacteristic:_manufacturerNameCharacteristic];
        }
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    if (!error)
    {

        [self performSegueWithIdentifier:@"segueFound" sender:self]; // changed from segueFound
        [[FSTBleCentralManager sharedInstance] savePeripheral:self.peripheral havingUUIDString:[self.peripheral.identifier UUIDString] withName:@"My Paragon" className:self.bleProductClassName];
    }
    else
    {
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
    
    if ([segue.identifier isEqualToString:@"segueFound"]) {
        FSTBleFoundViewController *vc = segue.destinationViewController;
        vc.peripheral = self.peripheral; // we have to do this for a while don't we, is there a better way? // why does this happen later? after the connected screen! maybe it goes through segues through the navigation controller? need to dealloc something else?
        vc.bleProductClassName = self.bleProductClassName;
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
