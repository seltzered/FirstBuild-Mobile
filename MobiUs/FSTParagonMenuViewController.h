//
//  FSTParagonMenuViewController.h
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
#import "FSTParagon.h"

extern NSString * const FSTMenuItemSelectedNotification;
extern NSString * const FSTMenuItemHome ;

@interface FSTParagonMenuViewController : UITableViewController

@property (strong, nonatomic) FSTParagon* currentParagon;

@end
