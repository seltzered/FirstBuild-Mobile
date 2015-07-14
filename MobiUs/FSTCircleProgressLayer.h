//
//  FSTCircleProgressLayer.h
//  FirstBuild
//
//  Created by Myles Caley on 5/22/15.
//  Copyright (c) 2015 FirstBuild. All rights reserved.
//

//
//  CircleShapeLayer.h
//  CircularProgressControl
//
//  Created by Carlos Eduardo Arantes Ferreira on 22/11/14.
//  Copyright (c) 2014 Mobistart. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface FSTCircleProgressLayer : CAShapeLayer

typedef enum {
    kPreheating = 0,
    kCooking,
    kSitting
} ProgressState; // enum to define the progressLayer's states

@property (nonatomic) NSTimeInterval elapsedTime;
@property (nonatomic) NSTimeInterval timeLimit;
@property (nonatomic) CGFloat currentTemp;
@property (assign, nonatomic, readonly) double percent;
@property (nonatomic) UIColor *progressColor;
@property (nonatomic) ProgressState layerState;
@property (nonatomic) CGFloat targetTemp;
@property (nonatomic) CGFloat startingTemp;
@end

// Copyright belongs to original author
// http://code4app.net (en) http://code4app.com (cn)
// From the most professional code share website: Code4App.net

