//
//  FSTDottedBorderView.m
//  FirstBuild
//
//  Created by Myles Caley on 12/1/15.
//  Copyright © 2015 FirstBuild. All rights reserved.
//

#import "FSTDottedBorderView.h"

@implementation FSTDottedBorderView
{
    CAShapeLayer* _border;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        _border = [CAShapeLayer layer];
        _border.strokeColor = [UIColor lightGrayColor].CGColor;
        _border.fillColor = nil;
        _border.lineDashPattern = @[@4, @2];
        [self.layer addSublayer:_border];
    }
    return self;
}

-(void)layoutSubviews
{
    _border.path = [UIBezierPath bezierPathWithRect:self.bounds].CGPath;
    _border.frame = self.bounds;
}


@end
