//
//  ProductAddViewController.m
//  FirstBuild-Mobile
//
//  Created by Myles Caley on 12/11/14.
//  Copyright (c) 2014 FirstBuild. All rights reserved.
//

#import "ProductAddViewController.h"
#import <SWRevealViewController.h>
#import "FSTParagon.h"
#import "FSTPizzaOven.h"
#import "FSTBleCommissioningViewController.h"
#import "FSTBleCentralManager.h"

@interface ProductAddViewController ()

@end

@implementation ProductAddViewController


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

/**
 *  This essentially determines which products the application actually supports. The 
 *  experimental products should be after the production ones
 *
 *  @param tableView
 *  @param section
 *
 *  @return number of products support
 */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#ifdef EXPERIMENTAL_PRODUCTS
    return 2;
#else
    return 1;
#endif
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    switch (indexPath.row) {
        case 0:
            CellIdentifier = @"paragon";
            break;
            
        case 1:
            CellIdentifier = @"oven";
            break;
            
        default:
            break;
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: CellIdentifier forIndexPath: indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    cell.backgroundColor = [UIColor whiteColor];
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
    if ([segue.identifier isEqualToString:@"segueAddParagon"])
    {
        FSTBleCommissioningViewController* vc = (FSTBleCommissioningViewController*)segue.destinationViewController;
        vc.bleProductClass = sender;
    }
    else if ([segue.identifier isEqualToString:@"segueAddOven"])
    {
        FSTBleCommissioningViewController* vc = (FSTBleCommissioningViewController*)segue.destinationViewController;
        vc.bleProductClass = sender;
    }
}

- (IBAction)ovenTouchHandler:(id)sender {
    if (!([[FSTBleCentralManager sharedInstance] isPoweredOn]))
    {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Oops!"
                                                                                 message:@"Bluetooth must be enabled to add the Pizza Oven."
                                                                          preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *actionOk = [UIAlertAction actionWithTitle:@"OK"
                                                           style:UIAlertActionStyleDefault
                                                         handler:nil];
        [alertController addAction:actionOk];
        [self presentViewController:alertController animated:YES completion:nil];
    }
    else
    {
        [self performSegueWithIdentifier:@"segueAddOven" sender:[FSTPizzaOven class]];
    }
}

- (IBAction)paragonTouchHandler:(id)sender
{
    if (!([[FSTBleCentralManager sharedInstance] isPoweredOn]))
    {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Oops!"
                                                                                 message:@"Bluetooth must be enabled to add a Paragon."
                                                                          preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *actionOk = [UIAlertAction actionWithTitle:@"OK"
                                                           style:UIAlertActionStyleDefault
                                                         handler:nil];
        [alertController addAction:actionOk];
        [self presentViewController:alertController animated:YES completion:nil];
    }
    else
    {
        [self performSegueWithIdentifier:@"segueAddParagon" sender:[FSTParagon class]];
    }

}
@end
