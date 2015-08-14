//
//  FSTBleConnectingViewController.h
//  FirstBuild
//
//  Created by Myles Caley on 6/22/15.
//  Copyright (c) 2015 FirstBuild. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreBluetooth/CoreBluetooth.h>

@interface FSTBleConnectingViewController : UIViewController <CBPeripheralDelegate>

@property (nonatomic, weak) CBPeripheral* peripheral;
@property (nonatomic, strong) NSString* friendlyName;
@property (weak, nonatomic) IBOutlet UIImageView *searchingIcon;
@property (weak) Class bleProductClassName;
@end
