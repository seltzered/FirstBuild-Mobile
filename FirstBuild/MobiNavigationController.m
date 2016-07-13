//
//  MobiNavigationController.m
//  FirstBuild-Mobile
//
//  Created by David Calvert on 10/6/14.
//  Copyright (c) 2014 FirstBuild. All rights reserved.
//

#import "MobiNavigationController.h"

@interface MobiNavigationController ()
@end

@implementation MobiNavigationController

CGFloat _midX = 0;
CGFloat _midY = 0;

- (void)viewDidLoad {
    [super viewDidLoad];
    _midX = CGRectGetMidX(self.navigationBar.frame);
    _midY = CGRectGetMidY(self.navigationBar.frame);
    
    [self setHeaderImageNamed:@"logo_1b_orange_no_firstbuild" withFrameRect:CGRectMake(0, 0, 44, 26)];
    
    [self.navigationBar setBarTintColor:[UIColor whiteColor]];
}

- (void)setHeaderImageNamed: (NSString*)imageName withFrameRect: (CGRect)frame
{
    if (self.logoView)
    {
        [self.logoView removeFromSuperview];
    }
    if (self.logoLabel)
    {
        [self.logoLabel removeFromSuperview];
    }
    
    self.logoView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
    [self.logoView setFrame:frame];
    CGPoint superCenter = CGPointMake(_midX, _midY);
    [self.logoView setCenter:superCenter];
    [self.navigationBar addSubview:self.logoView];
}

-(void)setHeaderText:(NSString*) text withFrameRect: (CGRect)frame
{
    if (self.logoView)
    {
        [self.logoView removeFromSuperview];
    }
    if (self.logoLabel)
    {
        [self.logoLabel removeFromSuperview];
    }
    
    UIFont *headerFont = [UIFont fontWithName:@"PTSans-NarrowBold" size:25.0];
    NSDictionary *headerFontDict = [NSDictionary dictionaryWithObject: headerFont forKey:NSFontAttributeName];
    
    
    self.logoLabel = [[UILabel alloc] initWithFrame:frame];
    self.logoLabel.attributedText = [[NSAttributedString alloc] initWithString:text attributes:headerFontDict];
    CGPoint superCenter = CGPointMake(_midX, _midY);
    [self.logoLabel setCenter:superCenter];
    self.logoLabel.textColor = UIColorFromRGB(0xF0663A);
    self.logoLabel.textAlignment = NSTextAlignmentCenter;
    [self.navigationBar addSubview:self.logoLabel];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    CGPoint superCenter = CGPointMake(size.width/2, self.navigationBar.frame.size.height/2);
    _midX = superCenter.x;
    _midY = superCenter.y;
    // update midx and midy for future reference in scene transition.
    [self.logoView setCenter:superCenter];
    [self.logoLabel setCenter:superCenter];
}

@end
