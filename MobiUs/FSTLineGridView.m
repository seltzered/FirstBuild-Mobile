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
    
    CGFloat bh = self.bounds.size.height;
    CGFloat bw = self.bounds.size.width;

    uint8_t num = 8; //todo: need a const for the number of thicknesses
    uint8_t dist = bh/num;
    CGFloat xinset = bw*.07;
    
    UIBezierPath* path = [UIBezierPath bezierPath];
    
    for (uint8_t i = 1; i <= num; i++)
    {
        path = [UIBezierPath bezierPath];
        [path moveToPoint: CGPointMake(xinset,dist*i)];
        [path addLineToPoint: CGPointMake(bw-xinset,dist*i)];
        //[fillColor setFill];
        [strokeColor setStroke];
        path.lineWidth = 2;
        [path stroke];
    }
    
}

@end
