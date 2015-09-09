//
//  FirebaseShared.m
//  FirstBuild-Mobile
//
//  Created by Myles Caley on 12/8/14.
//  Copyright (c) 2014 FirstBuild. All rights reserved.
//

#import "FirebaseShared.h"


@implementation FirebaseShared

+ (id) sharedInstance {
    
    static FirebaseShared *sharedSingletonInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedSingletonInstance = [[self alloc] init];
        sharedSingletonInstance.firebaseRootReference = [[Firebase alloc] initWithUrl:FirebaseUrl];
    });
    return sharedSingletonInstance;
}

@end
