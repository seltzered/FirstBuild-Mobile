//
//  FSTRegularLabel.m
//  FirstBuild
//
//  Created by John Nolan on 8/4/15.
//  Copyright (c) 2015 FirstBuild. All rights reserved.
//

#import "FSTRegularLabel.h"

@implementation FSTRegularLabel

- (void)layoutSubviews {
    [super layoutSubviews];
    self.font = [UIFont fontWithName: @"FSEmeric-Regular" size: self.font.pointSize];//@"FSEmeric-Thin" size:self.font.pointSize];
}


@end
