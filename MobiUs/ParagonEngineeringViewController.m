//
//  ParagonViewController.m
//  FirstBuild
//
//  Created by Myles Caley on 3/12/15.
//  Copyright (c) 2015 FirstBuild. All rights reserved.
//

#import "ParagonEngineeringViewController.h"

@interface ParagonEngineeringViewController ()

@end

@implementation ParagonEngineeringViewController


-(void)viewDidLoad
{
    self.centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
}

- (IBAction)tempPanGestureAction:(UIPanGestureRecognizer*)sender {
    typedef NS_ENUM(NSUInteger, UIPanGestureRecognizerDirection) {
        UIPanGestureRecognizerDirectionUndefined,
        UIPanGestureRecognizerDirectionUp,
        UIPanGestureRecognizerDirectionDown,
        UIPanGestureRecognizerDirectionLeft,
        UIPanGestureRecognizerDirectionRight
    };
    
    static UIPanGestureRecognizerDirection direction = UIPanGestureRecognizerDirectionUndefined;
    
    switch (sender.state) {
            
        case UIGestureRecognizerStateBegan: {
            
            if (direction == UIPanGestureRecognizerDirectionUndefined) {
                
                CGPoint velocity = [sender velocityInView:self.tempPanGesture.view];
                
                BOOL isVerticalGesture = fabs(velocity.y) > fabs(velocity.x);
                
                if (isVerticalGesture) {
                    if (velocity.y > 0) {
                        direction = UIPanGestureRecognizerDirectionDown;
                    } else {
                        direction = UIPanGestureRecognizerDirectionUp;
                    }
                }
                
                else {
                    if (velocity.x > 0) {
                        direction = UIPanGestureRecognizerDirectionRight;
                    } else {
                        direction = UIPanGestureRecognizerDirectionLeft;
                    }
                }
            }
            
            break;
        }
            
        case UIGestureRecognizerStateChanged: {
            switch (direction) {
                case UIPanGestureRecognizerDirectionUp: {
                    [self handleUpwardsGesture:sender];
                    break;
                }
                case UIPanGestureRecognizerDirectionDown: {
                    [self handleDownwardsGesture:sender];
                    break;
                }
                case UIPanGestureRecognizerDirectionLeft: {
                    [self handleLeftGesture:sender];
                    break;
                }
                case UIPanGestureRecognizerDirectionRight: {
                    [self handleRightGesture:sender];
                    break;
                }
                default: {
                    break;
                }
            }
        }
            
        case UIGestureRecognizerStateEnded: {
            direction = UIPanGestureRecognizerDirectionUndefined;
            break;
        }
            
        default:
            break;
    }
    
}

- (void)handleUpwardsGesture:(UIPanGestureRecognizer *)sender
{
    NSInteger newValue = [[self.sousVideTempLabel text] integerValue] + 1;
    self.sousVideTempLabel.text = [NSString stringWithFormat:@"%ld", (long)newValue];
    
    Byte bytes[2] ;
    
    bytes[0] = 0;
    bytes[1] = newValue;
    NSData *data = [[NSData alloc]initWithBytes:bytes length:2];
    
    NSLog(@"more %02x", bytes[1] );

    if (self.sousVideTemp)
    {
        NSLog(@"writing new up temp...");
        [self.currentPeripheral writeValue:data forCharacteristic:self.sousVideTemp type:CBCharacteristicWriteWithResponse];
    }
    
}

