//
//  FSTMilkyWeigh.h
//  FirstBuild-Mobile
//
//  Created by Myles Caley on 12/3/14.
//  Copyright (c) 2014 FirstBuild. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FSTChillHubDevice.h"

@interface FSTMilkyWeigh : FSTChillHubDevice

extern NSString *const DATAMAPPING_MILKY_WEIGH;

@property (strong, nonatomic) NSString* weight_gal;
@property (strong, nonatomic) NSString* weight_l;

@end
