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
#import "FSTLine.h"

@interface FSTRecipeTypeTableViewController ()

@end

@implementation FSTRecipeTypeTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    
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


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"typeCell"];
    
    if (indexPath.item == 0) {
        [cell.textLabel setText:@"Sous Vide"];
        
    } else {
        [cell.textLabel setText:@"Multi-stage"];
    }
    
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.textLabel.font = [UIFont fontWithName:@"FSEmeric-Light" size:22];
    
    FSTLine *lineView = [[FSTLine alloc] initWithFrame:CGRectMake(0, cell.contentView.frame.size.height - 1.0, cell.contentView.frame.size.width, 1)];
    lineView.backgroundColor = [UIColor clearColor];
    [cell.contentView addSubview:lineView]; // a line at the bottom of the cell
    
    UIView *view = [[UIView alloc]initWithFrame:cell.frame]; // highlight filling in the whole background
    view.backgroundColor = UIColorFromRGB(0xF0663A);// UIColorFromRGB(0xFF0105); // orange highlight color
    [cell setSelectedBackgroundView:view];
    cell.textLabel.highlightedTextColor = [UIColor whiteColor];

    return cell;
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return NO;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.item == 0) { // selected Sous Vide recipe
        [self.delegate performSegueWithIdentifier:@"editSegue" sender:[[FSTSousVideRecipe alloc] init]];
    } else { // selected multi stage
        [self.delegate performSegueWithIdentifier:@"editSegue" sender:[[FSTMultiStageRecipe alloc] init]];
    } // so now there will always be a recipe set in the edit recipe screen
}


@end
