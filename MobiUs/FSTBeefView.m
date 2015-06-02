//
//  FSTBeefView.m
//  FirstBuild
//
//  Created by Myles Caley on 6/2/15.
//  Copyright (c) 2015 FirstBuild. All rights reserved.
//

#import "FSTBeefView.h"

@implementation FSTBeefView


- (void)drawRect:(CGRect)rect {
    

    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGFloat gradLocations[2] = {1.0f, 0.0f};
    NSArray* gradColors = [NSArray arrayWithObjects:
                           (id)[UIColorFromRGB(0x7C5F58) colorWithAlphaComponent:0.8].CGColor,
                           (id)[UIColorFromRGB(0x782A25) colorWithAlphaComponent:0.8].CGColor,
                           nil];
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (CFArrayRef)gradColors, gradLocations);
    CGColorSpaceRelease(colorSpace);

    
    //top
    CGContextDrawLinearGradient(context, gradient,  CGPointMake(0, 0), CGPointMake(0,rect.size.height), kCGGradientDrawsAfterEndLocation);
    
    CGContextSaveGState(context);
    
    //bottom
    CGContextDrawLinearGradient(context, gradient,  CGPointMake(0, rect.size.height), CGPointMake(0,0), kCGGradientDrawsAfterEndLocation);
    
    CGContextSaveGState(context);
    
    CGGradientRelease(gradient);

}


@end
