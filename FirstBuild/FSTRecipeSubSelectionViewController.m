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
#import "MobiNavigationController.h"
#import "RecipeMaster.h"
#import "FSTBeefSettingsViewController.h"
#import "FSTCustomCookSettingsViewController.h"
#import "FSTRevealViewController.h"
#import "FSTAutoCookViewController.h"
#import "FSTSavedRecipeViewController.h"

@interface FSTRecipeSubSelectionViewController ()

@end

@implementation FSTRecipeSubSelectionViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    if (self.childViewControllers.count > 0 && [self.childViewControllers[0] isKindOfClass:[FSTRecipeTableViewController class]])
    {
        ((FSTRecipeTableViewController*) self.childViewControllers[0]).delegate = self;
    }
    
    [self updateHeader];
}

-(void)updateHeader
{
    MobiNavigationController* navigation = (MobiNavigationController*)self.navigationController;
    if (self.recipe)
    {
        NSString* headerText = [self.recipe.name uppercaseString];
        [navigation setHeaderText:headerText withFrameRect:CGRectMake(0, 0, 120, 30)];
    }
    else
    {
        //NSString* headerText = [self.recipe.name uppercaseString];
        [navigation setHeaderText:@"SOUS VIDE" withFrameRect:CGRectMake(0, 0, 120, 30)];
//        [navigation setHeaderImageNamed:@"Paragon_Logo_Red" withFrameRect:CGRectMake(0, 0, 120, 30)];
//        [navigation.navigationBar setBarTintColor:[UIColor blackColor]];
    }
}

