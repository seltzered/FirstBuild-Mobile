//
//  PushSegueNoAnimation.m
//  FirstBuild
//
//  Created by John Nolan on 6/29/15.
//  Copyright (c) 2015 FirstBuild. All rights reserved.
//

#import "PushSegueNoAnimation.h"

@implementation PushSegueNoAnimation

-(void) perform {
    [[[self sourceViewController] navigationController] pushViewController:[self destinationViewController] animated:NO];
}

@end
