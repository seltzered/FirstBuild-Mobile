//
//  FSTRecipeTypeTableViewController.h
//  FirstBuild
//
//  Created by John Nolan on 8/27/15.
//  Copyright (c) 2015 FirstBuild. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FSTRecipeTypeTableViewController : UITableViewController

@property (nonatomic, weak) id delegate;
// there are no added protocols, I just need to segue
@end
