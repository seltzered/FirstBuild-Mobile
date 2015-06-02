//
//  FSTCookingMethod.m
//  FirstBuild
//
//  Created by Myles Caley on 5/13/15.
//  Copyright (c) 2015 FirstBuild. All rights reserved.
//

#import "FSTCookingMethod.h"

@implementation FSTCookingMethod

-(id) init
{
    self = [super init];
    if (self)
    {
        self.session = [[FSTParagonCookingSession alloc] init];
    }
    
    return self;
}
@end
