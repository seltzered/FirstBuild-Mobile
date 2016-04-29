//
//  Ota.h
//  FirstBuild
//
//  Created by Myles Caley on 4/27/16.
//  Copyright © 2016 FirstBuild. All rights reserved.
//

#ifndef Ota_h
#define Ota_h

const extern uint32_t OPAL_APP_AVAILABLE_VERSION;
const extern uint32_t OPAL_BLE_AVAILABLE_VERSION;
extern NSString* OPAL_APP_FIRMWARE_FILE_NAME;
extern NSString* OPAL_BLE_FIRMWARE_FILE_NAME;

typedef enum {
  OtaImageTypeBle = 0x00,
  OtaImageTypeApplication = 0x01,
  OtaImageTypeNone = 0xFF,
  OtaImageTypeUnknown = 0xFE
} OtaImageType;

#endif /* Ota_h */
