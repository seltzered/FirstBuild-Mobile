//
//  FSTBleNamingViewController.h
//  FirstBuild
//
//  Created by John Nolan on 6/25/15.
//  Copyright (c) 2015 FirstBuild. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreBluetooth/CoreBluetooth.h>

@interface FSTBleNamingViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *paragonNameField;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (nonatomic, strong) CBPeripheral* peripheral;

@end
