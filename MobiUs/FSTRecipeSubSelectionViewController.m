//
//  FSTRecipeSubSelectionViewController.m
//  FirstBuild
//
//  Created by Myles Caley on 5/12/15.
//  Copyright (c) 2015 FirstBuild. All rights reserved.
//

#import "FSTRecipeSubSelectionViewController.h"
#import "FSTRecipes.h"
#import "FSTSousVideRecipes.h"
#import "FSTBeefSousVideRecipe.h"
#import "FSTBeefSettingsViewController.h"
#import "MobiNavigationController.h"
#import "FSTCustomCookSettingsViewController.h"
#import "FSTRevealViewController.h"
#import "FSTSavedRecipeViewController.h"
#import "FSTCandyRecipe.h"
#import "FSTCandyRecipes.h"


@interface FSTRecipeSubSelectionViewController ()

@end

@implementation FSTRecipeSubSelectionViewController

NSString* headerText;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ([self.childViewControllers[0] isKindOfClass:[FSTRecipeTableViewController class]])
    {
        ((FSTRecipeTableViewController*) self.childViewControllers[0]).delegate = self;
    }
    headerText = [self.currentParagon.toBeRecipe.name uppercaseString]; // grabs the current cooking method (sous vide most likely) upon loading

}

- (void)dealloc
{
    DLog(@"dealloc");
}

-(void)viewWillAppear:(BOOL)animated {
    
    MobiNavigationController* controller = (MobiNavigationController*)self.navigationController;
    [controller setHeaderText:headerText withFrameRect:CGRectMake(0, 0, 120, 30)];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (FSTRecipes*) dataRequestedFromChild
{
    if ([self.currentParagon.toBeRecipe isKindOfClass:[FSTSousVideRecipe class]])
    {
        return (FSTRecipes*)[[FSTSousVideRecipes alloc]init];
    }
    else if ([self.currentParagon.toBeRecipe isKindOfClass:[FSTCandyRecipe class]])
    {
        return (FSTRecipes*)[[FSTCandyRecipes alloc]init];
    }
    return nil;
}

- (void) recipeSelected:(FSTRecipe *)cookingMethod
{
    if ([cookingMethod isKindOfClass:[FSTBeefSousVideRecipe class]])
    {
        [self performSegueWithIdentifier:@"segueBeefSettings" sender:cookingMethod];
    }
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    //if we are going to anything other than the custom settings view controller
    //then we need to set the cooking method. the custom settings will initialize the cooking method on its own
    if ([sender isKindOfClass:[FSTRecipe class]])
    {
        self.currentParagon.toBeRecipe = (FSTRecipe*)sender;
        [self.currentParagon.toBeRecipe createCookingSession];
        [self.currentParagon.toBeRecipe addStageToCookingSession];
    }
    
    if (
        [segue.destinationViewController isKindOfClass:[FSTCookSettingsViewController class]] ||
        [segue.destinationViewController isKindOfClass:[FSTSavedRecipeViewController class]]
        )
    {
        ((FSTCookSettingsViewController*)segue.destinationViewController).currentParagon = self.currentParagon;
    }
}

- (IBAction)recipeTap:(id)sender {
    [self performSegueWithIdentifier:@"recipesSegue" sender:nil];
}

- (IBAction)customTap:(id)sender {
    [self performSegueWithIdentifier:@"customSegue" sender:nil];
}
- (IBAction)menuToggleTapped:(id)sender {
    [self.revealViewController rightRevealToggle:self.currentParagon]; // the other says product, which is inconsistent
}

@end
