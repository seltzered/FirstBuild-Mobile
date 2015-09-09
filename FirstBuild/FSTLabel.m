//
//  FSTLabel.m
//  FirstBuild
//
//  Created by John Nolan on 7/30/15.
//  Copyright (c) 2015 FirstBuild. All rights reserved.
//

#import "FSTLabel.h"

@implementation FSTLabel

// meant to work around the error with custom fonts and different layouts
- (void)layoutSubviews {
    [super layoutSubviews];
    self.font = [UIFont fontWithName: @"FSEmeric-Thin" size: self.font.pointSize];//@"FSEmeric-Thin" size:self.font.pointSize];
}

@end
