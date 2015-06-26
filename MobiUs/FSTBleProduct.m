//
//  FSTBleProduct.m
//  FirstBuild
//
//  Created by Myles Caley on 6/25/15.
//  Copyright (c) 2015 FirstBuild. All rights reserved.
//

#import "FSTBleProduct.h"

@implementation FSTBleProduct

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.characteristics = [[NSMutableDictionary alloc]init];
    }
    return self;
}

@end
