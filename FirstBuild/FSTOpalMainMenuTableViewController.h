//
//  FSTOpalMainMenuTableViewController.h
//  FirstBuild
//
//  Created by Myles Caley on 3/31/16.
//  Copyright © 2016 FirstBuild. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FSTOpal.h"

@interface FSTOpalMainMenuTableViewController : UITableViewController  <FSTOpalDelegate>
@property (weak, nonatomic) FSTOpal* opal;

@end
