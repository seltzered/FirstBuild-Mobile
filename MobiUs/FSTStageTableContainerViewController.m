//
//  FSTStageTableContainerViewController.m
//  FirstBuild
//
//  Created by John Nolan on 8/27/15.
//  Copyright (c) 2015 FirstBuild. All rights reserved.
//

#import "FSTStageTableContainerViewController.h"
#import "FSTSavedRecipeUnderLineView.h"

@interface FSTStageTableContainerViewController ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *underLineSpacing;

@property (weak, nonatomic) IBOutlet FSTSavedRecipeUnderLineView *underLineView;

@end

@implementation FSTStageTableContainerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    self.underLineSpacing.constant = self.tabBarController.tabBar.frame.size.height;
    [self.underLineView setHorizontalPosition:5*self.view.frame.size.width/6];
} // this table container basically just holds the underline view in its proper place.

//TODO: the edit view controller will now have to access the child's delegate

@end
