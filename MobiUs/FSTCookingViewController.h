//
//  FSTCookingViewController.h
//  FirstBuild
//
//  Created by Myles Caley on 5/12/15.
//  Copyright (c) 2015 FirstBuild. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FSTCircleProgressView.h"
#import "FSTCircleProgressLayer.h"
#import "FSTParagon.h"

@interface FSTCookingViewController : UIViewController <UIAlertViewDelegate>


@property (weak, nonatomic) IBOutlet UIImageView *instructionImage;
@property (strong, nonatomic) IBOutlet FSTCircleProgressView *circleProgressView;
@property (nonatomic,retain) FSTParagon* currentParagon;
@property (weak, nonatomic) IBOutlet UILabel *currentOverheadLabel;
@property (weak, nonatomic) IBOutlet UILabel *targetOverheadLabel;
@property (strong, nonatomic) IBOutlet UILabel *currentLabel;
@property (strong, nonatomic) IBOutlet UILabel *targetLabel;
@property (strong, nonatomic) IBOutlet UILabel *cookingModeLabel;
@end
