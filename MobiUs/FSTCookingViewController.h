//
//  FSTCookingViewController.h
//  FirstBuild
//
//  Created by Myles Caley on 5/12/15.
//  Copyright (c) 2015 FirstBuild. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FSTCircleProgressView.h"
#import "FSTParagon.h"

@interface FSTCookingViewController : UIViewController <UIAlertViewDelegate>
@property (strong, nonatomic) IBOutlet FSTCircleProgressView *circleProgressView;
@property (nonatomic,retain) FSTParagon* currentParagon;

@property (strong, nonatomic) IBOutlet UILabel *timeRemainingLabel;
@property (strong, nonatomic) IBOutlet UILabel *doneAtLabel;
@property (strong, nonatomic) IBOutlet UILabel *cookingModeLabel;
@end
