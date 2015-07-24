//
//  FSTLine.m
//  FirstBuild
//
//  Created by John Nolan on 7/24/15.
//  Copyright (c) 2015 FirstBuild. All rights reserved.
//

#import "FSTLine.h"

@implementation FSTLine

// new class for grey lines
- (void)drawRect:(CGRect)rect {
    CGFloat ystart = rect.size.height/2;
    CGFloat xstart = 0;
    UIBezierPath* path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(xstart, ystart)];
    [path addLineToPoint:CGPointMake(xstart+rect.size.width, ystart)];
    
    UIColor* strokeColor = [UIColor grayColor]; // might add an alpha
    [strokeColor setStroke];
    [path stroke];
}


@end
