//
//  FSTRecipeTypeTableViewController.m
//  FirstBuild
//
//  Created by John Nolan on 8/27/15.
//  Copyright (c) 2015 FirstBuild. All rights reserved.
//

#import "FSTRecipeTypeTableViewController.h"
#import "FSTSousVideRecipe.h"
#import "FSTMultiStageRecipe.h"
#import "FSTSavedEditRecipeViewController.h"

@interface FSTRecipeTypeTableViewController ()

@end

@implementation FSTRecipeTypeTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"typeCell"];
    
    if (indexPath.item == 0) {
        [cell.textLabel setText:@"Sous Vide"];
    } else {
        [cell.textLabel setText:@"Multi-stage"];
    }
    
    return cell;
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return NO;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.item == 0) { // selected Sous Vide recipe
        [self performSegueWithIdentifier:@"editSegue" sender:[[FSTSousVideRecipe alloc] init]];
    } else { // selected multi stage
        [self performSegueWithIdentifier:@"editSegue" sender:[[FSTMultiStageRecipe alloc] init]];
    } // so now there will always be a recipe set in the edit recipe screen
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    ((FSTSavedEditRecipeViewController*)segue.destinationViewController).activeRecipe = (FSTRecipe*)sender; // hopefully it is still the correct class in the edit recipe view controller
    if ([sender isKindOfClass:[FSTSousVideRecipe class]]) {
        ((FSTSavedEditRecipeViewController*)segue.destinationViewController).is_multi_stage = [NSNumber numberWithBool:NO];
        // no multi stage on sous vide
    } else if ([sender isKindOfClass:[FSTMultiStageRecipe class]]) {
        ((FSTSavedEditRecipeViewController*)segue.destinationViewController).is_multi_stage = [NSNumber numberWithBool:YES];
    }
}
// TODO: deque 2 viewControllerswhen saving the recipe

@end
