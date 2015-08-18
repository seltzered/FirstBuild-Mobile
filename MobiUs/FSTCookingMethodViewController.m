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
#import "FSTEditRecipeViewController.h"

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
        self.product.toBeCookingMethod = (FSTCookingMethod*)sender;
    }
    
    if  (
            [segue.destinationViewController isKindOfClass:[FSTCookSettingsViewController class]] ||
            [segue.destinationViewController isKindOfClass:[FSTCookingMethodSubSelectionViewController class]] ||
            [segue.destinationViewController isKindOfClass:[FSTEditRecipeViewController class]]
        )
    {
        ((FSTCookSettingsViewController*)segue.destinationViewController).currentParagon = self.product;
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

- (IBAction)recipeTap:(id)sender {
    [self performSegueWithIdentifier:@"recipesSegue" sender:nil];
}

- (IBAction)customTap:(id)sender {
    [self performSegueWithIdentifier:@"segueCustom" sender:nil];

}
- (IBAction)menuToggleTapped:(id)sender {
    [self.revealViewController rightRevealToggle:self.product];
}


@end
