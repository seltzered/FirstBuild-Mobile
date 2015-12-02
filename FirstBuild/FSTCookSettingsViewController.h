//
//  FSTCookSettingsViewController.h
//  FirstBuild
//
//  Created by Myles Caley on 8/4/15.
//  Copyright (c) 2015 FirstBuild. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FSTParagon.h"

@interface FSTCookSettingsViewController : UIViewController <FSTParagonDelegate>

@property (nonatomic,weak) FSTParagon* currentParagon;
@property (nonatomic,strong) FSTRecipe* recipe;

@end
