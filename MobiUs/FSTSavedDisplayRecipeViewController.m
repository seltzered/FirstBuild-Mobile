//
//  FSTSavedDisplayRecipeViewController.m
//  FirstBuild
//
//  Created by John Nolan on 9/2/15.
//  Copyright (c) 2015 FirstBuild. All rights reserved.
//

#import "FSTSavedDisplayRecipeViewController.h"
#import "FSTReadyToReachTemperatureViewController.h"
#import "FSTStageSettingsViewController.h"
#import "FSTSavedRecipeTabBarController.h"

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
} // is_multi_stage does not pass

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
    [super tabBarController:tabBarController didSelectViewController:viewController];
    viewController.view.userInteractionEnabled = NO;
}
- (IBAction)cookButtonTapped:(id)sender {
    [self performSegueWithIdentifier:@"startSegue" sender:self];
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"startSegue"]) {
        ((FSTReadyToReachTemperatureViewController*)segue.destinationViewController).currentParagon = self.currentParagon;
        //TODO: setup cooking with the recipe some how
        self.currentParagon.session.toBeRecipe = self.activeRecipe; // set the method?
        [self.currentParagon startHeatingWithStage:self.currentParagon.session.toBeRecipe.paragonCookingStages[0]];
        // where should I start heating?
    } else if ([segue.identifier isEqualToString:@"stageSettingsSegue"]) {
        ((FSTStageSettingsViewController*)segue.destinationViewController).activeStage = (FSTParagonCookingStage*)sender;
        // we probably
    } else if ([segue.identifier isEqualToString:@"tabBarSegue"]) {
        ((FSTSavedRecipeTabBarController*)segue.destinationViewController).is_multi_stage = self.is_multi_stage;
    }
} // TODO: set this up in storyboard


@end
