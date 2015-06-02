//
//  FSTLineGridView.m
//  FirstBuild
//
//  Created by Myles Caley on 5/29/15.
//  Copyright (c) 2015 FirstBuild. All rights reserved.
//

#import "FSTLineGridView.h"

@implementation FSTLineGridView


- (void)drawRect:(CGRect)rect {
    
    UIColor* strokeColor = [UIColorFromRGB(0xE6E7E8) colorWithAlphaComponent:1];
//    UIColor* topStrokeColor = [UIColorFromRGB(0xDE4A32) colorWithAlphaComponent:1];
    
    CGFloat bh = self.bounds.size.height;
    CGFloat bw = self.bounds.size.width;

    uint8_t num = 10; //todo: need a const for the number of thicknesses
    uint8_t dist = bh/num;
    CGFloat xinset = bw*.085;
    CGFloat yinset = 0;
    
    UIBezierPath* path = [UIBezierPath bezierPath];
    
    //orange bar at top
//    path = [UIBezierPath bezierPath];
//    [path moveToPoint:CGPointMake(0,0)];
//    [path addLineToPoint:CGPointMake(bw,0)];
//    [topStrokeColor setStroke];
//    path.lineWidth = 4;
//    [path stroke];
    
    for (uint8_t i = 1; i <= num; i++)
    {
        path = [UIBezierPath bezierPath];
        [path moveToPoint: CGPointMake(xinset,yinset + dist*i)];
        [path addLineToPoint: CGPointMake(bw-xinset,yinset + dist*i)];
        //[fillColor setFill];
        [strokeColor setStroke];
        path.lineWidth = 2;
        [path stroke];
    }
    
}

@end
