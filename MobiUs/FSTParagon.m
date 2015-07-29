//
//  FSTParagon.m
//  FirstBuild
//
//  Created by Myles Caley on 3/12/15.
//  Copyright (c) 2015 FirstBuild. All rights reserved.
//

#import "FSTParagon.h"

@implementation FSTParagon

//notifications
NSString * const FSTActualTemperatureChangedNotification    = @"FSTActualTemperatureChangedNotification";
NSString * const FSTTargetTemperatureChangedNotification    = @"FSTTargetTemperatureChangedNotification";
NSString * const FSTCookModeChangedNotification             = @"FSTCookModeChangedNotification";
NSString * const FSTElapsedTimeChangedNotification          = @"FSTElapsedTimeChangedNotification";
NSString * const FSTBatteryLevelChangedNotification         = @"FSTBatteryLevelChangedNotification";
NSString * const FSTCookTimeSetNotification                 = @"FSTCookTimeSetNotification";

//app info service
NSString * const FSTServiceAppInfoService               = @"E936877A-8DD0-FAA7-B648-F46ACDA1F27B";
NSString * const FSTCharacteristicAppInfo               = @"318DB1F5-67F1-119B-6A41-1EECA0C744CE"; //read

//acm service
NSString * const FSTServiceParagon                      = @"05C78A3E-5BFA-4312-8391-8AE1E7DCBF6F";
NSString * const FSTCharacteristicSpecialFeatures       = @"E7CDDD9D-DCAC-4D70-A0E1-D3B6DFEB5E4C"; //read,notify,write
NSString * const FSTCharacteristicProbeFirmwareInfo     = @"83D33E5C-68EA-4158-8655-1A2AC0313FF6"; //read
NSString * const FSTCharacteristicErrorState            = @"5BCBF6B1-DE80-94B6-0F4B-99FB984707B6"; //read,notify
NSString * const FSTCharacteristicProbeConnectionState  = @"6B402ECC-3DDA-8BB4-9E42-F121D7E1CF69"; //read,notify
NSString * const FSTCharacteristicBatteryLevel          = @"A74C3FB9-6E13-B4B9-CD47-465AAD76FCE7"; //read,notify
NSString * const FSTCharacteristicBurnerStatus          = @"A1B9F907-D440-4278-97FE-0FBB4AEE93FD"; //read,notify
NSString * const FSTCharacteristicTargetTemperature     = @"71B1A100-E3AE-46FF-BB0A-E37D0BA79496"; //read,notify,write
NSString * const FSTCharacteristicElapsedTime           = @"998142D1-658E-33E2-DFC0-32091E2354EC"; //read,notify
NSString * const FSTCharacteristicCookTime              = @"C4510188-9062-4D28-97EF-4FB32FFE1AC5"; //read,write
NSString * const FSTCharacteristicCurrentTemperature    = @"8F080B1C-7C3B-FBB9-584A-F0AFD57028F0"; //read,notify

__weak NSTimer* _readCharacteristicsTimer;

- (id)init
{
    self = [super init];
    
    if (self)
    {
        self.currentCookingMethod = [[FSTCookingMethod alloc]init];
        [self.currentCookingMethod createCookingSession];
        [self.currentCookingMethod addStageToCookingSession];
        self.burners = [NSArray arrayWithObjects:[FSTBurner new], [FSTBurner new],[FSTBurner new],[FSTBurner new],[FSTBurner new], nil];
    }

    return self;
}

-(void)dealloc
{
    [_readCharacteristicsTimer invalidate];
}

#pragma mark - Interactions

-(void)startHeatingWithTemperature: (NSNumber*)targetTemperature
{
    Byte bytes[2] ;
    OSWriteBigInt16(bytes, 0, [targetTemperature doubleValue]*100);
    NSData *data = [[NSData alloc]initWithBytes:bytes length:2];

    CBCharacteristic* characteristic = [self.characteristics objectForKey:FSTCharacteristicTargetTemperature];
    
    if (characteristic)
    {
        [self.peripheral writeValue:data forCharacteristic:characteristic type:CBCharacteristicWriteWithResponse];
    }
}

