//
//  FSTSavedMultiStageRecipeTabBarController.m
//  FirstBuild
//
//  Created by John Nolan on 8/27/15.
//  Copyright (c) 2015 FirstBuild. All rights reserved.
//

#import "FSTSavedMultiStageRecipeTabBarController.h"
#import "FSTSavedRecipeIngredientsViewController.h"
#import "FSTSavedRecipeInstructionsViewController.h"
#import "FSTStageTableViewController.h"


@interface FSTSavedMultiStageRecipeTabBarController ()

@end

@implementation FSTSavedMultiStageRecipeTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    FSTSavedRecipeIngredientsViewController* ingredientsVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ingredientsTab"];
    FSTSavedRecipeInstructionsViewController* instructionsVC = [self.storyboard instantiateViewControllerWithIdentifier:@"instructionsTab"];
    FSTStageTableViewController* stageVC = [self.storyboard instantiateViewControllerWithIdentifier:@"stageTab"];
    self.viewControllers = [NSArray arrayWithObjects:ingredientsVC, instructionsVC, stageVC, nil];
}

- (void)viewWillLayoutSubviews {
    self.tabBar.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, 45); // not sure yet what the size should be yet, but this should place the tab bar at the top
}

- (void)viewWillAppear:(BOOL)animated {
    
    //self.tabBar.barTintColor = [UIColor orangeColor]; // need that firstbuild orange
    //self.tabBar.barStyle = UIBarStyleDefault;
    self.tabBar.tintColor = [UIColor orangeColor];
    self.tabBar.backgroundColor = [UIColor whiteColor];
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
