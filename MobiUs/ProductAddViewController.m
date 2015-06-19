//
//  ProductAddViewController.m
//  MobiUs
//
//  Created by Myles Caley on 12/11/14.
//  Copyright (c) 2014 FirstBuild. All rights reserved.
//

#import "ProductAddViewController.h"
#import <SWRevealViewController.h>

@interface ProductAddViewController ()

@end

@implementation ProductAddViewController


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    switch (indexPath.row) {
        case 0:
            CellIdentifier = @"chillhub";
            break;
            
        case 1:
            CellIdentifier = @"paragon";
            break;
            
        default:
            break;
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: CellIdentifier forIndexPath: indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    cell.backgroundColor = UIColorFromRGB(0x00B5CC);
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 46;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.alpha = 1;
    self.navigationController.navigationBar.translucent = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated
{
  
}

- (IBAction)revealToggle:(id)sender {
         [self.revealViewController revealToggle:sender];
}

@end
