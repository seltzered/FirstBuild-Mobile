//
//  FSTDashedLine.m
//  FirstBuild
//
//  Created by John Nolan on 7/6/15.
//  Copyright (c) 2015 FirstBuild. All rights reserved.
//

#import "FSTDashedLine.h"

@implementation FSTDashedLine


- (void)drawRect:(CGRect)rect {
    CGFloat ystart = rect.size.height/2;
    CGFloat xstart = 0;
    UIBezierPath* path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(xstart, ystart)];
    [path addLineToPoint:CGPointMake(xstart+rect.size.width, ystart)];
    CGFloat dash[] = {3, 6}; // length, gaps
    [path setLineDash:dash count: 2 phase:9]; // phase might be zero
    
    UIColor* strokeColor = UIColorFromRGB(0xE40039); // reddish?
    [strokeColor setStroke];
    [path stroke];
}


@end
