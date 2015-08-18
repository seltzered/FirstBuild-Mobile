//
//  FSTBleSavedProduct.m
//  FirstBuild
//
//  Created by Myles Caley on 8/14/15.
//  Copyright (c) 2015 FirstBuild. All rights reserved.
//

#import "FSTBleSavedProduct.h"

@implementation FSTBleSavedProduct

- (void)encodeWithCoder:(NSCoder *)encoder
{
    //Encode properties, other class variables, etc
    [encoder encodeObject:self.friendlyName forKey:@"friendlyName"];
    [encoder encodeObject:self.classNameString forKey:@"classNameString"];
}

- (id)initWithCoder:(NSCoder *)decoder
{
    if((self = [super init]))
    {
        //decode properties, other class vars
        self.friendlyName = [decoder decodeObjectForKey:@"friendlyName"];
        self.classNameString = [decoder decodeObjectForKey:@"classNameString"];
    }
    return self;
}

@end
