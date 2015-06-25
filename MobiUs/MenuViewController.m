//
//  MenuViewController.m
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

#import "MenuViewController.h"
#import "MobiNavigationController.h"
#import "ProductAddViewController.h"

#import <SWRevealViewController.h>
#import <RBStoryboardLink.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <GooglePlus/GooglePlus.h>

@implementation SWUITableViewCell
@end

@implementation MenuViewController

typedef NS_ENUM(NSInteger, FSTMenuOptions) {
    kHome,
    kAddNewProduct,
    kLogout
};

NSString * const FSTMenuItemSelectedNotification = @"FSTMenuItemSelectedNotification";
NSString * const FSTMenuItemAddNewProduct = @"FSTMenuItemAddNewProduct";
NSString * const FSTMenuItemHome = @"FSTMenuItemHome";


#pragma mark - Table view data source


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    switch (indexPath.row) {
        case kHome:
            CellIdentifier = @"home";
            break;
            
        case kAddNewProduct:
            CellIdentifier = @"addNewProduct";
            break;
          
        case kLogout:
            CellIdentifier = @"logout";
            break;
            
        default:
            break;
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: CellIdentifier forIndexPath: indexPath];
    
    return cell;
}

//TODO move the logout stuff out of here and put as a handler in the login section
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [self.revealViewController rightRevealToggle:self];
    if (indexPath.row == kLogout)
    {
        [[GPPSignIn sharedInstance] signOut];
        [[[FBSDKLoginManager alloc] init] logOut];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    else if (indexPath.row == kAddNewProduct)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:FSTMenuItemSelectedNotification object:FSTMenuItemAddNewProduct];
    }
    else if (indexPath.row == kHome)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:FSTMenuItemSelectedNotification object:FSTMenuItemHome];
    }
    
}

#pragma mark state preservation / restoration
- (void)encodeRestorableStateWithCoder:(NSCoder *)coder {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    // TODO save what you need here
    
    [super encodeRestorableStateWithCoder:coder];
}

- (void)decodeRestorableStateWithCoder:(NSCoder *)coder {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    // TODO restore what you need here
    
    [super decodeRestorableStateWithCoder:coder];
}

- (void)applicationFinishedRestoringState {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    // TODO call whatever function you need to visually restore
}

@end
