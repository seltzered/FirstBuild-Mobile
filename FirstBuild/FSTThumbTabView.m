//
//  FSTThumbTabView.m
//  FirstBuild
//
//  Created by John Nolan on 9/3/15.
//  Copyright (c) 2015 FirstBuild. All rights reserved.
//

#import "FSTThumbTabView.h"

@implementation FSTThumbTabView

-(void)layoutSubviews {
    [super layoutSubviews];
    //  [self drawRect:self.frame];
    self.layer.cornerRadius = 5.0f;//self.frame.size.width/5;
    self.layer.backgroundColor = UIColorFromRGB(0xF0663A).CGColor;
    self.backgroundColor = UIColorFromRGB(0xF0663A);
    self.layer.masksToBounds = YES;
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    CGFloat dotOffset = 2*rect.size.height/9;
    CGFloat dotOffset_x = 6.0f; // distance from center
    CGFloat dotRadius = rect.size.width/11;
    UIBezierPath* center_dot = [self dotPathAtPoint:CGPointMake(rect.size.width/2 + dotOffset_x, rect.size.height/2) withRadius:dotRadius];
    UIBezierPath* top_dot = [self dotPathAtPoint:CGPointMake(rect.size.width/2 + dotOffset_x, rect.size.height/2 - dotOffset) withRadius:dotRadius];
    // up the offset from the center
    UIBezierPath* bottom_dot = [self dotPathAtPoint:CGPointMake(rect.size.width/2 + dotOffset_x, rect.size.height/2 + dotOffset) withRadius:dotRadius];
    // down the offset from the center
    
    [[UIColor whiteColor] setStroke];
    
    [top_dot stroke];
    [center_dot stroke];
    [bottom_dot stroke];
    
}

- (UIBezierPath*)dotPathAtPoint:(CGPoint)point withRadius:(CGFloat)radius {
    UIBezierPath* path = [UIBezierPath bezierPathWithArcCenter:point radius:radius/2 startAngle:0 endAngle:2*M_PI clockwise:NO];
    path.lineWidth = radius;
    // the path stroke should cover the center and extend to the described radius (which is why the path divided the radius)
    return path;
}

@end
