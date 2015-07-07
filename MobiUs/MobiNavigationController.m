//
//  MobiNavigationController.m
//  MobiUs
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
    
    [self setHeaderImageNamed:@"logo_1b_white" withFrameRect:CGRectMake(0, 0, 44, 26)];
    
    [self.navigationBar setBarTintColor:UIColorFromRGB(0xFF2B00)];
    
}


- (void)setHeaderImageNamed: (NSString*)imageName withFrameRect: (CGRect)frame
{
    if (self.logoView)
    {
        [self.logoView removeFromSuperview];
    }
    
    self.logoView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
    [self.logoView setFrame:frame];
    CGPoint superCenter = CGPointMake(_midX, _midY);
    [self.logoView setCenter:superCenter];
    [self.navigationBar addSubview:self.logoView];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];//00B5CC)];//white over red for new skin
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    CGPoint superCenter = CGPointMake(size.width/2, self.navigationBar.frame.size.height/2);
    [self.logoView setCenter:superCenter];
}

@end
