//
//  FSTParagonMenuViewController
//  MobiUs
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

@implementation FSTParagonMenuViewController

typedef NS_ENUM(NSInteger, FSTMenuOptions) {
    kHome,
    kSettings,
    kHelp,
    kFeedback,
    kAbout

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
        case kSettings:
            CellIdentifier = @"settings";
            break;
        case kHelp:
            CellIdentifier = @"help";
            break;
        case kFeedback:
            CellIdentifier = @"feedback";
            break;
        case kAbout:
            CellIdentifier = @"about";
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
    } else if (indexPath.row == kSettings) {
        [self performSegueWithIdentifier:@"menuSettingsSegue" sender:self];
    } else if (indexPath.row == kHelp) {
        // open the firstbuild help website in browser
    } else if (indexPath.row == kFeedback) {
        // open new email to firstbuild
    } else if (indexPath.row == kAbout) {
        [self performSegueWithIdentifier:@"menuAboutSegue" sender:self];
    }
    
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    UIViewController* vc = segue.destinationViewController; // store vc to be cast in these statements
    if ([segue.identifier isEqualToString:@"menuSettingsSegue"]) {
        ((FSTParagonMenuSettingsViewController*)vc).currentParagon = self.currentParagon;
    } else if([segue.identifier isEqualToString:@"menuAboutSegue"]) {
        // set paragon (not yet a member)
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