-(void)setCookingTime: (NSNumber*)cookingTime
{
    Byte bytes[2] ;
    OSWriteBigInt16(bytes, 0, [cookingTime unsignedIntegerValue]);
    NSData *data = [[NSData alloc]initWithBytes:bytes length:2];
    
    CBCharacteristic* characteristic = [self.characteristics objectForKey:FSTCharacteristicCookTime];
    
    if (characteristic)
    {
        [self.peripheral writeValue:data forCharacteristic:characteristic type:CBCharacteristicWriteWithResponse];
    }
}

-(void)assignValueToPropertyFromCharacteristic: (CBCharacteristic*)characteristic
{
    if ([[[characteristic UUID] UUIDString] isEqualToString: FSTCharacteristicProbeFirmwareInfo])
    {
        //not implemented
    }
    else if([[[characteristic UUID] UUIDString] isEqualToString: FSTCharacteristicSpecialFeatures])
    {
        //not implemented
    }
    else if([[[characteristic UUID] UUIDString] isEqualToString: FSTCharacteristicErrorState])
    {
        //not implemented
    }
    else if([[[characteristic UUID] UUIDString] isEqualToString: FSTCharacteristicProbeConnectionState])
    {
        //not implemented
    }
    else if([[[characteristic UUID] UUIDString] isEqualToString: FSTCharacteristicBatteryLevel])
    {
        [self handleBatteryLevel:characteristic];
    }
    else if([[[characteristic UUID] UUIDString] isEqualToString: FSTCharacteristicBurnerStatus])
    {
        [self handleBurnerStatus:characteristic];
    }
    else if([[[characteristic UUID] UUIDString] isEqualToString: FSTCharacteristicElapsedTime])
    {
        [self handleElapsedTime:characteristic];
    }
    else if([[[characteristic UUID] UUIDString] isEqualToString: FSTCharacteristicTargetTemperature])
    {
        [self handleTargetTemperature:characteristic];
    }
    else if([[[characteristic UUID] UUIDString] isEqualToString: FSTCharacteristicCookTime])
    {
        [self handleCookTime:characteristic];
    }
    else if([[[characteristic UUID] UUIDString] isEqualToString:FSTCharacteristicCurrentTemperature])
    {
        [self handleCurrentTemperature:characteristic];
    }
}

#pragma mark - Data Assignment Handlers

-(void)handleBatteryLevel: (CBCharacteristic*)characteristic
{
    self.batteryLevel = [NSNumber numberWithInt:32];
    [[NSNotificationCenter defaultCenter] postNotificationName:FSTBatteryLevelChangedNotification  object:self];
}

-(void)handleElapsedTime: (CBCharacteristic*)characteristic
{
    if (characteristic.value.length != 2)
    {
        DLog(@"handleElapsedTime length of %lu not what was expected, %d", (unsigned long)characteristic.value.length, 2);
        return;
    }
    
    FSTParagonCookingStage* currentStage = self.currentCookingMethod.session.paragonCookingStages[0];
    
    if (currentStage)
    {
        NSData *data = characteristic.value;
        Byte bytes[characteristic.value.length] ;
        [data getBytes:bytes length:characteristic.value.length];
        uint16_t raw = OSReadBigInt16(bytes, 0);
        currentStage.cookTimeElapsed = [[NSNumber alloc] initWithDouble:raw];
        [[NSNotificationCenter defaultCenter] postNotificationName:FSTElapsedTimeChangedNotification object:self];
        NSLog(@"FSTCharacteristicElapsedTime %@", currentStage.cookTimeElapsed );
    }
}

