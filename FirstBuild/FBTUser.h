//
//  FBTUser.h
//  iOS Firebase Template
//
//  Created by Michael McDonald on 4/17/14.
//  Copyright (c) 2014 Firebase. All rights reserved.
//

#import "FirebaseProtocol.h"
#import <Foundation/Foundation.h>

@interface FBTUser : NSObject <FirebaseProtocol>

@property (strong, nonatomic) NSString *displayName;
@property (strong, nonatomic) NSString *rootContainer;
@property (strong, nonatomic) NSString *email;
@property (strong, nonatomic) NSString *token;


- (id) initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)toDictionary;

+(id) sharedInstance;

@end
