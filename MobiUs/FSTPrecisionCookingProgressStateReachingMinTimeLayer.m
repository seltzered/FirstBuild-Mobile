//
//  FSTPrecisionCookingProgressStateReachingMinTimeLayer.m
//  FirstBuild
//
//  Created by John Nolan on 8/6/15.
//  Copyright (c) 2015 FirstBuild. All rights reserved.
//

#import "FSTPrecisionCookingProgressStateReachingMinTimeLayer.h"

@implementation FSTPrecisionCookingProgressStateReachingMinTimeLayer

-(void) drawPathsForPercent {
[self drawCompleteTicks];// preheating complete
self.progressLayer.strokeEnd = 0.0F;
self.sittingLayer.strokeEnd = 0.0F;
}
@end
