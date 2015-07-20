//
//  FSTStageBarView.m
//  FirstBuild
//
//  Created by John Nolan on 7/14/15.
//  Copyright (c) 2015 FirstBuild. All rights reserved.
//

#import "FSTStageBarView.h"

@implementation FSTStageBarView


- (void)drawRect:(CGRect)rect {
    
    CGFloat x_start = self.frame.size.width/10; // the starting x coordinate (starts at beginning
    CGFloat x_end = self.frame.size.width - x_start;
    CGFloat width = x_end - x_start; // width of the whole line
    CGFloat y = self.frame.size.height/2; // mid point as every y coordinate
    UIBezierPath* underPath = [UIBezierPath bezierPath];
    
    self.lineWidth = width; // let the viewContoller access that for position calculations
    [underPath moveToPoint:CGPointMake(x_start, y)];
    [underPath addLineToPoint:CGPointMake(x_end, y)];
    [[UIColor lightGrayColor] setStroke];
    [underPath stroke]; // paint it light gray
    
    UIBezierPath* dot1 = [UIBezierPath bezierPathWithArcCenter:CGPointMake(x_start, y) radius:3.0 startAngle:0 endAngle:2*M_PI clockwise:false];
    UIBezierPath* dot2 = [UIBezierPath bezierPathWithArcCenter:CGPointMake(x_start + width/3, y) radius:3.0 startAngle:0 endAngle:2*M_PI clockwise:false];
    UIBezierPath* dot3 = [UIBezierPath bezierPathWithArcCenter:CGPointMake(x_start + 2*width/3, y) radius:3.0 startAngle:0 endAngle:2*M_PI clockwise:false];
    UIBezierPath* dot4 = [UIBezierPath bezierPathWithArcCenter:CGPointMake(x_start + width, y) radius:3.0 startAngle:0 endAngle:2*M_PI clockwise:false];
    dot1.lineWidth = 6.0;
    dot2.lineWidth = 6.0;
    dot3.lineWidth = 6.0;
    dot4.lineWidth = 6.0;
    
    [[UIColor orangeColor] setStroke];

    [dot1 stroke]; // might prefer fill
    [dot2 stroke];
    [dot3 stroke];
    [dot4 stroke];
}


@end
