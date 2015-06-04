//
//  FSTReadyToCookViewController.h
//  FirstBuild
//
//  Created by Myles Caley on 5/12/15.
//  Copyright (c) 2015 FirstBuild. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FSTParagon.h"

@interface FSTReadyToCookViewController : UIViewController
@property (strong, nonatomic) IBOutlet UILabel *cookingLabel;
@property (strong, nonatomic) IBOutlet UILabel *tempLabel;
@property (nonatomic,retain) FSTParagon* currentParagon;

@end
