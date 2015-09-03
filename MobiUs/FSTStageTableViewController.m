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
    if (self.stageCount >= 5 || ![self.delegate canEditStages]) {
        // hide immediately if the delegate says you should not edit
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
    if ([self.delegate canEditStages]) {
        if (self.stageCount >= 5) {
            self.addStageView.hidden = true;
        } else {
            self.addStageView.hidden = false;
            // number can lower with deletion
        }
    } else {
        self.addStageView.hidden = YES;
    }
    return self.stageCount; // when does this set?
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"StageCell" forIndexPath:indexPath];
    [cell.textLabel setText:[NSString stringWithFormat:@"Stage %i", indexPath.item + 1]]; // number stage
    return cell;
}

- (IBAction)addStageTapped:(id)sender { // created a new stage
    if ([self.delegate canEditStages]) {
        if (self.stageCount < 5) {
            self.stageCount++; // increment under 5
        }
        // now check if we should hide
        if (self.stageCount >= 5) {
            self.addStageView.hidden = YES;
        } else {
            self.addStageView.hidden = NO;
        }
        // perhaps only need this in number of rows function
    } else {
        self.addStageView.hidden = YES;
    }
    
    [self.delegate editStageAtIndex:self.stageCount]; // tell the edit controller we want to change this stage number
    [self.tableView reloadData];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // selected an existing stage
    [self.delegate editStageAtIndex:indexPath.item];
    
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return [self.delegate canEditStages];

}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.delegate deleteStageAtIndex:indexPath.item];
        //[tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        self.stageCount--;
        [self.tableView reloadData];
        // updating the count, rather than removing the row, should be sufficient. This way the numbering stays the same.
    }
}


@end
