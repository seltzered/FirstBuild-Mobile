//
//  FSTPrecisionCookingProgressStateReachingMinTimeLayer.m
//  FirstBuild
//
//  Created by John Nolan on 8/6/15.
//  Copyright (c) 2015 FirstBuild. All rights reserved.
//

#import "FSTPrecisionCookingStateReachingMinTimeLayer.h"

@implementation FSTPrecisionCookingStateReachingMinTimeLayer

-(void) drawPathsForPercent {
[self drawCompleteTicks];// preheating complete
self.progressLayer.strokeEnd = self.percent;
self.sittingLayer.strokeEnd = 0.0F;
}
// percent set from containing view controller

@end
