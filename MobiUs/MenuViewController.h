//
//  MenuViewController.h
//  MobiUs
//
//  Created by Myles Caley on 10/7/14.
//  Copyright (c) 2014 FirstBuild. All rights reserved.
//
//
//  MenuViewController.h
//  RevealControllerStoryboardExample
//
//  Created by Nick Hodapp on 1/9/13.
//  Copyright (c) 2013 CoDeveloper. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FSTApplicationMenuDelegate <NSObject>

@required

- (void) menuLogoutSelected;

@end

@interface SWUITableViewCell : UITableViewCell



extern NSString * const FSTMenuItemSelectedNotification;
extern NSString * const FSTMenuItemAddNewProduct;
extern NSString * const FSTMenuItemHome ;



@property (nonatomic) IBOutlet UILabel *label;
@end

@interface MenuViewController : UITableViewController
@property (weak) id <FSTApplicationMenuDelegate> menuSelectionDelegate;
@property (strong, nonatomic) IBOutlet SWUITableViewCell *reusableCell;
@property (strong, nonatomic) NSMutableArray *products;
@property (strong, nonatomic) IBOutlet UITableView *productsTableView;

@end
