//
//  CALayer+XibConfiguration.m
//  FirstBuild
//
//  Created by Myles Caley on 5/27/15.
//  Copyright (c) 2015 FirstBuild. All rights reserved.
//

//http://stackoverflow.com/questions/12301256/is-it-possible-to-set-uiview-border-properties-from-interface-builder/17993890#17993890

#import "CALayer+XibConfiguration.h"

@implementation CALayer(XibConfiguration)

-(void)setBorderUIColor:(UIColor*)color
{
    self.borderColor = color.CGColor;
}

-(UIColor*)borderUIColor
{
    return [UIColor colorWithCGColor:self.borderColor];
}

@end
