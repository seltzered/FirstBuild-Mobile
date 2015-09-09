//
//  FSTParagonDisconnectedLabel.m
//  FirstBuild
//
//  Created by John Nolan on 6/30/15.
//  Copyright (c) 2015 FirstBuild. All rights reserved.
//

#import "FSTParagonDisconnectedLabel.h"

@implementation FSTParagonDisconnectedLabel

// custom label drawn when paragon is missing
- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    self.backgroundColor = UIColorFromRGB(0xEA461A); // some universal orange color
    UIFont* warningFont = [UIFont fontWithName:@"PTSans-NarrowBold" size:24.0];
    self.font = warningFont;
    self.text = @"A device is not connected";
    self.textColor = [UIColor whiteColor];
    self.textAlignment = NSTextAlignmentCenter;
    UITapGestureRecognizer* warningTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(paragonWarningTapped)];
    [self setUserInteractionEnabled:YES];
    [self addGestureRecognizer:warningTap];
}

- (void)paragonWarningTapped {
    [self.delegate popFromWarning]; 
    
}


@end
