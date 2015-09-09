//
//  FSTChillHub.h
//  FirstBuild-Mobile
//
//  Created by Myles Caley on 12/5/14.
//  Copyright (c) 2014 FirstBuild. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FSTChillHubDevice.h"

@interface FSTChillHub : FSTChillHubDevice

extern NSString* const DATAMAPPING_ATTACHMENTS ;


@property (strong, nonatomic) NSString* temperature_c;
@property (strong, nonatomic) NSString* temperature_f;

@end
