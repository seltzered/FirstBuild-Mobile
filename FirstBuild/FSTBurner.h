//
//  FSTBurner.h
//  FirstBuild
//
//  Created by Myles Caley on 7/10/15.
//  Copyright (c) 2015 FirstBuild. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FSTBurner : NSObject

//paragon cook mode
typedef enum {
    kGECOOKTOP_UNINITIALIZED,
    kGECOOKTOP_OFF,
    kGECOOKTOP_PRECISION_REACHING_TEMPERATURE,
    kGECOOKTOP_PRECISION_HEATING
} GECooktopBurnerMode;

typedef enum {
    kPARAGON_BURNER_STOP,
    kPARAGON_BURNER_START
} ParagonBurnerMode;

@property (atomic) GECooktopBurnerMode geCooktopBurnerMode;
@property (atomic) ParagonBurnerMode paragonburnerMode;


@end
