//
//  UIDashedLineView.m
//  FirstBuild
//
//  Created by Myles Caley on 5/26/15.
//  Copyright (c) 2015 FirstBuild. All rights reserved.
//

#import "UIDashedLineView.h"

@implementation UIDashedLineView

-(void)drawRect:(CGRect)rect
{
    CGFloat thickness = 1;
    
    CGContextRef cx = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(cx, thickness);
    CGContextSetLineCap(cx, kCGLineCapRound);
    
    CGContextSetStrokeColorWithColor(cx, UIColorFromRGB(0x908982).CGColor);
    
    CGFloat ra[] = {1,5};
    CGContextSetLineDash(cx, 0.0, ra, 2); // nb "2" == ra count
    
    CGContextMoveToPoint(cx, 0,thickness*0.5);
    
    CGContextAddLineToPoint(cx, self.bounds.size.width, thickness*0.5);
    
    CGContextStrokePath(cx);
}

@end
