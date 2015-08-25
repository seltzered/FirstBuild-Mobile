//
//  FSTSavedRecipeSettingsViewController.m
//  FirstBuild
//
//  Created by John Nolan on 8/24/15.
//  Copyright (c) 2015 FirstBuild. All rights reserved.
//

#import "FSTSavedRecipeSettingsViewController.h"
#import "FSTSavedRecipeUnderLineView.h"

@interface FSTSavedRecipeSettingsViewController ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *underLineSpacing;

@property (weak, nonatomic) IBOutlet FSTSavedRecipeUnderLineView *underLineView;

@end

@implementation FSTSavedRecipeSettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

-(void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    self.underLineSpacing.constant = self.tabBarController.tabBar.frame.size.height;
    [self.underLineView setHorizontalPosition:5*self.view.frame.size.width/6];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
