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
#import "FSTStageSettingsViewController.h"
#import "FSTStageTableContainerViewController.h"

@interface FSTSavedDisplayRecipeViewController ()

@property UITabBarController* childTabController;

@end

@implementation FSTSavedDisplayRecipeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //kind of a hack, but if the paragon doesn't have a delegate already then we are
    //waiting for them to press the COOK button which indicates there is not already
    //an active recipe. when they press COOK that will trigger the cook config to write
    //and alert us via delegate. if paragon already has a delegate then we know
    //are display only and don't need to respond to activities from the paragon
    if (!self.currentParagon.delegate)
    {
       self.currentParagon.delegate = self;
    }    
}

- (void)dealloc
{
    DLog(@"dealloc");
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.imageHolder.userInteractionEnabled = NO;
    self.nameField.userInteractionEnabled = NO;
    self.nameField.backgroundColor = [UIColor whiteColor];
    self.smallCamera.hidden = YES; // will never show up in this view
    if ([self.will_hide_cook boolValue]) {
        self.cookButton.hidden = true;
    }
    ((UIViewController*)self.childTabController.viewControllers[0]).view.userInteractionEnabled = NO; // do not yet users press the first view that loads // there are some layout issues as well, how to fix that?
} // is_multi_stage does not pass

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
    [super tabBarController:tabBarController didSelectViewController:viewController];
    if ([viewController isKindOfClass:[FSTStageTableContainerViewController class]]) {
        viewController.view.userInteractionEnabled = YES;
        // users can still select members of the table
    } else {
        viewController.view.userInteractionEnabled = NO;
    }
}
- (IBAction)cookButtonTapped:(id)sender {
    
    self.cookButtonGestureRecognizer.enabled = NO;
    
    //once the temperature is confirmed to be set then it will segue because it is
    //waiting on the cookConfigurationSet delegate. we check the return status because
    //the user may not have the correct cook mode
    if (![self.currentParagon sendRecipeToCooktop:self.activeRecipe])
    {
        self.cookButtonGestureRecognizer.enabled = YES;
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Oops!"
                                                                                 message:@"The cooktop must be in the Rapid or Gentle cooking mode."
                                                                          preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *actionOk = [UIAlertAction actionWithTitle:@"OK"
                                                           style:UIAlertActionStyleDefault
                                                         handler:nil];
        [alertController addAction:actionOk];
        [self presentViewController:alertController animated:YES completion:nil];
    }
}

// delegate method
- (BOOL)canEditStages {
    return NO;
    // the user cannot edit anything here
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"startSegue"]) {
        ((FSTReadyToReachTemperatureViewController*)segue.destinationViewController).currentParagon = self.currentParagon;
    } else if ([segue.identifier isEqualToString:@"stageSettingsSegue"]) {
        ((FSTStageSettingsViewController*)segue.destinationViewController).activeStage = (FSTParagonCookingStage*)sender;
        ((FSTStageSettingsViewController*)segue.destinationViewController).can_edit = [NSNumber numberWithBool:NO];
    } else if ([segue.identifier isEqualToString:@"tabBarSegue"]) {
        ((FSTSavedRecipeTabBarController*)segue.destinationViewController).is_multi_stage = self.is_multi_stage;
        self.childTabController = (FSTSavedRecipeTabBarController*)segue.destinationViewController;
    }
} // TODO: set this up in storyboard

#pragma mark - <FSTParagonDelegate>
- (void)cookConfigurationSet:(NSError *)error
{
    if (error)
    {
        //TODO: the recipe could also be invalid
        self.cookButtonGestureRecognizer.enabled = YES;
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Oops!"
                                                                                 message:@"The cooktop must not currently be cooking. Try pressing the Stop button and changing to the Rapid or Gentle Precise cooking mode."
                                                                          preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *actionOk = [UIAlertAction actionWithTitle:@"OK"
                                                           style:UIAlertActionStyleDefault
                                                         handler:nil];
        [alertController addAction:actionOk];
        [self presentViewController:alertController animated:YES completion:nil];
        return;
    }
    
    [self performSegueWithIdentifier:@"startSegue" sender:self];
}


@end
