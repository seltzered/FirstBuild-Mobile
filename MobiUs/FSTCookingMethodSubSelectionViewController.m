//
//  FSTCookingMethodSubSelectionViewController.m
//  FirstBuild
//
//  Created by Myles Caley on 5/12/15.
//  Copyright (c) 2015 FirstBuild. All rights reserved.
//

#import "FSTCookingMethodSubSelectionViewController.h"
#import "FSTCookingMethods.h"
#import "FSTSousVideCookingMethods.h"
#import "FSTBeefSousVideCookingMethod.h"
#import "FSTBeefSettingsViewController.h"
#import "MobiNavigationController.h"
#import "FSTCustomCookSettingsViewController.h"
#import "FSTRevealViewController.h"
@interface FSTCookingMethodSubSelectionViewController ()

@end

@implementation FSTCookingMethodSubSelectionViewController

NSString* headerText;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ([self.childViewControllers[0] isKindOfClass:[FSTCookingMethodTableViewController class]])
    {
        ((FSTCookingMethodTableViewController*) self.childViewControllers[0]).delegate = self;
    }
    headerText = [self.currentParagon.currentCookingMethod.name uppercaseString]; // grabs the current cooking method (sous vide most likely) upon loading

}

-(void)viewWillAppear:(BOOL)animated {
    
    MobiNavigationController* controller = (MobiNavigationController*)self.navigationController;
    [controller setHeaderText:headerText withFrameRect:CGRectMake(0, 0, 120, 30)];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (FSTCookingMethods*) dataRequestedFromChild
{
    if ([self.currentParagon.currentCookingMethod isKindOfClass:[FSTSousVideCookingMethod class]])
    {
        return (FSTCookingMethods*)[[FSTSousVideCookingMethods alloc]init];
    }
    return nil;
}

- (void) cookingMethodSelected:(FSTCookingMethod *)cookingMethod
{
    if ([cookingMethod isKindOfClass:[FSTBeefSousVideCookingMethod class]])
    {
        [self performSegueWithIdentifier:@"segueBeefSettings" sender:cookingMethod];
    }
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([sender isKindOfClass:[FSTCookingMethod class]] && [segue.destinationViewController isKindOfClass:[FSTBeefSettingsViewController class]])
    {
        self.currentParagon.currentCookingMethod = (FSTCookingMethod*)sender;
        ((FSTBeefSettingsViewController*)segue.destinationViewController).currentParagon = self.currentParagon;
    } else if ([segue.destinationViewController isKindOfClass:[FSTCustomCookSettingsViewController class]]) {
        ((FSTCustomCookSettingsViewController*)segue.destinationViewController).currentParagon = self.currentParagon;
        self.currentParagon.currentCookingMethod = (FSTCookingMethod*) [[FSTSousVideCookingMethod alloc] init];
    }
    
}

- (IBAction)customTap:(id)sender {
    [self performSegueWithIdentifier:@"customSegue" sender:self];
}
- (IBAction)menuToggleTapped:(id)sender {
    [self.revealViewController rightRevealToggle:self.currentParagon]; // the other says product, which is inconsistent
}

/*-(void) viewWillAppear:(BOOL)animated
{
    self.headerLabel.text = [self.currentParagon.currentCookingMethod.name stringByAppendingString:@"?"];
}*/ // view did load so this only happens when adding on two the stack


@end
