//
//  ProductGradientView.m
//  FirstBuild
//
//  Created by John Nolan on 7/24/15.
//  Copyright (c) 2015 FirstBuild. All rights reserved.
//

#import "ProductGradientView.h"

@implementation ProductGradientView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    
    CAGradientLayer* gradientMask = [CAGradientLayer layer];
    gradientMask.frame = self.bounds;
    gradientMask.colors = [NSArray arrayWithObjects:(id)[[UIColor colorWithWhite:0.0 alpha:0.0] CGColor], (id)[[UIColor colorWithWhite:0.0 alpha:1.0] CGColor], nil];
    
    CGPoint top = CGPointMake(0.5, 1.0);//midx, gradientMask.bounds.origin.y);
    CGPoint bottom = CGPointMake(0.5, 0.0);//midx, gradientMask.bounds.size.height);
    
    if (self.up) { // up set through the table view controller
        gradientMask.startPoint = bottom;
        gradientMask.endPoint = top; // gradient travels upwards (white to clear
    }
    else {
        gradientMask.startPoint = top;
        gradientMask.endPoint = bottom;
    }
    
    self.layer.mask = gradientMask;
}


@end
