//
//  ProductAddViewController.m
//  MobiUs
//
//  Created by Myles Caley on 12/11/14.
//  Copyright (c) 2014 FirstBuild. All rights reserved.
//

#import "ProductAddViewController.h"
#import <SWRevealViewController.h>
#import "FSTHumanaPillBottle.h"
#import "FSTParagon.h"
#import "FSTBleCommissioningViewController.h"

@interface ProductAddViewController ()

@end

@implementation ProductAddViewController


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
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
            
        case 2:
            CellIdentifier = @"humanapillbottle";
            break;
            
        default:
            break;
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: CellIdentifier forIndexPath: indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    cell.backgroundColor = [UIColor whiteColor];//UIColorFromRGB(0x00B5CC);
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 46;
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

- (IBAction)revealToggle:(id)sender
{
    [self.revealViewController revealToggle:sender];
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"segueAddHumanaPillBottle"])
    {
        FSTBleCommissioningViewController* vc = (FSTBleCommissioningViewController*)segue.destinationViewController;
        vc.bleProductClass = sender;
    }
    else if ([segue.identifier isEqualToString:@"segueAddParagon"])
    {
        FSTBleCommissioningViewController* vc = (FSTBleCommissioningViewController*)segue.destinationViewController;
        vc.bleProductClass = sender;
    }
}

- (IBAction)pillBottleTouchHandler:(id)sender
{
    [self performSegueWithIdentifier:@"segueAddHumanaPillBottle" sender:[FSTHumanaPillBottle class]];
}

- (IBAction)paragonTouchHandler:(id)sender
{
    [self performSegueWithIdentifier:@"segueAddParagon" sender:[FSTParagon class]];

}
@end
