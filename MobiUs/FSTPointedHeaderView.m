//
//  FSTPointedHeaderView.m
//  FirstBuild
//
//  Created by John Nolan on 7/8/15.
//  Copyright (c) 2015 FirstBuild. All rights reserved.
//

#import "FSTPointedHeaderView.h"

@implementation FSTPointedHeaderView

// this could be set as the selected view for the tables, since the push segue is a bit awkward
- (void)drawRect:(CGRect)rect {
    
    CGFloat pOffset = 15.0; // offset of arrow, might want to tie this to the label view
    CGFloat frameH = self.bounds.size.height - pOffset; // frame height before arrow
    CGFloat midW = self.bounds.size.width/2;
    CGFloat arrowW = 20.0;
    
    UIColor* arrowColor = UIColorFromRGB(0xFF0105);
    
    UIBezierPath* headPath = [UIBezierPath bezierPath];
    
    UIBezierPath* basePath = [UIBezierPath bezierPath];
    
    [basePath moveToPoint:CGPointMake(0, self.bounds.size.height)];
    [basePath addLineToPoint:CGPointMake(self.bounds.size.width, self.bounds.size.height)];
    [basePath addLineToPoint:CGPointMake(self.bounds.size.width, frameH)];
    [basePath addLineToPoint:CGPointMake(0, frameH)];
    [basePath addLineToPoint:CGPointMake(0, self.bounds.size.height)];
    //rectangle behind arrow
    [[UIColor clearColor] setFill];
    
    [basePath fill]; // add transparent border on the bottom
    
    [headPath moveToPoint:CGPointMake(0, 0)];
    [headPath addLineToPoint:CGPointMake(0, frameH)]; // rect origin might always be 0, 0 , replace rect.origin.x if not
    [headPath addLineToPoint:CGPointMake(midW - (arrowW/2), frameH)]; //just to the left of the arrow
    [headPath addLineToPoint:CGPointMake(midW, frameH + pOffset)]; // go down to base of the rect
    [headPath addLineToPoint:CGPointMake(midW + (arrowW/2), frameH)]; // right of arrow
    [headPath addLineToPoint:CGPointMake(self.bounds.size.width, frameH)];
    [headPath addLineToPoint:CGPointMake(self.bounds.size.width, 0)]; // top of frame
    [headPath addLineToPoint:CGPointMake(0, 0)]; // close the path
    
    [[UIColor whiteColor] setFill];
    
    [headPath fill];
    
    headPath.lineWidth = 2;
    
    [arrowColor setStroke];
    
    [headPath stroke];
    
    self.backgroundColor = [UIColor whiteColor];
    self.clipsToBounds = NO;
}


@end
