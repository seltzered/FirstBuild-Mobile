//
//  FSTStageTableViewController.m
//  FirstBuild
//
//  Created by John Nolan on 8/26/15.
//  Copyright (c) 2015 FirstBuild. All rights reserved.
//

#import "FSTStageTableViewController.h"
#import "FSTSavedRecipeUnderLineView.h"

@interface FSTStageTableViewController ()

@property (weak, nonatomic) IBOutlet UIView *addStageView;


@end

@implementation FSTStageTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //self.stageCount = 1; //TODO: need a way to tell this how many stages there are (will probably set it when the edit screen loads
    self.clearsSelectionOnViewWillAppear = YES;
    [self.tableView reloadData]; // not resetting the stage count at the beginning
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated]; // this is the only time the stage is set
    [self.tableView reloadData];
    if (self.stageCount >= 5) {
        self.addStageView.hidden = YES;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.stageCount; // when does this set?
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"StageCell" forIndexPath:indexPath];
    [cell.textLabel setText:[NSString stringWithFormat:@"Stage %i", indexPath.item + 1]]; // number stage
    return cell;
}

- (IBAction)addStageTapped:(id)sender { // created a new stage
    if (self.stageCount < 5) {
        self.stageCount++; // increment under 5
    }
    // now check if we should hide
    if (self.stageCount >= 5) {
        self.addStageView.hidden = true;
    }
    
    [self.delegate editStageAtIndex:self.stageCount]; // tell the edit controller we want to change this stage number
    [self.tableView reloadData];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // selected an existing stage
    [self.delegate editStageAtIndex:indexPath.item];
    
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
