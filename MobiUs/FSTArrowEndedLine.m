//
//  FSTArrowEndedLine.m
//  FirstBuild
//
//  Created by Myles Caley on 5/29/15.
//  Copyright (c) 2015 FirstBuild. All rights reserved.
//

#import "FSTArrowEndedLine.h"

@implementation FSTArrowEndedLine


- (void)drawRect:(CGRect)rect {
    CGFloat bh = self.bounds.size.height;
    CGFloat bw = self.bounds.size.width;
    
    UIColor* fillColor = UIColorFromRGB(0x16A7C0);
    UIColor* strokeColor = UIColorFromRGB(0xffffff);
    UIBezierPath* path = [UIBezierPath bezierPath];
    
    CGFloat xinset = bw*.1;
    CGFloat ystart = bh/2 - 2;
    CGFloat yend = ystart + bh;
    CGFloat ymid = ystart + bh/2;
    CGFloat ygap = 6;
    
    //top left
    [path moveToPoint: CGPointMake(-2,ystart)];
    
    //inset top left
    [path addLineToPoint: CGPointMake(xinset,(ymid)-ygap)];
    
    //inset top right
    [path addLineToPoint: CGPointMake(bw-(xinset),(ymid)-ygap)];

    //top right
    [path addLineToPoint: CGPointMake(bw+2,ystart)];
    
    //bottom right
    [path addLineToPoint: CGPointMake(bw+2,yend)];
    
    //inset bottom right
    [path addLineToPoint: CGPointMake(bw-(xinset),(ymid)+ygap)];
    
    //inset bottom left
    [path addLineToPoint: CGPointMake(xinset,(ymid)+ygap)];
    
    //bottom left
    [path addLineToPoint: CGPointMake(-2,yend)];
    
    //close
    [path addLineToPoint: CGPointMake(-2,ystart)];

    [fillColor setFill];
    [path fill];
    [strokeColor setStroke];
    path.lineWidth = 2;
    [path stroke];
}


@end
