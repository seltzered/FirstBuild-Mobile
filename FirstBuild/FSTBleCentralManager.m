//
//  FSTBleCentralManager.m
//  FirstBuild
//
//  Created by Myles Caley on 6/19/15.
//  Copyright (c) 2015 FirstBuild. All rights reserved.
//

#import "FSTBleCentralManager.h"
#import "FSTParagonDisconnectedLabel.h"
#import "FSTBleSavedProduct.h"

@implementation FSTBleCentralManager

NSString * const FSTBleCentralManagerDeviceFound = @"FSTBleCentralManagerDeviceFound";
NSString * const FSTBleCentralManagerDeviceUnFound = @"FSTBleCentralManagerDeviceUnFound";
NSString * const FSTBleCentralManagerPoweredOn = @"FSTBleCentralManagerPoweredOn";
NSString * const FSTBleCentralManagerPoweredOff = @"FSTBleCentralManagerPoweredOff";
NSString * const FSTBleCentralManagerDeviceConnected = @"FSTBleCentralManagerDeviceConnected";
NSString * const FSTBleCentralManagerNewDeviceBound = @"FSTBleCentralManagerNewDeviceBound";
NSString * const FSTBleCentralManagerDeviceNameChanged = @"FSTBleCentralManagerDeviceNameChanged";
NSString * const FSTBleCentralManagerDeviceDisconnected = @"FSTBleCentralManagerDeviceDisconnected";

NSMutableArray* _discoveredDevicesCache;
NSMutableArray* _discoveredDevicesActiveScan;
NSTimer* _discoveryTimer;
BOOL _scanning = NO;
NSUUID* _currentServiceScanningUuid ;

CBCentralManager* _centralManager;
CBPeripheralManager * _peripheralManager; //temporary

+ (id) sharedInstance {
    
    static FSTBleCentralManager *sharedSingletonInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedSingletonInstance = [[self alloc] init];
    });
    return sharedSingletonInstance;
}


- (instancetype)init
{
    self = [super init];
    if (self) {
        //TODO
        //temporary hack for BLE ACM
        //this startup then triggers the central manager initialization. once the service
        //callback check is removed we need to start the central manager here instead of in peripheralManagerDidUpdateState
        self.isPoweredOn = NO;
        //_centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
        _peripheralManager = [[CBPeripheralManager alloc] initWithDelegate:self queue:nil];
    }
    return self;
}

- (void)dealloc
{
    
}

#pragma mark - External Methods

-(CBPeripheral*) connectToSavedPeripheralWithUUID: (NSUUID*) uuid
{
    if (uuid)
    {
        if (_centralManager.state == CBCentralManagerStatePoweredOn)
        {
            NSArray* results = [_centralManager retrievePeripheralsWithIdentifiers:[[NSArray alloc] initWithObjects:uuid, nil]];
            if (results[0])
            {
                CBPeripheral* peripheral = (CBPeripheral*)results[0];
                peripheral =(CBPeripheral*)results[0];
                DLog(@"connecting to ... %@", [peripheral.identifier UUIDString]);
                [_centralManager connectPeripheral:peripheral options:nil];
                return peripheral;
            }
        }
        else
        {
            DLog(@"central not powered");
        }
    }
    return nil;
}

-(void)disconnectPeripheral: (CBPeripheral*)peripheral
{
    [_centralManager cancelPeripheralConnection:peripheral];
}

-(void)connectToNewPeripheral: (CBPeripheral*) peripheral
{
    if (peripheral)
    {
        if (_centralManager.state == CBCentralManagerStatePoweredOn)
        {
            [_centralManager connectPeripheral:peripheral options:nil];
        }
        else
        {
            DLog(@"central not powered");
        }
    }
}

-(void)savePeripheral: (CBPeripheral*)peripheral havingUUIDString: (NSString*)uuid withName: (NSString*)name className: (Class) className
{
    if (name && name.length > 0 && className)
    {
        NSMutableDictionary* savedDevices = [NSMutableDictionary dictionaryWithDictionary:[[FSTBleCentralManager sharedInstance] getSavedPeripherals]];
        
        if (!savedDevices)
        {
            savedDevices = [[NSMutableDictionary alloc]init];
        }
        
        FSTBleSavedProduct* product = [FSTBleSavedProduct new];
        product.friendlyName = name;
        product.classNameString = NSStringFromClass(className);
        
        if (![savedDevices objectForKey:uuid])
        {
            //if this is the first time this UUID has been saved, announce a new device is fully bound and saved
            DLog(@"device doesn't exist");
            [savedDevices setObject:product forKey:uuid];
            [self saveProductsToDefaults:[NSDictionary dictionaryWithDictionary:savedDevices] key:@"ble-devices"];
            [[NSNotificationCenter defaultCenter] postNotificationName:FSTBleCentralManagerNewDeviceBound object:peripheral];
        }
        else
        {
            //otherwise just announce the name change
            [savedDevices setObject:product forKey:uuid];
            [self saveProductsToDefaults:[NSDictionary dictionaryWithDictionary:savedDevices] key:@"ble-devices"];
            [[NSNotificationCenter defaultCenter] postNotificationName:FSTBleCentralManagerDeviceNameChanged object:peripheral];
        }
    }
}

- (void)saveProductsToDefaults:(NSDictionary *)object key:(NSString *)key {
    NSData *encodedObject = [NSKeyedArchiver archivedDataWithRootObject:object];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:encodedObject forKey:key];
    [defaults synchronize];
    
}

- (NSDictionary *)loadProductsFromDefaultsWithKey:(NSString *)key {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *encodedObject = [defaults objectForKey:key];
    NSDictionary *products = [NSKeyedUnarchiver unarchiveObjectWithData:encodedObject];
    return products;
}

