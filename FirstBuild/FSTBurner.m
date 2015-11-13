//
//  FSTBurner.m
//  FirstBuild
//
//  Created by Myles Caley on 7/10/15.
//  Copyright (c) 2015 FirstBuild. All rights reserved.
//

#import "FSTBurner.h"

@implementation FSTBurner

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.geCooktopBurnerMode = kGECOOKTOP_OFF;
        self.paragonburnerMode = kPARAGON_BURNER_STOP;
    }
    return self;
}
@end
