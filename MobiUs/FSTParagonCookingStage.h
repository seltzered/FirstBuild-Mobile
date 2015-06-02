//
//  FSTParagonCookingStage.h
//  FirstBuild
//
//  Created by Myles Caley on 6/2/15.
//  Copyright (c) 2015 FirstBuild. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FSTParagonCookingStage : NSObject
@property (nonatomic, strong) NSNumber* targetTemperature;
@property (nonatomic, strong) NSNumber* actualTemperature;
@property (nonatomic, strong) NSNumber* cookTimeRequested;
@property (nonatomic, strong) NSNumber* cookTimeElapsed;

@end
