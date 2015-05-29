//
//  FSTGradientLensView.m
//  FirstBuild
//
//  Created by Myles Caley on 5/28/15.
//  Copyright (c) 2015 FirstBuild. All rights reserved.
//

#import "FSTGradientLensView.h"

@implementation FSTGradientLensView


- (void)drawRect:(CGRect)rect {
    
    
    //lens gradient
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGFloat gradLocations[2] = {0.0f, 1.0f};
    NSArray* gradColors = [NSArray arrayWithObjects:
                               (id)[UIColor colorWithRed: 1 green: 1 blue: 1 alpha: 0].CGColor,
                               (id)[UIColor colorWithRed: 0.137 green: 0.121 blue: 0.125 alpha: 0.400000005960465].CGColor,
                               nil];
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (CFArrayRef)gradColors, gradLocations);
    CGColorSpaceRelease(colorSpace);
    
    CGPoint gradCenter= CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
    float gradRadius = MIN((self.bounds.size.width/2) , (self.bounds.size.height/2)) ;
    
    CGContextDrawRadialGradient (context, gradient, gradCenter, 0, gradCenter, gradRadius, kCGGradientDrawsAfterEndLocation);
    
    CGGradientRelease(gradient);
    
    
    //top triangle
    UIColor* fillColor = UIColorFromRGB(0x16A7C0);
    UIColor* strokeColor = UIColorFromRGB(0x16A7C0);
    UIBezierPath* path = [UIBezierPath bezierPath];
    [path moveToPoint: CGPointMake(self.bounds.size.width/2-self.bounds.size.width*.12,3)];
    [path addLineToPoint: CGPointMake(self.bounds.size.width/2,self.bounds.size.height*.22)];
    [path addLineToPoint: CGPointMake(self.bounds.size.width/2+self.bounds.size.width*.12,3)];
    [fillColor setFill];
    [path fill];
    [strokeColor setStroke];
    path.lineWidth = 2;
    [path stroke];
    
    //bottom triangle
    fillColor = UIColorFromRGB(0x16A7C0);
    strokeColor = UIColorFromRGB(0x16A7C0);
    path = [UIBezierPath bezierPath];
    [path moveToPoint: CGPointMake(self.bounds.size.width/2-self.bounds.size.width*.12,self.bounds.size.height-3)];
    [path addLineToPoint: CGPointMake(self.bounds.size.width/2,self.bounds.size.height-self.bounds.size.height*.22)];
    [path addLineToPoint: CGPointMake(self.bounds.size.width/2+self.bounds.size.width*.12,self.bounds.size.height-3)];
    [fillColor setFill];
    [path fill];
    [strokeColor setStroke];
    path.lineWidth = 2;
    [path stroke];

}


@end
