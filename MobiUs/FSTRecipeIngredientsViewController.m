//
//  FSTRecipeIngredientsViewController.m
//  FirstBuild
//
//  Created by John Nolan on 8/24/15.
//  Copyright (c) 2015 FirstBuild. All rights reserved.
//

#import "FSTRecipeIngredientsViewController.h"
#import "FSTColorImage.h"
#import "FSTRecipeUnderLineView.h"

@interface FSTRecipeIngredientsViewController ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *underLineSpacing;

@property (weak, nonatomic) IBOutlet FSTRecipeUnderLineView *underLineView;


@end

@implementation FSTRecipeIngredientsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //UIImage* selectedImage = [UIImage imageNamed:@"Paragon_Mark_Red"];//[FSTColorImage imageWithColor:[UIColor orangeColor] inRect:CGRectMake(0, 0, 30, 24)];
    //[self.tabBarItem setSelectedImage:selectedImage];
    //self.tabBarItem.imageInsets = UIEdgeInsetsMake(12, 0, -12, 0); // trying to shift the whole thing down.
    //title should be set in storyboard
}

-(void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    self.underLineSpacing.constant = self.tabBarController.tabBar.frame.size.height; // make room for the tab bar (maybe it starts under the tab bar? we shall see
    [self.underLineView setHorizontalPosition:self.view.frame.size.width/6]; // this is the first entry
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
