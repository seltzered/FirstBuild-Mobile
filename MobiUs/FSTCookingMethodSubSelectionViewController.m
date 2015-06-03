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

@interface FSTCookingMethodSubSelectionViewController ()

@end

@implementation FSTCookingMethodSubSelectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ([self.childViewControllers[0] isKindOfClass:[FSTCookingMethodTableViewController class]])
    {
        ((FSTCookingMethodTableViewController*) self.childViewControllers[0]).delegate = self;
    }
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


@end
