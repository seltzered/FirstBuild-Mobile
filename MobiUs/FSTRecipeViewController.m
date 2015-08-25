//
//  FSTRecipeViewController.m
//  FirstBuild
//
//  Created by Myles Caley on 5/12/15.
//  Copyright (c) 2015 FirstBuild. All rights reserved.
//

#import "FSTRecipeViewController.h"
#import "FSTCustomCookSettingsViewController.h"
#import "FSTBeefSousVideRecipe.h"
#import "FSTRecipes.h"
#import "FSTRecipeSubSelectionViewController.h"
#import "MobiNavigationController.h"
#import "FSTRevealViewController.h"
#import "FSTSavedRecipeViewController.h"

@interface FSTRecipeViewController ()

@end

@implementation FSTRecipeViewController

FSTRecipes* _methods;

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    _methods = [[FSTRecipes alloc]init];
    if ([self.childViewControllers[0] isKindOfClass:[FSTRecipeTableViewController class]])
    {
        ((FSTRecipeTableViewController*) self.childViewControllers[0]).delegate = self;
    }
}

- (void)dealloc
{
    //we no longer have a valid cooking method
    self.product.session.toBeRecipe = nil;
    DLog(@"dealloc");
}

-(void)viewWillAppear:(BOOL)animated {
    
    MobiNavigationController* navigation = (MobiNavigationController*)self.navigationController;
    [navigation setHeaderImageNamed:@"Paragon_Logo_Red" withFrameRect:CGRectMake(0, 0, 120, 30)];
    [navigation.navigationBar setBarTintColor:[UIColor blackColor]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
   
    //if we actually have a product chosen for the segue then initialize the cooking method
    if ([sender isKindOfClass:[FSTRecipe class]])
    {
        self.product.session.toBeRecipe = (FSTRecipe*)sender;
    }
    
    //if we are segueing to stored recipes, new custom cook mode or a sub selection then
    //we need to set the paragon
    if  (
            [segue.destinationViewController isKindOfClass:[FSTCookSettingsViewController class]] ||
            [segue.destinationViewController isKindOfClass:[FSTRecipeSubSelectionViewController class]] ||
            [segue.destinationViewController isKindOfClass:[FSTSavedRecipeViewController class]]

        )
    {
        ((FSTCookSettingsViewController*)segue.destinationViewController).currentParagon = self.product;
    }

}

- (FSTRecipes*) dataRequestedFromChild
{
    return _methods;
}

- (void) recipeSelected:(FSTRecipe *)recipe
{
    [self performSegueWithIdentifier:@"segueSubCookingMethod" sender:recipe];
}

- (IBAction)recipeTap:(id)sender {
    [self performSegueWithIdentifier:@"recipesSegue" sender:nil];
}

- (IBAction)customTap:(id)sender {
    [self performSegueWithIdentifier:@"segueCustom" sender:nil];

}
- (IBAction)menuToggleTapped:(id)sender {
    [self.revealViewController rightRevealToggle:self.product];
}


@end
