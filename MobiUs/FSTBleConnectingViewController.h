//
//  FSTBleConnectingViewController.h
//  FirstBuild
//
//  Created by Myles Caley on 6/22/15.
//  Copyright (c) 2015 FirstBuild. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreBluetooth/CoreBluetooth.h>

@interface FSTBleConnectingViewController : UIViewController

@property (nonatomic, strong) CBPeripheral* peripheral;
@property (nonatomic, strong) NSString* friendlyName;

@end
