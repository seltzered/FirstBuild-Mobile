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
    kPARAGON_UNINITIALIZED,
    kPARAGON_OFF,
    kPARAGON_PRECISION_PREHEATING,
    kPARAGON_PRECISION_HEATING
} ParagonBurnerMode;

@property (atomic) ParagonBurnerMode burnerMode;

@end
