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
    // Dispose of any resources that can be recreated.
}

- (FSTCookingMethods*) dataRequestedFromChild
{
    if ([self.cookingMethod isKindOfClass:[FSTSousVideCookingMethod class]])
    {
        return (FSTCookingMethods*)[[FSTSousVideCookingMethods alloc]init];
    }
    return nil;
}

- (void) cookingMethodSelected:(FSTCookingMethod *)cookingMethod
{
    [self performSegueWithIdentifier:@"segueBeefSettings" sender:cookingMethod];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
