//
//  FSTChillHubDevice.h
//  FirstBuild-Mobile
//
//  Created by Myles Caley on 12/5/14.
//  Copyright (c) 2014 FirstBuild. All rights reserved.
//

#import "FSTProduct.h"
#import <Foundation/Foundation.h>

@interface FSTChillHubDevice : FSTProduct

@property (strong, nonatomic) NSString* hardware_version;
@property (strong, nonatomic) NSString* software_version;

@end
