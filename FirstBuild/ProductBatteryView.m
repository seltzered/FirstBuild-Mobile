//
//  ProductBatteryView.m
//  FirstBuild
//
//  Created by John Nolan on 7/21/15.
//  Copyright (c) 2015 FirstBuild. All rights reserved.
//

#import "ProductBatteryView.h"

@implementation ProductBatteryView


- (void)drawRect:(CGRect)rect { // battery view
    // outer container of battery
    
    // should all be proportional to rectangle
    CGFloat tip_width = self.frame.size.width/3;
    CGFloat liquid_inset = tip_width/3;
    CGFloat inset = tip_width/4; // inset from superview rect. also half the height of the tip
    
    UIView *container = [[UIView alloc] initWithFrame: CGRectMake(inset, inset, rect.size.width - inset*2, rect.size.height - inset*2)];
    container.backgroundColor = [UIColor whiteColor];
    container.layer.borderColor = [UIColor blackColor].CGColor;
    container.layer.borderWidth = liquid_inset/2;
    container.layer.cornerRadius = MIN(rect.size.height, rect.size.width)/7; // proportional to height
    
    [self addSubview:container];
    
    //set dimensions for battery acid (liquid) inside
    CGFloat liquid_height;
    CGFloat max_height = container.frame.size.height - 2*liquid_inset; // max height of liquid inside
    if (self.batteryLevel >= 0.0 && self.batteryLevel <= 1.0) {
        liquid_height = (max_height)*self.batteryLevel;
    }
    else {
        liquid_height = (max_height);
    } // batteryLevel should be a fraction between 0 and 1
    
    UIView *liquid = [[UIView alloc] initWithFrame:CGRectMake(liquid_inset, liquid_inset + max_height - liquid_height, container.frame.size.width - 2*liquid_inset, liquid_height)]; // inset from superview
    
    if (self.batteryLevel < 0.20) {
        liquid.backgroundColor = [UIColor redColor]; // almost empty
    } else {
        liquid.backgroundColor = [UIColor blackColor];
    }
    liquid.layer.cornerRadius = MIN(liquid.frame.size.height, liquid.frame.size.width)/7; // was just set to container radius
    [container addSubview:liquid];
    
    UIView *tip = [[UIView alloc] initWithFrame:CGRectMake(self.frame.size.width/2 - tip_width/2, 0.0, tip_width, inset*2)]; // middle of frame minus width of tip, a tiny bit offset from the top, 2 times inset of battery
    tip.backgroundColor = [UIColor blackColor];
    tip.layer.cornerRadius = tip_width/2;
    
    [self insertSubview:tip belowSubview:container];
}

@end
