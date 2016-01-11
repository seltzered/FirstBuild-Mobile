//
//  FSTParagonMenuViewController
//  FirstBuild-Mobile
//
//  Created by Myles Caley on 10/7/14.
//  Copyright (c) 2014 FirstBuild. All rights reserved.
//
//
//  MenuViewController.m
//  RevealControllerStoryboardExample
//
//  Created by Nick Hodapp on 1/9/13.
//  Copyright (c) 2013 CoDeveloper. All rights reserved.
//

#import "FSTParagonMenuViewController.h"
#import "FSTRevealViewController.h"
#import "FSTParagonMenuSettingsViewController.h"
#import "FSTParagonMenuAboutViewController.h"
#import "FSTParagonMenuDiagnosticsViewController.h"

@implementation FSTParagonMenuViewController
{
    
}

typedef NS_ENUM(NSInteger, FSTMenuOptions) {
    kHome,
//    kSettings,
    kHelp,
    kFeedback,
    kAbout,
//    kDiagonistics,
    kFoodSafety

};

NSString * const FSTMenuItemSelectedNotification = @"FSTMenuItemSelectedNotification";
NSString * const FSTMenuItemHome = @"FSTMenuItemHome";

-(void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.interactivePopGestureRecognizer.enabled = false;
}

#pragma mark - Table view data source


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    switch (indexPath.row) {
        case kHome:
            CellIdentifier = @"home";
            break;
//        case kSettings:
//            CellIdentifier = @"settings";
//            break;
        case kHelp:
            CellIdentifier = @"help";
            break;
        case kFeedback:
            CellIdentifier = @"feedback";
            break;
        case kAbout:
            CellIdentifier = @"about";
            break;
//        case kDiagonistics:
//            CellIdentifier = @"diagnostics";
//            break;
        case kFoodSafety:
            CellIdentifier = @"foodsafety";
            break;
        default:
            break;
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: CellIdentifier forIndexPath: indexPath];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.row == kHome)
    {
        [self.revealViewController rightRevealToggle:self]; // should this happen every time?
        [[NSNotificationCenter defaultCenter] postNotificationName:FSTMenuItemSelectedNotification object:FSTMenuItemHome];
//    } else if (indexPath.row == kSettings) {
//        [self performSegueWithIdentifier:@"menuSettingsSegue" sender:self];
    } else if (indexPath.row == kHelp) {
    } else if (indexPath.row == kFeedback) {
        NSString *subject = [NSString stringWithFormat:@"Paragon iOS App Feedback"];
        NSString *mail = [NSString stringWithFormat:@"paragon@firstbuild.com"];
        NSURL *url = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"mailto:?to=%@&subject=%@",
                                                    [mail stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding],
                                                    [subject stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding]]];
        [[UIApplication sharedApplication] openURL:url];
    } else if (indexPath.row == kAbout) {
        [self performSegueWithIdentifier:@"menuAboutSegue" sender:self];
    }
    else if (indexPath.row == kFoodSafety) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.foodauthority.nsw.gov.au/_Documents/scienceandtechnical/sous_vide_food_safey_precautions.pdf"]];
    }
//    else if (indexPath.row == kDiagonistics) {
//        [self performSegueWithIdentifier:@"menuDiagnosticsSegue" sender:self];
//    }
    
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    UIViewController* vc = segue.destinationViewController; // store vc to be cast in these statements
    if ([segue.identifier isEqualToString:@"menuSettingsSegue"]) {
        ((FSTParagonMenuSettingsViewController*)vc).currentParagon = self.currentParagon;
    } else if([segue.identifier isEqualToString:@"menuAboutSegue"]) {
        // set paragon (not yet a member)
    }
    else if([segue.identifier isEqualToString:@"menuDiagnosticsSegue"]) {
        ((FSTParagonMenuDiagnosticsViewController*)vc).currentParagon = self.currentParagon;
    }
}
#pragma mark - BONEYARD

//TODO move the logout stuff out of here and put as a handler in the login section
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    
//    [self.revealViewController rightRevealToggle:self];
//    if (indexPath.row == kLogout)
//    {
//        [[GPPSignIn sharedInstance] signOut];
//        [[[FBSDKLoginManager alloc] init] logOut];
//        [self dismissViewControllerAnimated:YES completion:nil];
//    }
//    else if (indexPath.row == kAddNewProduct)
//    {
//        [[NSNotificationCenter defaultCenter] postNotificationName:FSTMenuItemSelectedNotification object:FSTMenuItemAddNewProduct];
//    }
//    else if (indexPath.row == kHome)
//    {
//        [[NSNotificationCenter defaultCenter] postNotificationName:FSTMenuItemSelectedNotification object:FSTMenuItemHome];
//    }
//    
//}


@end
