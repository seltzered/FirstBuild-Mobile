//
//  FSTCookingProgressLayer.h
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

@interface FSTCookingProgressLayer : CAShapeLayer

//states for the different views of the cooking progress screens

@property (nonatomic) CGFloat percent; // calculated by view controllers
@property (nonatomic) UIColor *progressColor;
@property (nonatomic, strong) CAShapeLayer *bottomLayer;
@property (nonatomic, strong) CAShapeLayer *progressLayer;
@property (nonatomic, strong) CAShapeLayer *sittingLayer;
@property (nonatomic, strong) CAShapeLayer *startLineLayer;
//@property (nonatomic, strong) CAShapeLayer *progressLayerEnd;
@property (nonatomic, strong) NSMutableDictionary* markLayers; // holds all the tick marks // layers with angles as keys

- (void) drawPathsForPercent; // fill in paths based upon the 
- (void) drawCompleteTicks;
- (void)setupLayer ;
@end

// Copyright belongs to original author
// http://code4app.net (en) http://code4app.com (cn)
// From the most professional code share website: Code4App.net

