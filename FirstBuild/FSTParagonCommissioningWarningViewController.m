//
//  FSTParagonCommissioningWarningViewController.m
//  FirstBuild
//
//  Created by Myles Caley on 1/7/16.
//  Copyright © 2016 FirstBuild. All rights reserved.
//

#import "FSTParagonCommissioningWarningViewController.h"

@implementation FSTParagonCommissioningWarningViewController
{
    
}

- (IBAction)learnMoreTap:(id)sender
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.foodauthority.nsw.gov.au/_Documents/scienceandtechnical/sous_vide_food_safey_precautions.pdf"]];
}

- (IBAction)dismissTap:(id)sender
{
    [self.navigationController popToRootViewControllerAnimated:NO];
}

@end
