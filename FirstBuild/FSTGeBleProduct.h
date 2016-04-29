//
//  FSTGeBleProduct.h
//  FirstBuild
//
//  Created by Myles Caley on 4/18/16.
//  Copyright © 2016 FirstBuild. All rights reserved.
//

#import "FSTBleProduct.h"
#import "Ota.h"

@interface FSTGeBleProduct : FSTBleProduct

@property (nonatomic) uint32_t currentBleVersion;
@property (nonatomic) uint32_t availableBleVersion;
@property (nonatomic) uint32_t currentAppVersion;
@property (nonatomic) uint32_t availableAppVersion;

- (void)startOtaType:(OtaImageType)otaImageType forFileName:(NSString*)filename;

- (void)abortOta;

@end
