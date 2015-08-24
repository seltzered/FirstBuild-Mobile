//
//  FSTRecipeTabBarController.m
//  FirstBuild
//
//  Created by John Nolan on 8/24/15.
//  Copyright (c) 2015 FirstBuild. All rights reserved.
//

#import "FSTRecipeTabBarController.h"
#import "FSTRecipeIngredientsViewController.h"
#import "FSTRecipeInstructionsViewController.h"
#import "FSTRecipeSettingsViewController.h"

@interface FSTRecipeTabBarController ()

@end

@implementation FSTRecipeTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    FSTRecipeIngredientsViewController* ingredientsVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ingredientsTab"];
    FSTRecipeInstructionsViewController* instructionsVC = [self.storyboard instantiateViewControllerWithIdentifier:@"instructionsTab"];
    FSTRecipeSettingsViewController* settingsVC = [self.storyboard instantiateViewControllerWithIdentifier:@"settingsTab"];
    self.viewControllers = [NSArray arrayWithObjects:ingredientsVC, instructionsVC, settingsVC, nil];
    self.delegate = self;
    
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

}

// delegate method

@end
