//
//  FSTSavedDisplayRecipeViewController.m
//  FirstBuild
//
//  Created by John Nolan on 9/2/15.
//  Copyright (c) 2015 FirstBuild. All rights reserved.
//

#import "FSTSavedDisplayRecipeViewController.h"

@interface FSTSavedDisplayRecipeViewController ()

@end

@implementation FSTSavedDisplayRecipeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.imageHolder.userInteractionEnabled = NO;
    self.nameField.userInteractionEnabled = NO;
    self.nameField.backgroundColor = [UIColor whiteColor];
    self.smallCamera.hidden = YES; // will never show up in this view
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
    [super tabBarController:tabBarController didSelectViewController:viewController];
    viewController.view.userInteractionEnabled = NO;
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
