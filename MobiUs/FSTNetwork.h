//
//  FSTNetwork.h
//  FirstBuild-Mobile
//
//  Created by Myles Caley on 11/17/14.
//  Copyright (c) 2014 FirstBuild. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FSTNetwork : NSObject
@property (nonatomic, strong) NSString *ssid;
@property (nonatomic, strong) NSString *security_mode;
@property (nonatomic, strong) NSString *state;
@property (nonatomic, strong) NSString *passphrase;

@end