- (NSDictionary*)getSavedPeripherals
{
    return [self loadProductsFromDefaultsWithKey:@"ble-devices"];
}

-(void) deleteSavedPeripheralWithUUIDString: (NSString*) uuidString {
    NSMutableDictionary* savedPeripherals = [NSMutableDictionary dictionaryWithDictionary:[self getSavedPeripherals]]; // get rid of the uuid keyed device
    [savedPeripherals removeObjectForKey:uuidString];
    [self saveProductsToDefaults:[NSDictionary dictionaryWithDictionary:savedPeripherals] key:@"ble-devices"];
}

-(void)scanForDevicesWithServiceUUIDString: (NSString*)uuidString
{
    if (_scanning == YES)
    {
       DLog(@"already scanning");
    }
    else if (!uuidString)
    {
        DLog(@"uuidString null");
    }
    else if (uuidString.length ==0)
    {
        DLog(@"uuidString length is 0");
    }
    else if (_centralManager.state != CBCentralManagerStatePoweredOn)
    {
        DLog(@"central is not powered on, can't scan");
    }
    else
    {
        DLog(@"scanning...");
        NSUUID *uuid = [[NSUUID alloc] initWithUUIDString:uuidString];
        _currentServiceScanningUuid = uuid;
        _discoveredDevicesActiveScan = [[NSMutableArray alloc]init];
        _discoveredDevicesCache = [[NSMutableArray alloc]init];
        _scanning = YES;

        //start a periodic timer to stop and start the scan, this is so we can find
        //devices that are no longer online
        _discoveryTimer = [NSTimer timerWithTimeInterval:5.0 target:self selector:@selector(discoveryTimerTimeout:) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:_discoveryTimer forMode:NSRunLoopCommonModes];

        [_centralManager scanForPeripheralsWithServices:[NSArray arrayWithObject:_currentServiceScanningUuid] options:nil];
    }
}

-(void)stopScanning
{
     DLog(@"stop scanning...");
    _scanning = NO;
    _currentServiceScanningUuid = nil;
    [_centralManager stopScan];
    [_discoveryTimer invalidate];
}

-(void)discoveryTimerTimeout:(NSTimer *)timer
{
    if (_scanning == YES)
    {
        DLog(@"scanning...periodic poke...");
        
        //stop scanning to refresh discovered list
        [_centralManager stopScan];
        
        //first remove any objects from the cache that were in the active scan
        [_discoveredDevicesCache removeObjectsInArray:_discoveredDevicesActiveScan];
        
        //now loop through any devices left over (these weren't in the last scan)
        for (CBPeripheral* peripheral in _discoveredDevicesCache)
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:FSTBleCentralManagerDeviceUnFound object:peripheral];
        }
        
        //our cache is now what was discovered over the last active search
        _discoveredDevicesCache = [NSMutableArray arrayWithArray:_discoveredDevicesActiveScan];
        
        //new clean array of active devices
        _discoveredDevicesActiveScan = [[NSMutableArray alloc]init];
        
        //start scanning again
        [_centralManager scanForPeripheralsWithServices:[NSArray arrayWithObject:_currentServiceScanningUuid] options:nil];
    }
}

#pragma mark - Central Delegate

- (void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    if (central.state != CBCentralManagerStatePoweredOn) {
        DLog("central state changed, nothing to do %ld", (long)central.state);
        self.isPoweredOn = NO;
        [[NSNotificationCenter defaultCenter] postNotificationName:FSTBleCentralManagerPoweredOff object:self];
    }
    else if (central.state == CBCentralManagerStatePoweredOn) {
        self.isPoweredOn = YES;
        DLog(@"central powered on");
        [[NSNotificationCenter defaultCenter] postNotificationName:FSTBleCentralManagerPoweredOn object:self];

    }
}

- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    DLog(@"peripheral failed to connect");
}


-(void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
{
    DLog(@"peripheral connected... %@", [peripheral.identifier UUIDString]);
    [[NSNotificationCenter defaultCenter] postNotificationName:FSTBleCentralManagerDeviceConnected object:peripheral];
}

-(void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    
    if ([[self getSavedPeripherals] objectForKey:[peripheral.identifier UUIDString]])
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:FSTBleCentralManagerDeviceDisconnected object:peripheral];
    }
    else
    {
        DLog(@"disconnected device does not exist in saved devices, probably just removed manually");
    }
    
}


-(void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI
{
    BOOL _alreadyAnnouncedPeripheral = NO;
    
    //add it to the list of pending devices found
    [_discoveredDevicesActiveScan addObject:peripheral];
    
    //search through the previous list to find any objects we discovered the last time
    for (CBPeripheral* p in _discoveredDevicesCache)
    {
        if (p.identifier == peripheral.identifier)
        {
            _alreadyAnnouncedPeripheral = YES;
            break;
        }
    }

    if (!_alreadyAnnouncedPeripheral)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:FSTBleCentralManagerDeviceFound object:peripheral];
    }

}

#pragma mark - Peripheral Delegate - temporary
- (void)peripheralManagerDidUpdateState:(CBPeripheralManager *)peripheral {
    DLog(@"peripheralManagerDidUpdateState : %@", peripheral);
    if (peripheral.state != CBPeripheralManagerStatePoweredOn) {
                return;
    }
    
    if (peripheral.state == CBPeripheralManagerStatePoweredOn) {
        _centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
        
        CBMutableService *service = [[CBMutableService alloc] initWithType:[CBUUID UUIDWithString:@"0db95663-c52e-2fac-2040-c276b2b63090"] primary:YES];
        
        [_peripheralManager addService:service];
        [_peripheralManager startAdvertising:nil];
    }
}


@end
