//
//  MilkGallonStand.m
//  FirstBuild-Mobile
//
//  Created by Myles Caley on 1/7/15.
//  Copyright (c) 2015 FirstBuild. All rights reserved.
//

#import "MilkGallonStand.h"

@implementation MilkGallonStand


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
     [super drawRect:rect];
    UIColor* fillColor = [UIColor colorWithRed: 0.843 green: 0.85 blue: 0.854 alpha: 1];
    UIColor* strokeColor = [UIColor colorWithRed: 0.443 green: 0.439 blue: 0.45 alpha: 1];
    UIBezierPath* path = [UIBezierPath bezierPath];
    [path moveToPoint: CGPointMake(204,315)];
    [path addCurveToPoint: CGPointMake(189,326) controlPoint1: CGPointMake(199,326) controlPoint2: CGPointMake(189,326)];
    [path addLineToPoint: CGPointMake(166,326)];
    [path addLineToPoint: CGPointMake(160,321)];
    [path addLineToPoint: CGPointMake(155,325)];
    [path addCurveToPoint: CGPointMake(44,326) controlPoint1: CGPointMake(155,325) controlPoint2: CGPointMake(57,326)];
    [path addCurveToPoint: CGPointMake(13,319) controlPoint1: CGPointMake(32,326) controlPoint2: CGPointMake(20,326)];
    [path addCurveToPoint: CGPointMake(7,310) controlPoint1: CGPointMake(11,316) controlPoint2: CGPointMake(9,313)];
    [path addLineToPoint: CGPointMake(6,310)];
    [path addLineToPoint: CGPointMake(-3,310)];
    [path addCurveToPoint: CGPointMake(-8,314) controlPoint1: CGPointMake(-3,310) controlPoint2: CGPointMake(-8,311)];
    [path addCurveToPoint: CGPointMake(-8,324) controlPoint1: CGPointMake(-8,318) controlPoint2: CGPointMake(-8,324)];
    [path addCurveToPoint: CGPointMake(-4,329) controlPoint1: CGPointMake(-8,324) controlPoint2: CGPointMake(-9,325)];
    [path addCurveToPoint: CGPointMake(20,342) controlPoint1: CGPointMake(0,332) controlPoint2: CGPointMake(20,342)];
    [path addCurveToPoint: CGPointMake(31,344) controlPoint1: CGPointMake(20,342) controlPoint2: CGPointMake(21,344)];
    [path addCurveToPoint: CGPointMake(230,344) controlPoint1: CGPointMake(40,345) controlPoint2: CGPointMake(230,344)];
    [path addCurveToPoint: CGPointMake(234,338) controlPoint1: CGPointMake(230,344) controlPoint2: CGPointMake(234,344)];
    [path addCurveToPoint: CGPointMake(234,324) controlPoint1: CGPointMake(234,333) controlPoint2: CGPointMake(234,324)];
    [path addLineToPoint: CGPointMake(204,315)];
    [fillColor setFill];
    [path fill];
    [strokeColor setStroke];
    path.lineWidth = 1.9718900000000001;
    [path stroke];
    
    UIColor* fillColor1 = [UIColor colorWithRed: 0.843 green: 0.85 blue: 0.854 alpha: 1];
    UIColor* strokeColor1 = [UIColor colorWithRed: 0.443 green: 0.439 blue: 0.45 alpha: 1];
    UIBezierPath* path1 = [UIBezierPath bezierPath];
    [path1 moveToPoint: CGPointMake(6,339)];
    [path1 addLineToPoint: CGPointMake(-3,338)];
    [path1 addCurveToPoint: CGPointMake(-8,343) controlPoint1: CGPointMake(-3,338) controlPoint2: CGPointMake(-8,339)];
    [path1 addCurveToPoint: CGPointMake(-8,353) controlPoint1: CGPointMake(-8,347) controlPoint2: CGPointMake(-8,353)];
    [path1 addCurveToPoint: CGPointMake(-4,358) controlPoint1: CGPointMake(-8,353) controlPoint2: CGPointMake(-9,354)];
    [path1 addCurveToPoint: CGPointMake(20,371) controlPoint1: CGPointMake(0,361) controlPoint2: CGPointMake(20,371)];
    [path1 addCurveToPoint: CGPointMake(31,373) controlPoint1: CGPointMake(20,371) controlPoint2: CGPointMake(21,373)];
    [path1 addCurveToPoint: CGPointMake(230,373) controlPoint1: CGPointMake(40,374) controlPoint2: CGPointMake(230,373)];
    [path1 addCurveToPoint: CGPointMake(234,367) controlPoint1: CGPointMake(230,373) controlPoint2: CGPointMake(234,373)];
    [path1 addCurveToPoint: CGPointMake(234,353) controlPoint1: CGPointMake(234,362) controlPoint2: CGPointMake(234,353)];
    [path1 addLineToPoint: CGPointMake(204,343)];
    [fillColor1 setFill];
    [path1 fill];
    [strokeColor1 setStroke];
    path1.lineWidth = 1.9718900000000001;
    [path1 stroke];
    
    UIColor* strokeColor2 = [UIColor colorWithRed: 0.443 green: 0.439 blue: 0.45 alpha: 1];
    UIBezierPath* path2 = [UIBezierPath bezierPath];
    [path2 moveToPoint: CGPointMake(-3,312)];
    [path2 addLineToPoint: CGPointMake(18,322)];
    [strokeColor2 setStroke];
    path2.lineWidth = 1.9718900000000001;
    [path2 stroke];
    
    UIColor* fillColor3 = [UIColor colorWithRed: 0.949 green: 0.396 blue: 0.133 alpha: 1];
    UIColor* strokeColor3 = [UIColor colorWithRed: 0.56 green: 0.215 blue: 0.078 alpha: 1];
    UIBezierPath* path3 = [UIBezierPath bezierPath];
    [path3 moveToPoint: CGPointMake(-4,329)];
    [path3 addLineToPoint: CGPointMake(-4,338)];
    [path3 addLineToPoint: CGPointMake(24,355)];
    [path3 addLineToPoint: CGPointMake(230,354)];
    [path3 addLineToPoint: CGPointMake(230,344)];
    [path3 addLineToPoint: CGPointMake(25,344)];
    [path3 addLineToPoint: CGPointMake(-4,329)];
    [fillColor3 setFill];
    [path3 fill];
    [strokeColor3 setStroke];
    path3.lineWidth = 1.91087;
    [path3 stroke];
    
}


@end
