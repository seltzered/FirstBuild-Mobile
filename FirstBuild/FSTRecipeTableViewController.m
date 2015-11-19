//
//  FSTCookingMethodTableViewController.m
//  FirstBuild
//
//  Created by Myles Caley on 5/13/15.
//  Copyright (c) 2015 FirstBuild. All rights reserved.
//

#import "FSTRecipeTableViewController.h"
#import "FSTLine.h"

@interface FSTRecipeTableViewController ()

@property (nonatomic,retain) FSTRecipes* recipes;

@end

@implementation FSTRecipeTableViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.clearsSelectionOnViewWillAppear = NO; // changing this to yes did nothing, perhaps it doesn't appear again since it is the same tableview twice.
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)dealloc
{
    DLog("dealloc");
    self.recipes = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    self.tableView.userInteractionEnabled = YES;

    self.recipes = [self.delegate dataRequestedFromChild];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return self.recipes.recipes.count;
}

- (UITableViewCell *)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
     // eventually, the cells will control the subcategories, so the tables load new data depending on the current selection. Perhaps there is some animation to fill in a tableview, and I could reset the table with the selection as the first member (the pointed header could be the selected background view)
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CookingMethodCell" forIndexPath:indexPath]; // changed from UITableViewCell,only animation overloaded on this version
    
    cell.textLabel.text = ((FSTRecipe*)self.recipes.recipes[indexPath.row]).name; // this is all caps, set back to normal text
    cell.textLabel.textColor = [UIColor blackColor];//UIColorFromRGB(0xFF0105); // set to red color
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.textLabel.font = [UIFont fontWithName:@"FSEmeric-Light" size:22];
    
    FSTLine *lineView = [[FSTLine alloc] initWithFrame:CGRectMake(0, cell.contentView.frame.size.height - 1.0, cell.contentView.frame.size.width, 1)];
    lineView.backgroundColor = [UIColor clearColor];
    [cell.contentView addSubview:lineView]; // a line at the bottom of the cell
    
    UIView *view = [[UIView alloc]initWithFrame:cell.frame]; // highlight filling in the whole background
    view.backgroundColor = UIColorFromRGB(0xF0663A);// UIColorFromRGB(0xFF0105); // orange highlight color
    [cell setSelectedBackgroundView:view];
    cell.textLabel.highlightedTextColor = [UIColor whiteColor];
    return cell; // al this will work in the tableviewcontroller initialization
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    __weak typeof(self) weakSelf = self;

    weakSelf.tableView.userInteractionEnabled = NO;
    
    FSTRecipe* recipe = weakSelf.recipes.recipes[indexPath.row];
    
    // clear selection property not making a difference // this might be a problem if the selection changes
    [weakSelf.tableView deselectRowAtIndexPath:weakSelf.tableView.indexPathForSelectedRow animated:YES];
    [weakSelf.delegate recipeSelected:recipe];
}


//note: this and viewDidLayoutSubviews are hacks to get the cells to go all the way to the left
//not sure why this is necessary.
//todo: revisit
//http://stackoverflow.com/questions/25770119/ios-8-uitableview-separator-inset-0-not-working
//
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [cell setBackgroundColor:[UIColor clearColor]]; // default is white in some versions
    
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

-(void)viewDidLayoutSubviews
{
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }
}

@end
