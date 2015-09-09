//
//  FSTRecipeTypeTableContainerViewController.m
//  FirstBuild
//
//  Created by John Nolan on 9/2/15.
//  Copyright (c) 2015 FirstBuild. All rights reserved.
//

#import "FSTRecipeTypeTableContainerViewController.h"
#import "FSTRecipeTypeTableViewController.h"
#import "FSTSavedEditRecipeViewController.h"
#import "FSTSousVideRecipe.h"
#import "FSTMultiStageRecipe.h"

@interface FSTRecipeTypeTableContainerViewController ()

@end

@implementation FSTRecipeTypeTableContainerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"editSegue"]) {
        ((FSTSavedEditRecipeViewController*)segue.destinationViewController).activeRecipe = (FSTRecipe*)sender; // hopefully it is still the correct class in the edit recipe view controller
        if ([sender isKindOfClass:[FSTSousVideRecipe class]]) {
            ((FSTSavedEditRecipeViewController*)segue.destinationViewController).is_multi_stage = [NSNumber numberWithBool:NO];
            // no multi stage on sous vide
        } else if ([sender isKindOfClass:[FSTMultiStageRecipe class]]) {
            ((FSTSavedEditRecipeViewController*)segue.destinationViewController).is_multi_stage = [NSNumber numberWithBool:YES];
        }
    } else if ([segue.identifier isEqualToString:@"embedType"]) {
        ((FSTRecipeTypeTableViewController*)segue.destinationViewController).delegate = self;
    }
}


@end
