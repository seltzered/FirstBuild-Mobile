//
//  FSTSavedRecipeViewController.m
//  FirstBuild
//
//  Created by John Nolan on 8/17/15.
//  Copyright (c) 2015 FirstBuild. All rights reserved.
//

#import "FSTSavedRecipeViewController.h"
#import "FSTSavedRecipeManager.h"
#import "FSTSavedEditRecipeViewController.h"
#import "FSTSousVideRecipe.h"
#import "FSTMultiStageRecipe.h"
#import "FSTReadyToReachTemperatureViewController.h"

@interface FSTSavedRecipeViewController ()

@property (weak, nonatomic) IBOutlet UIView *emptyTableView;

@end

@implementation FSTSavedRecipeViewController

FSTSavedRecipeManager* recipeManager;
// perhaps we need some delegate methods so the table can decide when this is empty

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    recipeManager = [FSTSavedRecipeManager sharedInstance];
}

- (void)viewWillAppear:(BOOL)animated {
    if ([[recipeManager getSavedRecipes] allKeys].count <= 0) {
        self.emptyTableView.hidden = false;
    } else {
        self.emptyTableView.hidden = true;
    }
    ((FSTSavedRecipeTableViewController*)self.childViewControllers[0]).delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)addRecipeTapped:(id)sender {
    [self performSegueWithIdentifier:@"addRecipeSegue" sender:self];
}

-(void)didDeleteRecipe {
    if ([[recipeManager getSavedRecipes] allKeys].count <= 0) {
        self.emptyTableView.hidden = false;
    }
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.destinationViewController isKindOfClass:[FSTSavedEditRecipeViewController class]]) {
        if ([sender isKindOfClass:[FSTRecipe class]]) {
            ((FSTSavedEditRecipeViewController*)segue.destinationViewController).activeRecipe = (FSTRecipe*)sender;
            if ([sender isKindOfClass:[FSTSousVideRecipe class]]) {
                ((FSTSavedEditRecipeViewController*)segue.destinationViewController).is_multi_stage = [NSNumber numberWithBool:NO];
            } else if ([sender isKindOfClass:[FSTMultiStageRecipe class]]) {
                ((FSTSavedEditRecipeViewController*)segue.destinationViewController).is_multi_stage = [NSNumber numberWithBool:YES]; // decide which views to load in the tab bar
            }
        }
    } else if ([segue.destinationViewController isKindOfClass:[FSTReadyToReachTemperatureViewController class]]) {
        ((FSTReadyToReachTemperatureViewController*)segue.destinationViewController).currentParagon = self.currentParagon;
    } // it does not really need to pass anything to the addRecipe table
}

#pragma mark - table delegate

-(void)segueWithRecipe:(FSTRecipe *)recipe {
    [self performSegueWithIdentifier:@"editRecipesSegue" sender:recipe];
}

-(void)startCookingWithRecipe:(FSTRecipe *)recipe {
    self.currentParagon.session.toBeRecipe = recipe; // set the method?
    [self.currentParagon startHeatingWithStage:self.currentParagon.session.toBeRecipe.paragonCookingStages[0]];
    [self performSegueWithIdentifier:@"cookingSegue" sender:self];
}


@end
