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
#import "FSTSavedDisplayRecipeViewController.h"

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
    self.currentParagon.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated {
    if ([[recipeManager getSavedRecipes] allKeys].count <= 0) {
        self.emptyTableView.hidden = NO;
    } else {
        self.emptyTableView.hidden = YES;
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
        self.emptyTableView.alpha = 0;
        self.emptyTableView.hidden = NO;
        [UIView animateWithDuration:0.5 animations:^{
            // same animation as the product table
            self.emptyTableView.alpha = 1;
        }];
    }
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.destinationViewController isKindOfClass:[FSTSavedEditRecipeViewController class]]) {
        // this applies to the display view controller as well
        if ([sender isKindOfClass:[FSTRecipe class]]) {
            ((FSTSavedEditRecipeViewController*)segue.destinationViewController).activeRecipe = (FSTRecipe*)sender;
            ((FSTSavedEditRecipeViewController*)segue.destinationViewController).currentParagon = self.currentParagon;
            if ([sender isKindOfClass:[FSTSousVideRecipe class]]) {
                ((FSTSavedEditRecipeViewController*)segue.destinationViewController).is_multi_stage = [NSNumber numberWithBool:NO];
            } else if ([sender isKindOfClass:[FSTMultiStageRecipe class]]) {
                ((FSTSavedEditRecipeViewController*)segue.destinationViewController).is_multi_stage = [NSNumber numberWithBool:YES]; // decide which views to load in the tab bar
            }
        }
    }  // it does not really need to pass anything to the addRecipe table
}

#pragma mark - table delegate

-(void)segueWithRecipe:(FSTRecipe *)recipe {
    [self performSegueWithIdentifier:@"editRecipesSegue" sender:recipe];
}

-(void)displayWithRecipe:(FSTRecipe *)recipe {
    [self performSegueWithIdentifier:@"displaySegue" sender:recipe];
}


@end
