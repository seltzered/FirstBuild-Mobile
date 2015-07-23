//
//  FSTCookingMethodTableViewController.m
//  FirstBuild
//
//  Created by Myles Caley on 5/13/15.
//  Copyright (c) 2015 FirstBuild. All rights reserved.
//

#import "FSTCookingMethodTableViewController.h"
#import "FSTDashedLine.h"

@interface FSTCookingMethodTableViewController ()

@property (nonatomic,retain) FSTCookingMethods* methods;

@end

@implementation FSTCookingMethodTableViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.clearsSelectionOnViewWillAppear = NO; // changing this to yes did nothing, perhaps it doesn't appear again since it is the same tableview twice.
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
}

- (void)viewWillAppear:(BOOL)animated
{
    self.methods = [self.delegate dataRequestedFromChild];
    
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
    return self.methods.cookingMethods.count;
}

- (UITableViewCell *)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
     // eventually, the cells will control the subcategories, so the tables load new data depending on the current selection. Perhaps there is some animation to fill in a tableview, and I could reset the table with the selection as the first member (the pointed header could be the selected background view)
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CookingMethodCell" forIndexPath:indexPath]; // changed from UITableViewCell,only animation overloaded on this version
    
    cell.textLabel.text = ((FSTCookingMethod*)self.methods.cookingMethods[indexPath.row]).name; // this is all caps, set back to normal text
    cell.textLabel.textColor = [UIColor blackColor];//UIColorFromRGB(0xFF0105); // set to red color
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.textLabel.font = [UIFont fontWithName:@"FSEmeric-Light" size:22];
    
    FSTDashedLine *lineView = [[FSTDashedLine alloc] initWithFrame:CGRectMake(0, cell.contentView.frame.size.height - 1.0, cell.contentView.frame.size.width, 1)];
    lineView.backgroundColor = [UIColor clearColor];
    [cell.contentView addSubview:lineView];
    
    UIView *view = [[UIView alloc]initWithFrame:cell.frame]; // background filling in the whole background
    view.backgroundColor = UIColorFromRGB(0xF0663A);// UIColorFromRGB(0xFF0105); // same color as text
    [cell setSelectedBackgroundView:view];
    cell.textLabel.highlightedTextColor = [UIColor whiteColor];
    return cell; // al this will work in the tableviewcontroller initialization
}

/*- (NSIndexPath *)tableView:(FSTCookingMethodTableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // seems to already be selected before this
    
    return indexPath;
}
*/
- (void)tableView:(UITableView*)tableView didHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone]; // this does select it twice, but it looks fine. I would prefer to set animation to true from the beginning! perhaps custom tableView?

}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    FSTCookingMethod* method = self.methods.cookingMethods[indexPath.row];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{ // this
        tableView.userInteractionEnabled = YES;
        [self.tableView deselectRowAtIndexPath:self.tableView.indexPathForSelectedRow animated:YES]; // clear selection property not making a difference // this might be a problem if the selection changes
        [self.delegate cookingMethodSelected:method]; // perform segue after a delay to show animation

    });
    tableView.userInteractionEnabled = NO;
    //
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

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
