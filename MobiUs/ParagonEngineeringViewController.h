//
//  ParagonViewController.h
//  FirstBuild
//
//  Created by Myles Caley on 3/12/15.
//  Copyright (c) 2015 FirstBuild. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreBluetooth/CoreBluetooth.h>


@interface ParagonEngineeringViewController : UIViewController <CBCentralManagerDelegate, CBPeripheralDelegate>

@property (nonatomic, strong) CBPeripheral* currentPeripheral;
@property (nonatomic, strong) CBCentralManager* centralManager;
@property (nonatomic, strong) CBPeripheralManager* peripheralManager;

@property (nonatomic, strong) CBCharacteristic* probeTemp;
@property (nonatomic, strong) CBCharacteristic* sousVideTemp;
@property (strong, nonatomic) IBOutlet UILabel *probeTempLabel;
@property (strong, nonatomic) IBOutlet UIPanGestureRecognizer *tempPanGesture;
@property (strong, nonatomic) IBOutlet UILabel *sousVideTempLabel;

@end
