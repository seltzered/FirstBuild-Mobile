//
//  FSTBleProduct.h
//  FirstBuild
//
//  Created by Myles Caley on 6/25/15.
//  Copyright (c) 2015 FirstBuild. All rights reserved.
//

#import "FSTProduct.h"
#import <CoreBluetooth/CoreBluetooth.h>

@interface FSTBleProduct : FSTProduct <CBPeripheralDelegate>

@property (strong,nonatomic) CBPeripheral* peripheral;

@end
