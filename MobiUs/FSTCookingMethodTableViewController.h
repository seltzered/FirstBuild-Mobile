//
//  FSTCookingMethodTableViewController.h
//  FirstBuild
//
//  Created by Myles Caley on 5/13/15.
//  Copyright (c) 2015 FirstBuild. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "FSTCookingMethod.h"

@protocol FSTCookingMethodTableViewControllerDelegate

- (NSDictionary *) dataRequestedFromChild;
- (void) cookingMethodSelected: (FSTCookingMethod*)cookignMethod;

@end


@interface FSTCookingMethodTableViewController : UITableViewController

@property (strong, nonatomic) id<FSTCookingMethodTableViewControllerDelegate>delegate;

@end
