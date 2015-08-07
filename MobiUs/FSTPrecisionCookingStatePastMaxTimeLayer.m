//
//  FSTPrecisionCookingStatePastMaxTimeLayer.m
//  FirstBuild
//
//  Created by John Nolan on 8/7/15.
//  Copyright (c) 2015 FirstBuild. All rights reserved.
//

#import "FSTPrecisionCookingStatePastMaxTimeLayer.h"

@implementation FSTPrecisionCookingStatePastMaxTimeLayer

-(void)drawPathsForPercent {
    [self drawCompleteTicks];
    self.progressLayer.strokeEnd = 1.0F;
    self.sittingLayer.strokeEnd = 1.0F;
}
@end
