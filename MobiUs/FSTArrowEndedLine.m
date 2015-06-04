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
    
    UIColor* fillColor = [UIColorFromRGB(0x16A7C0) colorWithAlphaComponent:.5];
    UIColor* strokeColor = UIColorFromRGB(0xffffff);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    UIBezierPath* path = [UIBezierPath bezierPath];
    
    UIBezierPath* arrowPathUL = [UIBezierPath bezierPath]; // upper left
    UIBezierPath* arrowPathUR = [UIBezierPath bezierPath]; // upper right
    UIBezierPath* arrowPathLL = [UIBezierPath bezierPath]; // lower left
    UIBezierPath* arrowPathLR = [UIBezierPath bezierPath]; // lower right
    
    CGFloat xinset = bw*.1;
    CGFloat ystart = - 2;
    CGFloat yend = ystart + bh;
    CGFloat ymid = ystart + bh/2;
    CGFloat ygap = 6;
    CGFloat upArrowY = ystart + bh/4 + 1.5; // 3/4 of the way up
    CGFloat downArrowY = ystart + 3*bh/4 -1.5; // 1/4 '         '
    CGFloat arrowLX = -2 + 2*xinset/5; // left arrow x position (center of arrow)
    CGFloat arrowRX = bw + 2 - 2*xinset/5; // right arrow x position
    CGFloat arrowLength = bh/9; // vertical distance
    CGFloat arrowWidth = xinset/4; // width of entire arrow
    
    
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

    // left of UL arrow
    [arrowPathUL moveToPoint:CGPointMake(arrowLX - arrowWidth/2, upArrowY + arrowLength)];
    
    // middle of UL arrow
    [arrowPathUL addLineToPoint:CGPointMake(arrowLX, upArrowY)];
    
    // right of UL arrow
    [arrowPathUL addLineToPoint:CGPointMake(arrowLX + arrowWidth/2, upArrowY + arrowLength)];
    
    // left of LL arrow
    [arrowPathLL moveToPoint:CGPointMake(arrowLX - arrowWidth/2, downArrowY - arrowLength)];
     
    // middle of LL arrow
     [arrowPathLL addLineToPoint:CGPointMake(arrowLX, downArrowY)];
     
    // right of LL arrow
    [arrowPathLL addLineToPoint:CGPointMake(arrowLX + arrowWidth/2, downArrowY - arrowLength)];
    
    // left of UR arrow
    [arrowPathUR moveToPoint:CGPointMake(arrowRX - arrowWidth/2, upArrowY + arrowLength)];
    
    // middle of UR arrow
    [arrowPathUR addLineToPoint:CGPointMake(arrowRX, upArrowY)];
    
    // right of UR arrow
    [arrowPathUR addLineToPoint:CGPointMake(arrowRX + arrowWidth/2, upArrowY + arrowLength)];
    
    // left of LR arrow
    [arrowPathLR moveToPoint:CGPointMake(arrowRX - arrowWidth/2, downArrowY - arrowLength)];
    
    // middle of LR arrow
    [arrowPathLR addLineToPoint:CGPointMake(arrowRX, downArrowY)];
    
    // right of LR arrow
    [arrowPathLR addLineToPoint:CGPointMake(arrowRX + arrowWidth/2, downArrowY - arrowLength)];
    
    CGContextSaveGState(context);
    CGContextSetShadowWithColor(context, CGSizeMake(0, 2), 2.0, [[UIColor lightGrayColor]CGColor]);
    
//    CGContextSaveGState(context);
//    CGContextSetShadowWithColor(context, CGSizeMake(0, -2), 2.0, [[UIColor lightGrayColor]CGColor]);
    [fillColor setFill];
    [path fill];
    
    CGContextRestoreGState(context);
    
    [strokeColor setStroke];
    path.lineWidth = 2;
    arrowPathUL.lineWidth = 2;
    arrowPathUR.lineWidth = 2;
    arrowPathLL.lineWidth = 2;
    arrowPathLR.lineWidth = 2;

    [path stroke];
    [arrowPathUL stroke];
    [arrowPathUR stroke];
    [arrowPathLR stroke];
    [arrowPathLL stroke];
    
}


@end
