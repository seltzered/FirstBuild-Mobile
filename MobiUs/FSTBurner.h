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
    kPARAGON_OFF = 0,
    kPARAGON_SOUS_VIDE_ENABLED,
    kPARAGON_PREHEATING,
    kPARAGON_HEATING,
    kPARAGON_HEATING_WITH_TIME
} ParagonCookMode;

@property (atomic) ParagonCookMode cookMode;

@end