-(void)handleBurnerStatus: (CBCharacteristic*)characteristic
{
    if (characteristic.value.length != self.burners.count)
    {
        DLog(@"handleBurnerStatus length of %lu not what was expected, %lu", (unsigned long)characteristic.value.length, (unsigned long)self.burners.count);
        return;
    }
    FSTParagonCookingStage* currentStage = self.currentCookingMethod.session.paragonCookingStages[0];
    
    //There are 5 burner statuses and and 5 bytes. Each byte is a status
    //the statuses are:
    //
    //Bit 7: 0 - Off, 1 - On
    //Bit 6: Normal / Sous Vide
    //Bit 5: 0 - Cook, 1 - Preheat
    //Bits 4-0: Burner PwrLevel
//    static const uint8_t BURNER_ON_OR_OFF_MASK = 0x80;
    static const uint8_t SOUS_VIDE_ON_OR_OFF_MASK = 0x40;
    static const uint8_t BURNER_PREHEAT_MASK = 0x20;
//    static const uint8_t BURNER_POWER_LEVEL_MASK = 0x1F;

//    //cook status
//    static const uint8_t COOK_STATUS_BIT = 5;
//    static const uint8_t COOK_STATUS_PREHEAT = 1;
//    
    //cook modes
//    static const uint8_t MODE_BIT = 6;
//    static const uint8_t MODE_NORMAL = 0;
    
    NSData *data = characteristic.value;
    Byte bytes[characteristic.value.length] ;
    [data getBytes:bytes length:characteristic.value.length];
    
    NSLog(@"================ BURNER STATUS CHANGED ====================");
    
    //loop through burners
    for (uint8_t burner = 0; burner < self.burners.count; burner++)
    {
        FSTBurner * currentBurner = (FSTBurner*)self.burners[burner];
        
        //figure out what mode the burner is
        if ((bytes[burner] & SOUS_VIDE_ON_OR_OFF_MASK) != SOUS_VIDE_ON_OR_OFF_MASK)
        {
            currentBurner.cookMode = kPARAGON_OFF;
        }
        else
        {
            if((bytes[burner] & BURNER_PREHEAT_MASK) == BURNER_PREHEAT_MASK)
            {
                currentBurner.cookMode = kPARAGON_PREHEATING;
            }
            else
            {
                if ([currentStage.cookTimeRequestedActual integerValue] > 0)
                {
                    currentBurner.cookMode = kPARAGON_HEATING_WITH_TIME;
                }
                else
                {
                    currentBurner.cookMode = kPARAGON_HEATING;
                }
            }
        }
        NSLog(@"burner %d cookMode %d", burner, currentBurner.cookMode);
    }
    
    [self setCookModeFromBurners];
    
}

-(void)setCookModeFromBurners
{
    for (FSTBurner* burner in self.burners) {
        if (burner.cookMode != kPARAGON_OFF )
        {
            self.currentCookMode = burner.cookMode;
            break;
        }
        else
        {
            self.currentCookMode = kPARAGON_OFF;
        }
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:FSTCookModeChangedNotification object:self];
    [self notifyDeviceReady];
    
    NSLog(@"FSTCharacteristicBurnerStatus %d", self.currentCookMode );
}

-(void)handleTargetTemperature: (CBCharacteristic*)characteristic
{
    if (characteristic.value.length != 2)
    {
        DLog(@"handleTargetTemperature length of %lu not what was expected, %d", (unsigned long)characteristic.value.length, 2);
        return;
    }
    
    FSTParagonCookingStage* currentStage = self.currentCookingMethod.session.paragonCookingStages[0];

    if (currentStage)
    {
        NSData *data = characteristic.value;
        Byte bytes[characteristic.value.length] ;
        [data getBytes:bytes length:characteristic.value.length];
        uint16_t raw = OSReadBigInt16(bytes, 0);
        currentStage.targetTemperature = [[NSNumber alloc] initWithDouble:raw/100];
        [[NSNotificationCenter defaultCenter] postNotificationName:FSTTargetTemperatureChangedNotification object:self];
        NSLog(@"FSTCharacteristicTargetTemperature: ble %d, actual %@", raw, currentStage.targetTemperature );
    }
}

