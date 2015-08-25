//
//  FSTSavedRecipeUnderLineView.m
//  FirstBuild
//
//  Created by John Nolan on 8/24/15.
//  Copyright (c) 2015 FirstBuild. All rights reserved.
//

#import "FSTSavedRecipeUnderLineView.h"

@interface FSTSavedRecipeUnderLineView()

@property (nonatomic, strong) UIView* underLine;

@end

@implementation FSTSavedRecipeUnderLineView

CGFloat ulWidth;

- (void)drawRect:(CGRect)rect {
    UIBezierPath* grayPath = [UIBezierPath bezierPath];
    grayPath.lineWidth = 2*rect.size.height/3;
    [grayPath moveToPoint:CGPointMake(rect.origin.x, rect.size.height/2)];
    [grayPath addLineToPoint:CGPointMake(rect.size.width, rect.size.height/2)];
    [[UIColor lightGrayColor] setStroke];
    [grayPath stroke];
    
    self.underLine = [[UIView alloc] init];
    [self addSubview:self.underLine];
    ulWidth = rect.size.width/8; // change size of orange underline
    //TODO: change to firstbuild orange
    self.underLine.backgroundColor = [UIColor orangeColor];
    self.underLine.frame = CGRectMake(rect.size.width/2 - ulWidth/2, 0, ulWidth, rect.size.height);
}

- (void)setHorizontalPosition:(CGFloat)position {
    
    [self.underLine setFrame:CGRectMake(position - ulWidth/2, 0, ulWidth, self.frame.size.height)];
    
}

@end
