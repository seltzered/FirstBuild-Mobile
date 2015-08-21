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
#import "FSTReadyToPreheatViewController.h"

@interface FSTRecipeViewController ()

@property (weak, nonatomic) IBOutlet UIView *emptyTableView;

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
        self.emptyTableView.hidden = false;
    } else {
        self.emptyTableView.hidden = true;
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

-(void)didDeleteRecipe {
    if ([[recipeManager getSavedRecipes] allKeys].count <= 0) {
        self.emptyTableView.hidden = false;
    }
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.destinationViewController isKindOfClass:[FSTEditRecipeViewController class]]) {
        if ([sender isKindOfClass:[FSTRecipe class]]) {
            ((FSTEditRecipeViewController*)segue.destinationViewController).activeRecipe = (FSTRecipe*)sender;
        }
    } else if ([segue.destinationViewController isKindOfClass:[FSTReadyToPreheatViewController class]]) {
        ((FSTReadyToPreheatViewController*)segue.destinationViewController).currentParagon = self.currentParagon;
    }
    
}

#pragma mark - table delegate

-(void)segueWithRecipe:(FSTRecipe *)recipe {
    [self performSegueWithIdentifier:@"editRecipesSegue" sender:recipe];
}

-(void)startCookingWithSession:(FSTParagonCookingSession *)session {
    self.currentParagon.toBeCookingMethod.session = session; // set the method?
    [self.currentParagon startHeatingWithStage:self.currentParagon.toBeCookingMethod.session.paragonCookingStages[0]];
    [self performSegueWithIdentifier:@"cookingSegue" sender:self];
}


@end
