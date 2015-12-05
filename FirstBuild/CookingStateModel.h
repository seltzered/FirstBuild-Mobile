//
//  CookingStateModel.h
//  FirstBuild
//
//  Created by Myles Caley on 12/5/15.
//  Copyright © 2015 FirstBuild. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CookingStateModel : NSObject

@property (nonatomic) NSTimeInterval remainingHoldTime;
@property (nonatomic) NSTimeInterval targetMinTime;
@property (nonatomic) NSTimeInterval targetMaxTime;
@property (nonatomic, weak) NSString* directions;
@property (nonatomic, weak) NSString* stagePrep;
@property (nonatomic) CGFloat currentTemp;
@property (nonatomic) CGFloat targetTemp;
@property (nonatomic) CGFloat burnerLevel;

@end
