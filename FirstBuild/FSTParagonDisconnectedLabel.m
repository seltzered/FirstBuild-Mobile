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
    
    [[self subviews]makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    self.backgroundColor = UIColorFromRGB(0xEA461A); 
    UIFont* warningFont = [UIFont fontWithName:@"PTSans-NarrowBold" size:18.0];
    
    self.font = warningFont;
    self.text = self.message;
    self.textColor = [UIColor whiteColor];
    self.textAlignment = NSTextAlignmentCenter;
    UITapGestureRecognizer* warningTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(paragonWarningTapped)];
    [self setUserInteractionEnabled:YES];
    [self addGestureRecognizer:warningTap];
    
    UIFont* closeFont = [UIFont fontWithName:@"FontAwesome" size:14.0];
    UILabel* closeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, rect.size.width*0.95, rect.size.height)];
    closeLabel.textAlignment = NSTextAlignmentRight;
    closeLabel.textColor = [UIColor whiteColor];
    closeLabel.text = @"\uf00d";
    closeLabel.font = closeFont;
    
    [self insertSubview:closeLabel atIndex:0];
    
}

- (void)paragonWarningTapped {
    [self.delegate popFromWarning]; 
    
}


@end