- (void)dealloc
{
    DLog(@"dealloc");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (FSTRecipes*) dataRequestedFromChild
{
    [self updateHeader];
    
    //beef steak
    if ([self.recipe isKindOfClass:[FSTBeefSteakSousVideRecipe class]])
    {
        return (FSTRecipes*)[[FSTBeefSousVideSteakRecipes alloc]init];
    }
    //beef roast
    else if ([self.recipe isKindOfClass:[FSTBeefRoastSousVideRecipe class]])
    {
        return (FSTRecipes*)[[FSTBeefSousVideRoastRecipes alloc]init];
    }
    //duck
    else if ([self.recipe isKindOfClass:[FSTPoultryDuckSousVideRecipe class]])
    {
        return (FSTRecipes*)[[FSTPoultryDuckSousVideRecipes alloc]init];
    }
    //turkey
    else if ([self.recipe isKindOfClass:[FSTPoultryTurkeySousVideRecipe class]])
    {
        return (FSTRecipes*)[[FSTPoultryTurkeySousVideRecipes alloc]init];
    }
    //chicken
    else if ([self.recipe isKindOfClass:[FSTPoultryChickenSousVideRecipe class]])
    {
        return (FSTRecipes*)[[FSTPoultryChickenSousVideRecipes alloc]init];
    }
    //pork
    else if ([self.recipe isKindOfClass:[FSTPorkSousVideRecipe class]])
    {
        return (FSTRecipes*)[[FSTPorkSousVideRecipes alloc]init];
    }
    //beef
    else if ([self.recipe isKindOfClass:[FSTBeefSousVideRecipe class]])
    {
        return (FSTRecipes*)[[FSTBeefSousVideRecipes alloc]init];
    }
    //vegetable
    else if ([self.recipe isKindOfClass:[FSTVegetableRecipe class]])
    {
        return (FSTRecipes*)[[FSTVegetableRecipes alloc]init];
    }
    //fruit
    else if ([self.recipe isKindOfClass:[FSTFruitSousVideRecipe class]])
    {
        return (FSTRecipes*)[[FSTFruitSousVideRecipes alloc]init];
    }
    //fish
    else if ([self.recipe isKindOfClass:[FSTFishSousVideRecipe class]])
    {
        return (FSTRecipes*)[[FSTFishSousVideRecipes alloc]init];
    }
    //egg
    else if ([self.recipe isKindOfClass:[FSTEggRecipe class]])
    {
        return (FSTRecipes*)[[FSTEggRecipes alloc]init];
    }
    //poultry
    else if ([self.recipe isKindOfClass:[FSTPoultrySousVideRecipe class]])
    {
        return (FSTRecipes*)[[FSTPoultrySousVideRecipes alloc]init];
    }
    //sousvide
    else
    {
        return [[FSTSousVideRecipes alloc]init];
    }
    
    return nil;
}

- (void) recipeSelected:(FSTRecipe *)cookingMethod
{
    //TODO: clean this up -- consider integrating the view controller as a property on the model objects
    
    // here check if an actual complete recipe was selected, if it is
    // go to the correct settings, if not
    // then just segue to another instance of this sub selection class
    if ([cookingMethod isKindOfClass:[FSTBeefSteakTenderSousVideRecipe class]]||
        [cookingMethod isKindOfClass:[FSTBeefSteakNormalSousVideRecipe class]]||
        [cookingMethod isKindOfClass:[FSTBeefSteakToughSousVideRecipe class]]||
        [cookingMethod isKindOfClass:[FSTBeefRoastRibEyeSousVideRecipe class]]||
        [cookingMethod isKindOfClass:[FSTBeefRoastBrisketSousVideRecipe class]]||
        [cookingMethod isKindOfClass:[FSTBeefRoastChuckRoastSousVideRecipe class]]||
        [cookingMethod isKindOfClass:[FSTBeefRoastShortRibsSousVideRecipe class]]||
        [cookingMethod isKindOfClass:[FSTBeefRoastGroundBeefSousVideRecipe class]]||
        [cookingMethod isKindOfClass:[FSTBeefRoastTenderLoinSousVideRecipe class]]||
        [cookingMethod isKindOfClass:[FSTPoultryDuckBreastSousVideRecipe class]]||
        [cookingMethod isKindOfClass:[FSTPoultryTurkeyBoneInSousVideRecipe class]]||
        [cookingMethod isKindOfClass:[FSTPoultryTurkeyBonelessSousVideRecipe class]]||
        [cookingMethod isKindOfClass:[FSTPoultryChickenBoneInSousVideRecipe class]]||
        [cookingMethod isKindOfClass:[FSTPoultryChickenBonelessSousVideRecipe class]]||
        [cookingMethod isKindOfClass:[FSTPorkChopsSousVideRecipe class]]||
        [cookingMethod isKindOfClass:[FSTPorkShoulderSousVideRecipe class]]||
        [cookingMethod isKindOfClass:[FSTFishFilletSousVideRecipe class]]||
        [cookingMethod isKindOfClass:[FSTFishSteakSousVideRecipe class]]
        )
    {
        [self performSegueWithIdentifier:@"segueBeefSettings" sender:cookingMethod];
    }
    else if([cookingMethod isKindOfClass:[FSTVegetableAsparagusSousVideRecipe class]]||
            [cookingMethod isKindOfClass:[FSTVegetableArtichokeSousVideRecipe class]]||
            [cookingMethod isKindOfClass:[FSTVegetableBeetsSousVideRecipe class]]||
            [cookingMethod isKindOfClass:[FSTVegetableBrusselSproutsSousVideRecipe class]]||
            [cookingMethod isKindOfClass:[FSTVegetableBroccoliSousVideRecipe class]]||
            [cookingMethod isKindOfClass:[FSTVegetableCarrotsSousVideRecipe class]]||
            [cookingMethod isKindOfClass:[FSTVegetableCornSousVideRecipe class]]||
            [cookingMethod isKindOfClass:[FSTVegetableFennelSousVideRecipe class]]||
            [cookingMethod isKindOfClass:[FSTVegetableGreenBeansSousVideRecipe class]]||
            [cookingMethod isKindOfClass:[FSTVegetablePotatoesSousVideRecipe class]]||
            [cookingMethod isKindOfClass:[FSTVegetableSweetPotatoesSousVideRecipe class]]||
            [cookingMethod isKindOfClass:[FSTEggScrambledSousVideRecipe class]]||
            [cookingMethod isKindOfClass:[FSTPoultryDuckLegsSousVideRecipe class]]||
            [cookingMethod isKindOfClass:[FSTPoultryTurkeyLegsSousVideRecipe class]]||
            [cookingMethod isKindOfClass:[FSTPoultryChickenLegsSousVideRecipe class]]||
            [cookingMethod isKindOfClass:[FSTPoultryTurkeyLegsSousVideRecipe class]]||
            [cookingMethod isKindOfClass:[FSTFruitApplesSousVideRecipe class]]||
            [cookingMethod isKindOfClass:[FSTFruitApricotsSousVideRecipe class]]||
            [cookingMethod isKindOfClass:[FSTFruitBerriesSousVideRecipe class]]||
            [cookingMethod isKindOfClass:[FSTFruitCherriesSousVideRecipe class]]||
            [cookingMethod isKindOfClass:[FSTFruitMangosSousVideRecipe class]]||
            [cookingMethod isKindOfClass:[FSTFruitNectarinesSousVideRecipe class]]||
            [cookingMethod isKindOfClass:[FSTFruitPapayaSousVideRecipe class]]||
            [cookingMethod isKindOfClass:[FSTFruitPeachesSousVideRecipe class]]||
            [cookingMethod isKindOfClass:[FSTFruitPearsSousVideRecipe class]]||
            [cookingMethod isKindOfClass:[FSTFruitPlumsSousVideRecipe class]]||
            [cookingMethod isKindOfClass:[FSTPorkSpareRibsSousVideRecipe class]]||
            [cookingMethod isKindOfClass:[FSTPorkBackRibsSousVideRecipe class]]||
            [cookingMethod isKindOfClass:[FSTPorkTenderloinSousVideRecipe class]]
            )
    {
        [self performSegueWithIdentifier:@"segueAutoCook" sender:cookingMethod];
    }
    else if([cookingMethod isKindOfClass:[FSTEggWholeSousVideRecipe class]])
    {
        [self performSegueWithIdentifier:@"segueEgg" sender:cookingMethod];
    }
    else
    {
        FSTRecipeSubSelectionViewController* subSelectionViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"FSTRecipeSubSelectionViewController"];

        subSelectionViewController.currentParagon = self.currentParagon;
        subSelectionViewController.recipe = cookingMethod;
        [self.navigationController pushViewController:subSelectionViewController animated:YES];
        //[self performSegueWithIdentifier:@"segueSubCookingMethod" sender:cookingMethod];
    }
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.destinationViewController isKindOfClass:[FSTRecipeSubSelectionViewController class]])
    {
        ((FSTRecipeSubSelectionViewController*)segue.destinationViewController).currentParagon = self.currentParagon;
        ((FSTRecipeSubSelectionViewController*)segue.destinationViewController).recipe = (FSTRecipe*)sender;
    }
    else if ([segue.destinationViewController isKindOfClass:[FSTCustomCookSettingsViewController class]])
    {
        //the actual recipe for a custom cook settings view is initialized in the view itself
        //just tell it which paragon this should go to
        ((FSTCookSettingsViewController*)segue.destinationViewController).currentParagon = self.currentParagon;
    }
    else if ([segue.destinationViewController isKindOfClass:[FSTCookSettingsViewController class]])
    {
        //if its not a custom cook view controller then its some other type of cook settings view controller
        //so we need to set the to be recipe to whatever they just selected, which is the sender
        //(see recipeSelected)
        ((FSTCookSettingsViewController*)segue.destinationViewController).recipe =(FSTRecipe*)sender;
        ((FSTCookSettingsViewController*)segue.destinationViewController).currentParagon = self.currentParagon;
    }
    else if([segue.destinationViewController isKindOfClass:[FSTSavedRecipeViewController class]])
    {
        ((FSTSavedRecipeViewController*)segue.destinationViewController).currentParagon = self.currentParagon;
    }
}

- (IBAction)recipeTap:(id)sender
{
    [self performSegueWithIdentifier:@"recipesSegue" sender:nil];
}

- (IBAction)customTap:(id)sender {
    [self performSegueWithIdentifier:@"segueCustom" sender:nil];
}

- (IBAction)menuToggleTapped:(id)sender
{
    [self.revealViewController rightRevealToggle:self.currentParagon]; // the other says product, which is inconsistent
}

@end