- (void)handleDownwardsGesture:(UIPanGestureRecognizer *)sender
{
    NSInteger newValue = [[self.sousVideTempLabel text] integerValue] - 1;
    self.sousVideTempLabel.text = [NSString stringWithFormat:@"%ld", (long)newValue];
    
    Byte bytes[2] ;
    
    bytes[0] = 0;
    bytes[1] = newValue;
    NSData *data = [[NSData alloc]initWithBytes:bytes length:2];
    
    NSLog(@"more %02x", bytes[1] );
    
    if (self.sousVideTemp)
    {
        NSLog(@"writing new down temp...");
        [self.currentPeripheral writeValue:data forCharacteristic:self.sousVideTemp type:CBCharacteristicWriteWithResponse];
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    NSLog(@" writing characteristic value: %@", [error localizedDescription]);
}

- (void)handleLeftGesture:(UIPanGestureRecognizer *)sender
{
    NSLog(@"Left");
}

- (void)handleRightGesture:(UIPanGestureRecognizer *)sender
{
    NSLog(@"Right");
}

-(void)viewWillDisappear:(BOOL)animated
{
    [self.centralManager cancelPeripheralConnection:self.currentPeripheral];
    [self.centralManager stopScan];
}

- (void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    if (central.state != CBCentralManagerStatePoweredOn) {
        //TODO: other states
        return;
    }
    
    //TODO: hard code
    CBUUID *myUUID = [CBUUID UUIDWithString:@"e2779da7-0a82-4be7-b754-31ed3e727253"];
    [self.centralManager scanForPeripheralsWithServices:[NSArray arrayWithObject:myUUID] options:nil];
}

- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI
{
    NSLog(@"did discover %@", peripheral.identifier);
    [self.centralManager stopScan];
    self.currentPeripheral = peripheral;
    self.currentPeripheral.delegate = self;
    [self.centralManager connectPeripheral:self.currentPeripheral options:nil];
}

-(void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
{
    self.currentPeripheral = peripheral;
    self.currentPeripheral.delegate  = self;
 CBUUID *myUUID = [CBUUID UUIDWithString:@"e2779da7-0a82-4be7-b754-31ed3e727253"];
    //[self.currentPeripheral discoverServices:[NSArray arrayWithObject:myUUID]];
    [self.currentPeripheral discoverServices:nil];
    NSLog(@"Peripheral connected");

}

- (void) peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error
{
    NSArray * services;
    services = [peripheral services];
    self.currentPeripheral = peripheral;
    self.currentPeripheral.delegate = self;
    for (CBService *service in services) {
        NSLog(@"found service id: %@", [service UUID]);
        [self.currentPeripheral discoverCharacteristics:nil forService:service];
    }
}


- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service
             error:(NSError *)error {

    for (CBCharacteristic *characteristic in service.characteristics) {
        NSLog(@"Discovered characteristic %@", characteristic);
        if ([[characteristic.UUID UUIDString] isEqualToString:@"15333333-3333-3333-3333-333333330003"])
        {
            NSLog(@"got sousvide temp");
            self.sousVideTemp = characteristic;
            
        }
        else if ([[characteristic.UUID UUIDString] isEqualToString:@"71B1A100-E3AE-46FF-BB0A-E37D0BA79496"])
        {
            NSLog(@"got probe temp");
            self.probeTemp = characteristic;
            
            [self updateProbeTemp];
        }
    }
}

- (void)updateProbeTemp
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.currentPeripheral readValueForCharacteristic:self.probeTemp];
    });
}

- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    NSData *data = self.probeTemp.value;
    Byte bytes[2] ;
    [data getBytes:bytes length:2];
    NSLog(@"more %02x", bytes[1] );
    self.probeTempLabel.text = [NSString stringWithFormat:@"%d", bytes[1]];
    [self updateProbeTemp];
}

- (void) centralManager:(CBCentralManager *)central didRetrieveConnectedPeripherals:(NSArray *)peripherals
{
    CBPeripheral	*peripheral;
    for (peripheral in peripherals) {
        NSLog(@"peripheralconnected: %@", peripheral.identifier);
    }
}

- (void) centralManager:(CBCentralManager *)central didRetrievePeripheral:(CBPeripheral *)peripheral
{
    NSLog(@"didretrieve %@", peripheral.identifier);
}

- (void) centralManager:(CBCentralManager *)central didFailToRetrievePeripheralForUUID:(CFUUIDRef)UUID error:(NSError *)error
{
    //plist crap
}

-(void)centralManager:(CBCentralManager *)central willRestoreState:(NSDictionary *)dict{
    
}

@end
