//
//  FSTCookingMethodViewController.m
//  FirstBuild
//
//  Created by Myles Caley on 5/12/15.
//  Copyright (c) 2015 FirstBuild. All rights reserved.
//

#import "FSTCookingMethodViewController.h"
#import "FSTCustomCookSettingsViewController.h"
#import "FSTBeefSousVideCookingMethod.h"
#import "FSTCookingMethods.h"
#import "FSTCookingMethodSubSelectionViewController.h"
#import "MobiNavigationController.h"
#import "FSTRevealViewController.h"

@interface FSTCookingMethodViewController ()

@end

@implementation FSTCookingMethodViewController

FSTCookingMethods* _methods;

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    _methods = [[FSTCookingMethods alloc]init];
    if ([self.childViewControllers[0] isKindOfClass:[FSTCookingMethodTableViewController class]])
    {
        ((FSTCookingMethodTableViewController*) self.childViewControllers[0]).delegate = self;
    }
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    
}

- (void)dealloc
{
    DLog(@"dealloc");
}

-(void)viewWillAppear:(BOOL)animated {
    
    MobiNavigationController* navigation = (MobiNavigationController*)self.navigationController;
    [navigation setHeaderImageNamed:@"Paragon_Logo_Red" withFrameRect:CGRectMake(0, 0, 120, 30)];
    [navigation.navigationBar setBarTintColor:[UIColor blackColor]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([sender isKindOfClass:[FSTCookingMethod class]])
    {
        ((FSTCookSettingsViewController*)segue.destinationViewController).currentParagon = self.product;
        self.product.toBeCookingMethod = (FSTCookingMethod*)sender;
    }
}

- (FSTCookingMethods*) dataRequestedFromChild
{
    return _methods;
}

- (void) cookingMethodSelected:(FSTCookingMethod *)cookingMethod
{
    [self performSegueWithIdentifier:@"segueSubCookingMethod" sender:cookingMethod];
}

- (IBAction)customTap:(id)sender {
    [self performSegueWithIdentifier:@"segueCustom" sender:nil];

}
- (IBAction)menuToggleTapped:(id)sender {
    [self.revealViewController rightRevealToggle:self.product];
}


@end
