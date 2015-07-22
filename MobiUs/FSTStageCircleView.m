//
//  FSTStageCircleView.m
//  FirstBuild
//
//  Created by John Nolan on 7/14/15.
//  Copyright (c) 2015 FirstBuild. All rights reserved.
//

#import "FSTStageCircleView.h"

@implementation FSTStageCircleView


-(id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.opaque = NO;
    }
    return self;
}
- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    UIBezierPath* circlePath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.frame.size.width/2, self.frame.size.height/2) radius:self.frame.size.width/3 startAngle:0 endAngle:2*M_PI clockwise:false];
    
    CGContextSaveGState(context);
    circlePath.lineWidth = 2.0;
    [[UIColor redColor] setStroke];
    [circlePath stroke];
    self.backgroundColor = [UIColor clearColor];
    CGContextRestoreGState(context);
}

@end
