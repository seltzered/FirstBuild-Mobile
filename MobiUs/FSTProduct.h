//
//  FSTProduct.h
//  FirstBuild-Mobile
//
//  Created by Myles Caley on 12/5/14.
//  Copyright (c) 2014 FirstBuild. All rights reserved.
//
// Base object for products/devices in firstbuild
// TODO: probably shouldn't attach the firebase ref here
#import <Foundation/Foundation.h>
#import <Firebase/Firebase.h>

@interface FSTProduct : NSObject

@property (strong, nonatomic) NSString* identifier;
@property (strong, nonatomic) NSString* created;
@property (strong, nonatomic) NSString* friendlyName;
@property (strong, nonatomic) Firebase* firebaseRef;
@property (atomic) BOOL online;
@property (atomic) BOOL loading;

@end
