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
#import "FSTEditRecipeViewController.h"
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
    headerText = [self.currentParagon.toBeCookingMethod.name uppercaseString]; // grabs the current cooking method (sous vide most likely) upon loading

}

- (void)dealloc
{
    DLog(@"dealloc");
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
    if ([self.currentParagon.toBeCookingMethod isKindOfClass:[FSTSousVideCookingMethod class]])
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
    //if we are going to anything other than the custom settings view controller
    //then we need to set the cooking method. the custom settings will initialize the cooking method on its own
    if ([sender isKindOfClass:[FSTCookingMethod class]])
    {
        self.currentParagon.toBeCookingMethod = (FSTCookingMethod*)sender;
        [self.currentParagon.toBeCookingMethod createCookingSession];
        [self.currentParagon.toBeCookingMethod addStageToCookingSession];
    }
    
    if ([segue.destinationViewController isKindOfClass:[FSTCookSettingsViewController class]] || [segue.destinationViewController isKindOfClass:[FSTEditRecipeViewController class]])
    {
        ((FSTCookSettingsViewController*)segue.destinationViewController).currentParagon = self.currentParagon;
    }
}

- (IBAction)recipeTap:(id)sender {
    [self performSegueWithIdentifier:@"recipesSegue" sender:nil];
}

- (IBAction)customTap:(id)sender {
    [self performSegueWithIdentifier:@"customSegue" sender:nil];
}
- (IBAction)menuToggleTapped:(id)sender {
    [self.revealViewController rightRevealToggle:self.currentParagon]; // the other says product, which is inconsistent
}

@end
