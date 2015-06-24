//
//  FSTBleConnectingViewController.m
//  FirstBuild
//
//  Created by Myles Caley on 6/22/15.
//  Copyright (c) 2015 FirstBuild. All rights reserved.
//

#import "FSTBleConnectingViewController.h"
#import "FSTBleCentralManager.h"

@interface FSTBleConnectingViewController ()

@end

@implementation FSTBleConnectingViewController

NSObject* _deviceConnectedObserver;

- (void)viewDidLoad {
    [super viewDidLoad];
    
        
    __weak typeof(self) weakSelf = self;
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];

    _deviceConnectedObserver = [center addObserverForName:FSTBleCentralManagerDeviceConnected
                                               object:nil
                                                queue:nil
                                           usingBlock:^(NSNotification *notification)
    {
        if (weakSelf.peripheral == (CBPeripheral*)notification.object)
        {
            
            [[FSTBleCentralManager sharedInstance] savePeripheralHavingUUIDString:[weakSelf.peripheral.identifier UUIDString] withName:self.friendlyName];
            [weakSelf performSegueWithIdentifier:@"segueConnected" sender:self];
        }
    }];
    
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

}

-(void)dealloc
{
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
