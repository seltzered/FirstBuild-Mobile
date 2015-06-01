//
//  FSTBeefSousVideCookingMethod.h
//  FirstBuild
//
//  Created by Myles Caley on 5/13/15.
//  Copyright (c) 2015 FirstBuild. All rights reserved.
//

#import "FSTSousVideCookingMethod.h"

@interface FSTBeefSousVideCookingMethod : FSTSousVideCookingMethod

@property (nonatomic, retain) NSArray* thicknesses;
@property (nonatomic, retain) NSDictionary* thicknessLabels;
@property (nonatomic, retain) NSDictionary* donenesses; // :)
@property (nonatomic, retain) NSDictionary* cookingTimes;

@end
