//
//  FSTCookingMethodSubSelectionViewController.h
//  FirstBuild
//
//  Created by Myles Caley on 5/12/15.
//  Copyright (c) 2015 FirstBuild. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FSTCookingMethodTableViewController.h"
#import "FSTParagon.h"

@interface FSTCookingMethodSubSelectionViewController : UIViewController<FSTCookingMethodTableViewControllerDelegate>

@property (nonatomic,weak) FSTParagon* currentParagon;
@end