-(void)handleCookTime: (CBCharacteristic*)characteristic
{
    if (characteristic.value.length != 2)
    {
        DLog(@"handleCookTime length of %lu not what was expected, %d", (unsigned long)characteristic.value.length, 2);
        return;
    }
    
    FSTParagonCookingStage* currentStage = self.currentCookingMethod.session.paragonCookingStages[0];
    if (currentStage)
    {
        NSData *data = characteristic.value;
        Byte bytes[characteristic.value.length] ;
        [data getBytes:bytes length:characteristic.value.length];
        uint16_t raw = OSReadBigInt16(bytes, 0);
        currentStage.cookTimeRequestedActual = [[NSNumber alloc] initWithDouble:raw];
        NSLog(@"FSTCharacteristicCookTime %@", currentStage.cookTimeRequestedActual );
    }
}

-(void)handleCurrentTemperature: (CBCharacteristic*)characteristic
{
    if (characteristic.value.length != 2)
    {
        DLog(@"handleCurrentTemperature length of %lu not what was expected, %d", (unsigned long)characteristic.value.length, 2);
        return;
    }
    
    FSTParagonCookingStage* currentStage = self.currentCookingMethod.session.paragonCookingStages[0];
    if (currentStage)
    {
        NSData *data = characteristic.value;
        Byte bytes[characteristic.value.length] ;
        [data getBytes:bytes length:characteristic.value.length];
        uint16_t raw = OSReadBigInt16(bytes, 0);
        currentStage.actualTemperature = [[NSNumber alloc] initWithDouble:raw/100];
        [[NSNotificationCenter defaultCenter] postNotificationName:FSTActualTemperatureChangedNotification object:self];
        NSLog(@"FSTCharacteristicCurrentTemperature %@", currentStage.actualTemperature );
    }
}

#pragma mark - <CBPeripheralDelegate>

-(void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error
{
    NSLog(@"=======================================================================");
    NSLog(@"SERVICE %@", [service.UUID UUIDString]);
        
    for (CBCharacteristic *characteristic in service.characteristics)
    {
        [self.characteristics setObject:characteristic forKey:[characteristic.UUID UUIDString]];
        NSLog(@"    CHARACTERISTIC %@", [characteristic.UUID UUIDString]);

        if (characteristic.properties & CBCharacteristicPropertyWrite)
        {
            NSLog(@"        CAN WRITE");
        }
        
        if (characteristic.properties & CBCharacteristicPropertyNotify)
        {
            [self.peripheral readValueForCharacteristic:characteristic];
            [self.peripheral setNotifyValue:YES forCharacteristic:characteristic];
        }
        
        if (characteristic.properties & CBCharacteristicPropertyRead)
        {
            [self.peripheral readValueForCharacteristic:characteristic];
            NSLog(@"        CAN READ");
        }
        
        if (characteristic.properties & CBCharacteristicPropertyWriteWithoutResponse)
        {
            NSLog(@"        CAN WRITE WITHOUT RESPONSE");
        }
    }
}

-(void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error
{
    DLog("discovered services for peripheral %@", peripheral.identifier);
    NSArray * services;
    services = [self.peripheral services];
    for (CBService *service in services)
    {
        [self.peripheral discoverCharacteristics:nil forService:service];
    }
}

-(void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    NSLog(@"characteristic %@ changed value %@", characteristic.UUID, characteristic.value);
    [self assignValueToPropertyFromCharacteristic:characteristic];
}

-(void)peripheral:(CBPeripheral *)peripheral didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    if (error)
    {
        NSLog(@"characteristic %@ notification failed %@", characteristic.UUID, error);
        return;
    }
    
    NSLog(@"characteristic %@ , notifying: %s", characteristic.UUID, characteristic.isNotifying ? "true" : "false");
   
}

-(void)peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    if([[[characteristic UUID] UUIDString] isEqualToString: FSTCharacteristicCookTime])
    {
        if (error)
        {
            //TODO what do we do if error writing characteristic?
            DLog(@"error writing the cooktime characteristic %@", error);
            return;
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:FSTCookTimeSetNotification object:self];
    }
}

@end
