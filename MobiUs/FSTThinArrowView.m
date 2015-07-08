//
//  FSTThinArrowView.m
//  FirstBuild
//
//  Created by John Nolan on 7/8/15.
//  Copyright (c) 2015 FirstBuild. All rights reserved.
//

#import "FSTThinArrowView.h"

@implementation FSTThinArrowView


- (void)drawRect:(CGRect)rect {
    
    CGFloat line_start, line_end, point_top, point_bottom, point_width, mid_y;
    
    line_start = 5; // first x cordinate of line
    line_end = rect.size.width - line_start; // centered in rect
    point_top = rect.size.height/4; // y coordinate over arrow point
    point_bottom = 3*rect.size.height/4;
    point_width = rect.size.width/5;
    mid_y = self.bounds.size.height/2;
  
    UIColor* strokeColor = [UIColor whiteColor];
    UIBezierPath* linePath = [UIBezierPath bezierPath]; // line leading to point
    UIBezierPath* arrowPath = [UIBezierPath bezierPath]; //point
    
    [linePath moveToPoint:CGPointMake(line_start, mid_y)];
    
    [linePath addLineToPoint:CGPointMake(line_end, mid_y)];
    
    [arrowPath moveToPoint:CGPointMake(line_end - point_width, point_top)];
    
    [arrowPath addLineToPoint:CGPointMake(line_end, mid_y)];
    
    [arrowPath addLineToPoint:CGPointMake(line_end - point_width, point_bottom)];
    
    [strokeColor setStroke];
    linePath.lineWidth = 1;
    arrowPath.lineWidth = 1; // pretty thin line
    [linePath stroke];
    [arrowPath stroke];
    
}


@end
