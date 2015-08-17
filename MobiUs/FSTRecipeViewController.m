//
//  FSTRecipeViewController.m
//  FirstBuild
//
//  Created by John Nolan on 8/17/15.
//  Copyright (c) 2015 FirstBuild. All rights reserved.
//

#import "FSTRecipeViewController.h"
#import "FSTRecipeManager.h"
#import "FSTEditRecipeViewController.h"

@interface FSTRecipeViewController ()

@end

@implementation FSTRecipeViewController

FSTRecipeManager* recipeManager;
// perhaps we need some delegate methods so the table can decide when this is empty

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    recipeManager = [[FSTRecipeManager alloc] init];
}

- (void)viewWillAppear:(BOOL)animated {
    if ([[recipeManager getSavedRecipes] allKeys].count <= 0) {
        [self performSegueWithIdentifier:@"editRecipesSegue" sender:self]; // set the headline here
    }
    ((FSTRecipeTableViewController*)self.childViewControllers[0]).delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)addRecipeTapped:(id)sender {
    [self performSegueWithIdentifier:@"editRecipesSegue" sender:self];
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.destinationViewController isKindOfClass:[FSTEditRecipeViewController class]]) {
        ((FSTEditRecipeViewController*)segue.destinationViewController).recipeManager = recipeManager; // give it this newly initiaized recipe manager (there's probably no need for this
        if ([sender isKindOfClass:[FSTRecipe class]]) {
            ((FSTEditRecipeViewController*)segue.destinationViewController).activeRecipe = (FSTRecipe*)sender;
        }
    }
    
}

-(void)segueWithRecipe:(FSTRecipe *)recipe {
    [self performSegueWithIdentifier:@"editRecipesSegue" sender:recipe];
}


@end
