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
    
    CGFloat gradLocations[2] = {1.0f, 0.0f}; // was 1 to 0
    NSArray* gradColors = [NSArray arrayWithObjects:
                           (id)[UIColorFromRGB(0x7C5F58) colorWithAlphaComponent:0.7].CGColor,
                           (id)[UIColorFromRGB(0x782A25) colorWithAlphaComponent:0.7].CGColor, // make this an argument? property most likely
                           nil];
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (CFArrayRef)gradColors, gradLocations);
    CGColorSpaceRelease(colorSpace);

    CGFloat widthOffset = 5.0; // set brown closer to side edges.

    //CGContextSaveGState(context); // begin drawing over this?
    CGPoint center = CGPointMake(rect.size.width/2, rect.size.height/2);
    // goes to bottom right cornder
    CGContextDrawRadialGradient(context, gradient, center, (rect.size.height)/4.0, CGPointMake(rect.size.width + widthOffset, rect.size.height), (rect.size.height)/2, kCGGradientDrawsAfterEndLocation); // how to find rounded corners?
    //CGContextSaveGState(context);
    // to bottom left corner
    CGContextDrawRadialGradient(context, gradient, center, (rect.size.height)/4.0, CGPointMake(-widthOffset, rect.size.height), (rect.size.height)/2, kCGGradientDrawsAfterEndLocation);
    // to top left corner
    CGContextDrawRadialGradient(context, gradient, center, (rect.size.height)/4.0, CGPointMake(-widthOffset, 0), (rect.size.height)/2, kCGGradientDrawsAfterEndLocation);
    // to top right corner
    CGContextDrawRadialGradient(context, gradient, center, (rect.size.height)/4.0, CGPointMake(rect.size.width + widthOffset, 0), (rect.size.height)/2, kCGGradientDrawsAfterEndLocation);
    //top
    CGContextDrawLinearGradient(context, gradient,  CGPointMake(0, 0), CGPointMake(0,rect.size.height), kCGGradientDrawsAfterEndLocation);
    //CGContextSaveGState(context);
    
    //bottom
    CGContextDrawLinearGradient(context, gradient,  CGPointMake(0, rect.size.height), CGPointMake(0,0), kCGGradientDrawsAfterEndLocation);
       //left
    CGContextDrawLinearGradient(context, gradient, center, CGPointMake(-widthOffset, rect.size.height/2), kCGGradientDrawsAfterEndLocation);
    //right
    CGContextDrawLinearGradient(context, gradient, center, CGPointMake(rect.size.width + widthOffset, rect.size.height/2), kCGGradientDrawsAfterEndLocation);
    // smooth gradient from center
    CGContextDrawRadialGradient(context, gradient, center, 0, center, rect.size.width/2, kCGGradientDrawsAfterEndLocation);

  
    
    CGGradientRelease(gradient);

}


@end
