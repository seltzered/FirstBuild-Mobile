//
//  FSTBleNamingViewController.h
//  FirstBuild
//
//  Created by John Nolan on 6/25/15.
//  Copyright (c) 2015 FirstBuild. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreBluetooth/CoreBluetooth.h>

@interface FSTBleNamingViewController : UIViewController <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *paragonNameField;
@property (nonatomic, weak) CBPeripheral* peripheral;

@end
