//
//  FSTRoundedBorderView.m
//  FirstBuild
//
//  Created by John Nolan on 9/3/15.
//  Copyright (c) 2015 FirstBuild. All rights reserved.
//

#import "FSTRoundedBorderView.h"

@implementation FSTRoundedBorderView

-(void)layoutSubviews {
    [super layoutSubviews];
  //  [self drawRect:self.frame];
    CGFloat line_width = 4.0f;
    self.layer.borderWidth = line_width;
    self.layer.cornerRadius = 25.0f;//self.frame.size.width/5;
    self.layer.borderColor = UIColorFromRGB(0xF0663A).CGColor;//[UIColor orangeColor].CGColor;
    self.layer.backgroundColor = [UIColor whiteColor].CGColor;
    self.layer.masksToBounds = YES;
}

/*- (void)drawRect:(CGRect)rect {
   // self.layer.borderWidth
    [super drawRect:rect];
    CGFloat line_width = 4.0f;
    UIBezierPath* borderPath = [UIBezierPath bezierPath];
    
    [borderPath moveToPoint:CGPointMake(rect.size.width - line_width/2, 0)]; // top right corner
    
    [borderPath addLineToPoint:CGPointMake(rect.size.width - line_width/2, rect.size.height - line_width/2)];
    
    [borderPath addLineToPoint:CGPointMake(0, rect.size.height - line_width/2)]; // trace out bottom right cornder
    borderPath.lineJoinStyle = kCGLineJoinRound;*/
   /* self.layer.borderWidth = line_width;
    self.layer.cornerRadius = rect.size.width/5;
    self.layer.borderColor = UIColorFromRGB(0xF0663A).CGColor;//[UIColor orangeColor].CGColor;
    self.layer.backgroundColor = [UIColor whiteColor].CGColor;
    // TODO make this first build orange
}*/

@end
