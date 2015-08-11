//
//  FSTCookingProgressStatePreheatingLayer.m
//  FirstBuild
//
//  Created by John Nolan on 8/6/15.
//  Copyright (c) 2015 FirstBuild. All rights reserved.
//

#import "FSTCookingStatePreheatingLayer.h"

@implementation FSTCookingStatePreheatingLayer

- (instancetype)init
{
    self = [super init];
    if (self) {
        // remove?
    }
    return self;
}

-(void) layoutSublayers {
    [super layoutSublayers]; // establish all paths and their shape then lower the stroke
    self.progressLayer.strokeEnd = 0.0F;
    self.sittingLayer.strokeEnd = 0.0F;
}
-(void) drawPathsForPercent {
    CGFloat empty_tick_width = self.progressLayer.lineWidth/15;
    CGFloat full_tick_width = empty_tick_width*2; // define tick widths here
    // putting these in seperate classes
    //case kPreheating:
    self.progressLayer.strokeEnd = 0.0f; // not even started yet
    for (id key in self.markLayers) {
        if (fmod(([key doubleValue] + M_PI/2), 2*M_PI) <= self.percent*2*M_PI) { // 0 to 1 needs to go on a 3 PI/2 to 7pi/2 range, add pi/2 and clamp it to 0 through 2pi
            // might increase line width as well
            ((CAShapeLayer*)[self.markLayers objectForKey:key]).strokeColor = UIColorFromRGB(0xF0663A).CGColor; // place holder, color tick marks firstbuild orange as a progress indicator
            ((CAShapeLayer*)[self.markLayers objectForKey:key]).lineWidth = full_tick_width;
        } else {
            ((CAShapeLayer*)[self.markLayers objectForKey:key]).strokeColor = [UIColor grayColor].CGColor;
            ((CAShapeLayer*)[self.markLayers objectForKey:key]).lineWidth = empty_tick_width;
        }
    }
    self.sittingLayer.strokeEnd = 0.0F;
}

@end
