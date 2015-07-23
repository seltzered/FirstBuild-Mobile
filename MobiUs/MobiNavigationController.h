//
//  MobiNavigationController.h
//  MobiUs
//
//  Created by David Calvert on 10/6/14.
//  Copyright (c) 2014 FirstBuild. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MobiNavigationController : UINavigationController
@property (nonatomic,strong)UIView *logoView;
@property (nonatomic,strong)UILabel *logoLabel;
- (void)setHeaderImageNamed: (NSString*)imageName withFrameRect: (CGRect)frame;
- (void)setHeaderText:(NSString*)text withFrameRect: (CGRect)frame;
@end
