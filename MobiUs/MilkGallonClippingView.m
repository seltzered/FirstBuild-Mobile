//
//  MilkGallonClippingView.m
//  FirstBuild-Mobile
//
//  Created by Myles Caley on 1/6/15.
//  Copyright (c) 2015 FirstBuild. All rights reserved.
//

#import "MilkGallonClippingView.h"

@implementation MilkGallonClippingView

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    UIColor* strokeColor = UIColorFromRGB(0x717073);
    UIColor* strokeColor1 = UIColorFromRGB(0x717073);
    UIColor* strokeColor2 = UIColorFromRGB(0x717073);
    UIColor* strokeColor3 = UIColorFromRGB(0x717073);
    UIBezierPath* path = [UIBezierPath bezierPath];
    UIBezierPath* path1 = [UIBezierPath bezierPath];
    UIBezierPath* path2 = [UIBezierPath bezierPath];
    UIBezierPath* path3 = [UIBezierPath bezierPath];
    path.lineWidth = 7.88;
    path1.lineWidth = 7.88;
    path2.lineWidth = 7.88;
    path3.lineWidth = 3.94;
    self.clippingPath = path;

    [path moveToPoint: CGPointMake(207,176)];
    [path addCurveToPoint: CGPointMake(193,76) controlPoint1: CGPointMake(200,115) controlPoint2: CGPointMake(203,92)];
    [path addCurveToPoint: CGPointMake(133,38) controlPoint1: CGPointMake(182,60) controlPoint2: CGPointMake(139,46)];
    [path addCurveToPoint: CGPointMake(129,31) controlPoint1: CGPointMake(130,34) controlPoint2: CGPointMake(129,31)];
    [path addCurveToPoint: CGPointMake(129,30) controlPoint1: CGPointMake(129,31) controlPoint2: CGPointMake(129,31)];
    [path addCurveToPoint: CGPointMake(129,28) controlPoint1: CGPointMake(129,30) controlPoint2: CGPointMake(129,29)];
    [path addCurveToPoint: CGPointMake(128,25) controlPoint1: CGPointMake(129,27) controlPoint2: CGPointMake(129,26)];
    [path addCurveToPoint: CGPointMake(127,22) controlPoint1: CGPointMake(127,24) controlPoint2: CGPointMake(127,23)];
    [path addCurveToPoint: CGPointMake(127,7) controlPoint1: CGPointMake(127,21) controlPoint2: CGPointMake(127,7)];
    [path addCurveToPoint: CGPointMake(102,3) controlPoint1: CGPointMake(127,7) controlPoint2: CGPointMake(126,3)];
    [path addCurveToPoint: CGPointMake(79,8) controlPoint1: CGPointMake(102,3) controlPoint2: CGPointMake(79,3)];
    [path addCurveToPoint: CGPointMake(79,23) controlPoint1: CGPointMake(79,14) controlPoint2: CGPointMake(79,23)];
    [path addLineToPoint: CGPointMake(78,25)];
    [path addCurveToPoint: CGPointMake(76,28) controlPoint1: CGPointMake(77,25) controlPoint2: CGPointMake(76,27)];
    [path addCurveToPoint: CGPointMake(77,30) controlPoint1: CGPointMake(76,29) controlPoint2: CGPointMake(76,30)];
    [path addLineToPoint: CGPointMake(75,34)];
    [path addLineToPoint: CGPointMake(41,56)];
    [path addLineToPoint: CGPointMake(36,73)];
    [path addLineToPoint: CGPointMake(25,86)];
    [path addCurveToPoint: CGPointMake(3,249) controlPoint1: CGPointMake(25,86) controlPoint2: CGPointMake(3,183)];
    [path addCurveToPoint: CGPointMake(6,296) controlPoint1: CGPointMake(3,281) controlPoint2: CGPointMake(6,296)];
    [path addCurveToPoint: CGPointMake(17,315) controlPoint1: CGPointMake(6,296) controlPoint2: CGPointMake(10,308)];
    [path addCurveToPoint: CGPointMake(47,322) controlPoint1: CGPointMake(23,322) controlPoint2: CGPointMake(35,322)];
    [path addCurveToPoint: CGPointMake(154,321) controlPoint1: CGPointMake(58,322) controlPoint2: CGPointMake(154,321)];
    [path addLineToPoint: CGPointMake(159,317)];
    [path addLineToPoint: CGPointMake(164,322)];
    [path addLineToPoint: CGPointMake(186,322)];
    [path addCurveToPoint: CGPointMake(203,306) controlPoint1: CGPointMake(186,322) controlPoint2: CGPointMake(198,322)];
    [path addCurveToPoint: CGPointMake(207,176) controlPoint1: CGPointMake(207,289) controlPoint2: CGPointMake(214,238)];
    [strokeColor setStroke];
    //path.lineWidth = 7.88;
    [path stroke];
    
    //UIColor* strokeColor1 = [UIColor colorWithRed: 0 green: 0 blue: 0 alpha: 1];
    //UIBezierPath* path1 = [UIBezierPath bezierPath];
    [path1 moveToPoint: CGPointMake(70,158)];
    [path1 addCurveToPoint: CGPointMake(60,167) controlPoint1: CGPointMake(70,163) controlPoint2: CGPointMake(65,167)];
    [path1 addLineToPoint: CGPointMake(60,167)];
    [path1 addCurveToPoint: CGPointMake(51,157) controlPoint1: CGPointMake(55,166) controlPoint2: CGPointMake(51,162)];
    [path1 addLineToPoint: CGPointMake(57,76)];
    [path1 addCurveToPoint: CGPointMake(67,68) controlPoint1: CGPointMake(57,71) controlPoint2: CGPointMake(62,67)];
    [path1 addLineToPoint: CGPointMake(67,68)];
    [path1 addCurveToPoint: CGPointMake(75,78) controlPoint1: CGPointMake(72,68) controlPoint2: CGPointMake(76,72)];
    [path1 addLineToPoint: CGPointMake(70,158)];
    [strokeColor1 setStroke];
    //path1.lineWidth = 0.5;
    [path1 stroke];
    
    //UIColor* strokeColor2 = [UIColor colorWithRed: 0 green: 0 blue: 0 alpha: 1];
    //UIBezierPath* path2 = [UIBezierPath bezierPath];
    [path2 moveToPoint: CGPointMake(37,71)];
    [path2 addCurveToPoint: CGPointMake(24,166) controlPoint1: CGPointMake(37,71) controlPoint2: CGPointMake(28,159)];
    [path2 addCurveToPoint: CGPointMake(14,177) controlPoint1: CGPointMake(20,172) controlPoint2: CGPointMake(14,177)];
    [strokeColor2 setStroke];
    //path2.lineWidth = 0.5;
    [path2 stroke];
    
    //UIColor* strokeColor3 = [UIColor colorWithRed: 0 green: 0 blue: 0 alpha: 1];
    //UIBezierPath* path3 = [UIBezierPath bezierPath];
    [path3 moveToPoint: CGPointMake(79,24)];
    [path3 addCurveToPoint: CGPointMake(103,21) controlPoint1: CGPointMake(86,22) controlPoint2: CGPointMake(94,21)];
    [path3 addCurveToPoint: CGPointMake(128,24) controlPoint1: CGPointMake(112,21) controlPoint2: CGPointMake(121,22)];
    [strokeColor3 setStroke];
    //path3.lineWidth = 0.5;
    [path3 stroke];
    
}


@end
