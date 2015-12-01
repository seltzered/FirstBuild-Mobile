//
//  FSTSavedRecipeTabBarController.m
//  FirstBuild
//
//  Created by John Nolan on 8/24/15.
//  Copyright (c) 2015 FirstBuild. All rights reserved.
//

#import "FSTSavedRecipeTabBarController.h"
#import "FSTSavedEditRecipeViewController.h"
#import "FSTSavedRecipeIngredientsViewController.h"
#import "FSTSavedRecipeInstructionsViewController.h"
#import "FSTSavedRecipeSettingsViewController.h"
#import "FSTStageTableContainerViewController.h"

@interface FSTSavedRecipeTabBarController ()

@end

@implementation FSTSavedRecipeTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    FSTSavedRecipeIngredientsViewController* ingredientsVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ingredientsTab"];
    FSTSavedRecipeInstructionsViewController* instructionsVC = [self.storyboard instantiateViewControllerWithIdentifier:@"instructionsTab"];
    FSTSavedRecipeSettingsViewController* settingsVC = [self.storyboard instantiateViewControllerWithIdentifier:@"settingsTab"];
    FSTStageTableContainerViewController* stageVC = [self.storyboard instantiateViewControllerWithIdentifier:@"stageContainer"];
    
    if ([self.is_multi_stage boolValue]) {
        self.viewControllers = [NSArray arrayWithObjects:ingredientsVC, instructionsVC, stageVC, nil];
    } else {
        self.viewControllers = [NSArray arrayWithObjects:ingredientsVC, instructionsVC, settingsVC, nil];
    }
    
}

- (void)viewWillLayoutSubviews
{
    self.tabBar.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, 45); // not sure yet what the size should be yet, but this should place the tab bar at the top
}

- (void)viewWillAppear:(BOOL)animated
{

    self.tabBar.tintColor = UIColorFromRGB(0xEA461A);
    self.tabBar.backgroundColor = [UIColor whiteColor];
    self.tabBar.shadowImage =[[UIImage alloc] init];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

// delegate method

@end
