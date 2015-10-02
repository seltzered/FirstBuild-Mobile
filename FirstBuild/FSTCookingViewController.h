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

@protocol FSTCookingViewControllerDelegate

-(void) currentTemperatureChanged:(CGFloat)currentTemperature;
-(void) targetTemperatureChanged:(CGFloat)targetTemperature;
-(void) elapsedTimeChanged:(NSTimeInterval)elapsedTime; 
-(void) targetTimeChanged:(NSTimeInterval)minTime withMax: (NSTimeInterval) maxTime;
-(void) burnerLevelChanged:(CGFloat)burnerLevel;

@end

@interface FSTCookingViewController : UIViewController <UIAlertViewDelegate, FSTParagonDelegate>

//@property (weak, nonatomic) IBOutlet UILabel *cookingStatusLabel; // now fixed
//@property (weak, nonatomic) IBOutlet UIImageView *instructionImage;
@property (nonatomic) id<FSTCookingViewControllerDelegate> delegate;
@property (nonatomic, weak) FSTContainerViewController* stateContainer; // is there a better way to trigger these segues reliably?
@property (nonatomic,weak) FSTParagon* currentParagon;
@property (weak, nonatomic) IBOutlet UIView *continueButton;
@end
