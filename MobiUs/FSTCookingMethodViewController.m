//
//  FSTCookingMethodViewController.m
//  FirstBuild
//
//  Created by Myles Caley on 5/12/15.
//  Copyright (c) 2015 FirstBuild. All rights reserved.
//

#import "FSTCookingMethodViewController.h"
#import "FSTCookingMethods.h"
#import "FSTCookingMethodSubSelectionViewController.h"

@interface FSTCookingMethodViewController ()

@end

@implementation FSTCookingMethodViewController


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

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    FSTCookingMethod* cookingMethod = (FSTCookingMethod*)sender;
    
    if ([segue.destinationViewController isKindOfClass:[FSTCookingMethodSubSelectionViewController class]])
    {
        ((FSTCookingMethodSubSelectionViewController*)segue.destinationViewController).cookingMethod = cookingMethod;
    }
}

- (FSTCookingMethods*) dataRequestedFromChild
{
    return [[FSTCookingMethods alloc]init];
}

- (void) cookingMethodSelected:(FSTCookingMethod *)cookingMethod
{
    [self performSegueWithIdentifier:@"segueSubCookingMethod" sender:cookingMethod];
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
