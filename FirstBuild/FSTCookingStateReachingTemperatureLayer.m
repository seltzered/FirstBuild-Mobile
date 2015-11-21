//
//  FSTCookingStateReachingTemperatureLayer.m
//  FirstBuild
//
//  Created by John Nolan on 8/6/15.
//  Copyright (c) 2015 FirstBuild. All rights reserved.
//

#import "FSTCookingStateReachingTemperatureLayer.h"

@implementation FSTCookingStateReachingTemperatureLayer

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
    UIColor* tic_color;
    // absolute value of percent, to draw the paths
    CGFloat abs_perc;
    
    if (self.percent >= 0) {
        abs_perc = self.percent;
        tic_color = UIColorFromRGB(0xF0663A);
        // first build orange
    } else {
        // cooling, with negative percentage, shown with blue ticks
        abs_perc = fabs(self.percent);
        tic_color = UIColorFromRGB(0x3B99C9);
    }
    self.progressLayer.strokeEnd = 0.0f; // not even started yet
    for (id key in self.markLayers) {
        if (fmod(([key doubleValue] + M_PI/2), 2*M_PI) <= abs_perc*2*M_PI) { // 0 to 1 needs to go on a 3 PI/2 to 7pi/2 range, add pi/2 and clamp it to 0 through 2pi
            // might increase line width as well
            ((CAShapeLayer*)[self.markLayers objectForKey:key]).strokeColor = tic_color.CGColor; // place holder, color tick marks firstbuild orange as a progress indicator
            ((CAShapeLayer*)[self.markLayers objectForKey:key]).lineWidth = full_tick_width;
        } else {
            ((CAShapeLayer*)[self.markLayers objectForKey:key]).strokeColor = [UIColor grayColor].CGColor;
            ((CAShapeLayer*)[self.markLayers objectForKey:key]).lineWidth = empty_tick_width;
        }
    }
    self.sittingLayer.strokeEnd = 0.0F;
    
}

@end
