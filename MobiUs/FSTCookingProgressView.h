//
//  FSTCookingProgressView.h
//  FirstBuild
//
//  Created by Myles Caley on 5/22/15.
//  Copyright (c) 2015 FirstBuild. All rights reserved.
//

//
//  CircleProgressView.h
//  CircularProgressControl
//
//  Created by Carlos Eduardo Arantes Ferreira on 22/11/14.
//  Copyright (c) 2014 Mobistart. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FSTCookingProgressLayer.h"

@interface FSTCookingProgressView : UIControl

@property (nonatomic) NSTimeInterval elapsedTime;

@property (nonatomic) NSTimeInterval timeLimit;

@property (nonatomic) CGFloat currentTemp; // set the current temperature in preheating

//@property (nonatomic, retain) NSString *status;
@property (nonatomic) ProgressState layerState;

@property (assign, nonatomic, readonly) double percent;

@property (nonatomic) CGFloat startingTemp;

@property (nonatomic) CGFloat targetTemp;

@end

// Copyright belongs to original author
// http://code4app.net (en) http://code4app.com (cn)
// From the most professional code share website: Code4App.net
