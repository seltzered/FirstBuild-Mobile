//
//  FSTParagon.h
//  FirstBuild
//
//  Created by Myles Caley on 3/12/15.
//  Copyright (c) 2015 FirstBuild. All rights reserved.
//

#import "FSTProduct.h"
#import "FSTParagonCookingSession.h"
#import "FSTCookingMethod.h"

@protocol FSTParagonDelegate

@optional
- (void) actualTemperatureChanged: (NSNumber*)actualTemperature;
- (void) cookTimeElapsedChanged: (NSNumber*)elapsedTime;
- (void) cookModeChanged;

@end

@interface FSTParagon : FSTProduct

@property (nonatomic, strong) NSString* serialNumber;
@property (nonatomic, strong) NSString* modelNumber;
@property (nonatomic, strong) FSTCookingMethod* currentCookingMethod;
@property (nonatomic, strong) id<FSTParagonDelegate> delegate;

#ifdef SIMULATE_PARAGON
- (void)startSimulatePreheat;
- (void)startSimulateCookModeChanged;

#endif

@end
