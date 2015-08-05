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
#import "FSTParagon.h"

@interface FSTCookingViewController : UIViewController <UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *cookingStatusLabel;
@property (weak, nonatomic) IBOutlet UIImageView *instructionImage;
@property (strong, nonatomic) IBOutlet FSTCookingProgressView *cookingProgressView;
@property (nonatomic,weak) FSTParagon* currentParagon;
@property (strong, nonatomic) IBOutlet UILabel *topCircleLabel;
@property (strong, nonatomic) IBOutlet UILabel *boldOverheadLabel;
@property (strong, nonatomic) IBOutlet UILabel *boldLabel;
@property (strong, nonatomic) IBOutlet UILabel *cookingModeLabel;
@property (weak, nonatomic) IBOutlet UIView *continueButton;
@property (weak, nonatomic) IBOutlet UIView *dividingLine;
@property (nonatomic) ProgressState progressState;
@end
