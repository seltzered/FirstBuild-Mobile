//
//  FSTCookingStateViewController.h
//  FirstBuild
//
//  Created by John Nolan on 8/6/15.
//  Copyright (c) 2015 FirstBuild. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FSTCookingProgressView.h"
#import "FSTCookingViewController.h"

@interface FSTCookingStateViewController : UIViewController<FSTCookingViewControllerDelegate>

@property (nonatomic) NSTimeInterval remainingHoldTime;

@property (nonatomic) NSTimeInterval targetMinTime;

@property (nonatomic) NSTimeInterval targetMaxTime;

@property (nonatomic) CGFloat currentTemp;

@property (nonatomic) CGFloat targetTemp;

@property (nonatomic) CGFloat burnerLevel;

-(void)updatePercent; // implementation changes for each subclass

-(double)calculatePercent:(NSTimeInterval)fromTime toTime:(NSTimeInterval)endTime;

-(double)calculatePercentWithTemp; // give subclasses access to these functions

-(void) updateLabels;

@end
