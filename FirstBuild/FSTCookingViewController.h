//
//  FSTCookingViewController.h
//  FirstBuild
//
//  Created by Myles Caley on 5/12/15.
//  Copyright (c) 2015 FirstBuild. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FSTCookingProgressView.h"
#import "FSTCookingProgressLayer.h"
#import "FSTContainerViewController.h"
#import "FSTParagon.h"
#import "CookingStateModel.h"

@protocol FSTCookingViewControllerDelegate

- (void)dataChanged: (CookingStateModel*) data;

@end

@interface FSTCookingViewController : UIViewController <UIAlertViewDelegate, FSTParagonDelegate>

@property (nonatomic) id<FSTCookingViewControllerDelegate> delegate;
@property (nonatomic, weak) FSTContainerViewController* stateContainer;
@property (strong, nonatomic) IBOutlet UILabel *continueButtonText;
@property (nonatomic,weak) FSTParagon* currentParagon;
@property (weak, nonatomic) IBOutlet UIView *continueButton;
@end
