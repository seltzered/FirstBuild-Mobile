//
//  FSTPrecisionCookingStateTemperatureReachedLayer.m
//  FirstBuild
//
//  Created by John Nolan on 8/6/15.
//  Copyright (c) 2015 FirstBuild. All rights reserved.
//

#import "FSTPrecisionCookingStateTemperatureReachedLayer.h"

@implementation FSTPrecisionCookingStateTemperatureReachedLayer

-(void) layoutSublayers {
    [super layoutSublayers];
    [self drawPathsForPercent];
    
}
-(void) drawPathsForPercent {
    [self drawCompleteTicks];
    self.progressLayer.strokeEnd = 0.0F;
    self.sittingLayer.strokeEnd = 0.0F;
}

@end
