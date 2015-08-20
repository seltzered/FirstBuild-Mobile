//
//  FSTDottedDividerView.m
//  FirstBuild
//
//  Created by John Nolan on 8/20/15.
//  Copyright (c) 2015 FirstBuild. All rights reserved.
//

#import "FSTDottedDividerView.h"

@implementation FSTDottedDividerView


- (void)drawRect:(CGRect)rect {
    
    UIBezierPath* dottedPath = [UIBezierPath bezierPath];
    
    //dotted line down the center
    dottedPath.lineWidth = 0.8;
    float dashPattern[] = {2, 4};
    [dottedPath setLineDash:dashPattern count:2 phase:0];
    [dottedPath moveToPoint:CGPointMake(rect.size.width/2, rect.origin.y)];
    [dottedPath addLineToPoint:CGPointMake(rect.size.width/2, rect.origin.y = rect.size.height)];
    
    // stroke orange
    [UIColorFromRGB(0xF0663A) setStroke];
    
    [dottedPath stroke];
}

@end
