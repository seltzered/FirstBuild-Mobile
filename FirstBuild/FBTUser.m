//
//  FBTUser.m
//  iOS Firebase Template
//
//  Created by Michael McDonald on 4/17/14.
//  Copyright (c) 2014 Firebase. All rights reserved.
//

#import "FBTUser.h"

@implementation FBTUser

+ (id) sharedInstance
{
    static FBTUser *sharedSingletonInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedSingletonInstance = [[self alloc] init];
    });
    return sharedSingletonInstance;
}

- (id) init {
    self = [super init];
    return self;
}

- (id) initWithDictionary:(NSDictionary *)dict;
{
    if ((self = [super init]))
    {
        _displayName  = [dict valueForKey:@"displayName"];
        _email   = [dict valueForKey:@"email"];
        _rootContainer = [dict valueForKey:@"rootContainer"];
        _token = [dict valueForKey:@"token"];
    }
    return self;
}

- (NSDictionary *)toDictionary;
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:self.email forKey:@"email"];
    [dict setObject:self.displayName forKey:@"displayName"];
    [dict setObject:self.rootContainer forKey:@"rootContainer"];
    [dict setObject:self.rootContainer forKey:@"token"];

    return dict;
}

- (BOOL)isEqual:(id)other {
    if (other == self)
        return YES;
    if (!other || ![other isKindOfClass:[self class]])
        return NO;
    return [self isEqualToUser:other];
}

- (BOOL)isEqualToUser:(FBTUser *)user {
    if (self == user)
        return YES;
    if (!([self.rootContainer isEqualToString:user.rootContainer]))
        return NO;
    return YES;
}


@end
