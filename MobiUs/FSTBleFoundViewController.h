//
//  FSTBleFoundViewController.h
//  FirstBuild
//
//  Created by John Nolan on 6/24/15.
//  Copyright (c) 2015 FirstBuild. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreBluetooth/CoreBluetooth.h>

@interface FSTBleFoundViewController : UIViewController

@property (nonatomic, weak) CBPeripheral* peripheral;
@end
