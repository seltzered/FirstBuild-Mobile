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
    
    MobiNavigationController* navigation = (MobiNavigationController*)self.navigationController;
    [navigation setHeaderImageNamed:@"PNG_logo_paragon_white" withFrameRect:CGRectMake(0, 0, 120, 30)];
    [navigation.navigationBar setBarTintColor:UIColorFromRGB(0x313234)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{    
    if ([segue.destinationViewController isKindOfClass:[FSTCookingMethodSubSelectionViewController class]])
    {
        ((FSTCookingMethodSubSelectionViewController*)segue.destinationViewController).currentParagon = self.product;
        self.product.currentCookingMethod = (FSTCookingMethod*)sender;
    } else if ([segue.destinationViewController isKindOfClass:[FSTCustomCookSettingsViewController class]]) {
        ((FSTCustomCookSettingsViewController*)segue.destinationViewController).currentParagon = self.product; // set paragon to selected product
        self.product.currentCookingMethod = (FSTCookingMethod*) [[FSTSousVideCookingMethod alloc] init];//_methods.cookingMethods[0];////need to set this to something, just generic cooking method object hopefully. It crashes at the preheat screen
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
    [self performSegueWithIdentifier:@"segueCustom" sender:self];

}

@end
