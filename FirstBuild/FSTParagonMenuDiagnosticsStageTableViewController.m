//
//  FSTParagonMenuDiagnosticsStageTableViewController.m
//  FirstBuild
//
//  Created by Myles Caley on 11/9/15.
//  Copyright © 2015 FirstBuild. All rights reserved.
//

#import "FSTParagonMenuDiagnosticsStageTableViewController.h"
#import "DiagnosticsStageTableViewCell.h"

@interface FSTParagonMenuDiagnosticsStageTableViewController ()

@end

@implementation FSTParagonMenuDiagnosticsStageTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
        
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
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
    return 5;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    DiagnosticsStageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"stageCell" forIndexPath:indexPath];

    if (indexPath.item < self.currentParagon.session.activeRecipe.paragonCookingStages.count )
    {
        FSTParagonCookingStage* stage = self.currentParagon.session.activeRecipe.paragonCookingStages[indexPath.item];
        
        cell.power.text = [stage.maxPowerLevel stringValue];
        cell.minTime.text = [stage.cookTimeMinimum stringValue];
        cell.maxTime.text = [stage.cookTimeMaximum stringValue];
        cell.stage.text = [NSString stringWithFormat:@"%ld",(long)indexPath.item+1];
        cell.temp.text = [stage.targetTemperature stringValue];
        cell.transition.text = [stage.automaticTransition stringValue];
    }
    else
    {
        cell.power.text = @"";
        cell.minTime.text = @"";
        cell.maxTime.text = @"";
        cell.temp.text = @"";
        cell.stage.text = @"";
        cell.transition.text = @"";
    }
    
    
    
    return cell;
}


@end
