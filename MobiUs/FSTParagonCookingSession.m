//
//  FSTParagonCookingSession.m
//  FirstBuild
//
//  Created by Myles Caley on 6/2/15.
//  Copyright (c) 2015 FirstBuild. All rights reserved.
//

#import "FSTParagonCookingSession.h"

@implementation FSTParagonCookingSession


-(instancetype)init
{
    self = [super init];
    if (self) {
        self.paragonCookingStages = [[NSMutableArray alloc]init];
    }
    return self;
}

@end
