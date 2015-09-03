//
//  FSTSavedRecipeTableViewController.m
//  FirstBuild
//
//  Created by John Nolan on 8/17/15.
//  Copyright (c) 2015 FirstBuild. All rights reserved.
//

#import "FSTSavedRecipeTableViewController.h"

#import "FSTSavedRecipeTableViewCell.h"

#import "FSTSavedRecipeManager.h"

@interface FSTSavedRecipeTableViewController ()

@end

@implementation FSTSavedRecipeTableViewController

NSDictionary* storedRecipes; // set on loading

FSTSavedRecipeManager* recipeManager;

- (void)viewDidLoad {
    [super viewDidLoad];
    recipeManager = [FSTSavedRecipeManager sharedInstance];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    storedRecipes = [recipeManager getSavedRecipes]; // needs to reload on the back button as well
    [self.tableView reloadData]; // apparently count has to reset
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [storedRecipes allKeys].count; // will find the number of recipes in memory
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FSTSavedRecipeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"recipe_cell" forIndexPath:indexPath];
    
    NSString* key = [storedRecipes allKeys][indexPath.item];
    FSTRecipe* matchedRecipe = [storedRecipes objectForKey:key];
    // Configure the cell...
    [cell.nameLabel setText:matchedRecipe.friendlyName];
    [cell.noteLabel setText:matchedRecipe.note];
    if (matchedRecipe.photo.image) {
        [cell.recipePhoto setImage:matchedRecipe.photo.image];
    } else {
        [cell.recipePhoto setImage:[UIImage imageNamed:@"camera"]];
    }
    return cell;
}


// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {

    return YES; // need to create our own edit methods as well
}

-(NSArray*)tableView: (UITableView*)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
     UITableViewRowAction *editAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"Edit" handler:^(UITableViewRowAction* action, NSIndexPath *indexPath){
         NSString* key = [storedRecipes allKeys][indexPath.item];
         FSTRecipe* matchedRecipe = [storedRecipes objectForKey:key];
         [self.delegate segueWithRecipe:matchedRecipe];
         NSLog(@"Editing\n");
     }];
     editAction.backgroundColor = [UIColor grayColor];
     
     UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"Delete" handler:^(UITableViewRowAction* action, NSIndexPath *indexPath){
         //[self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
         [recipeManager removeItemFromDefaults:(NSString*)([storedRecipes allKeys][indexPath.item])];
         NSLog(@"delete");
         storedRecipes = [recipeManager getSavedRecipes];
         [self.tableView reloadData]; // want to update with removed item gone
         [self.delegate didDeleteRecipe];
     }];
 return @[editAction, deleteAction];
 }

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
        // needs to be empty to let my edit actions take place
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString* key = [storedRecipes allKeys][indexPath.item];
    FSTRecipe* matchedRecipe = [storedRecipes objectForKey:key];
    [self.delegate displayWithRecipe:matchedRecipe]; // grab the selected session and start a cooking stage (probably should pass the method
}

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


@end
