//
//  FSTCookingStateReachingTemperatureViewController.h
//  FirstBuild
//
//  Created by John Nolan on 8/6/15.
//  Copyright (c) 2015 FirstBuild. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FSTCookingStateReachingTemperatureLayer.h"
#import "FSTCookingStateViewController.h"

@interface FSTCookingStateReachingTemperatureViewController :FSTCookingStateViewController
@property (strong, nonatomic) IBOutlet FSTCookingProgressView *circleProgressView;
@property (strong, nonatomic) IBOutlet UILabel *cookingStatusLabel;
@end
