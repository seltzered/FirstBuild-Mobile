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
    //todo: need to investigate...this is called twice once on initial load
    //where the sender is an FSTCookingMethodTableViewController and then the proper one when
    //it is segue'ing into another view. this is called before viewDidLoad as well.
    if ([sender isKindOfClass:[FSTCookingMethod class]] && [segue.destinationViewController isKindOfClass:[FSTBeefSettingsViewController class]])
    {
        self.currentParagon.currentCookingMethod = (FSTCookingMethod*)sender;
        ((FSTBeefSettingsViewController*)segue.destinationViewController).currentParagon = self.currentParagon;
    }
}

- (IBAction)customTap:(id)sender {
    [self performSegueWithIdentifier:@"customSegue" sender:self];
}

/*-(void) viewWillAppear:(BOOL)animated
{
    self.headerLabel.text = [self.currentParagon.currentCookingMethod.name stringByAppendingString:@"?"];
}*/ // view did load so this only happens when adding on two the stack


@end
