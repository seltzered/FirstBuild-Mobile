//
//  FSTPizzaOven.h
//  FirstBuild
//
//  Created by Myles Caley on 10/5/15.
//  Copyright © 2015 FirstBuild. All rights reserved.
//

#import "FSTBleProduct.h"

@protocol FSTPizzaOvenDelegate <NSObject>
@optional - (void) displayTemperatureChanged: (NSNumber*) temperature;
@optional - (void) setTemperatureChanged: (NSNumber*) temperature;

@end

@interface FSTPizzaOven : FSTBleProduct

@property (nonatomic, weak) id<FSTPizzaOvenDelegate> delegate;

- (NSNumber*)getCurrentSetTemperature;
- (void)setCurrentSetTemperature: (NSNumber*) setTemperature;
- (NSNumber*)getCurrentDisplayTemperature;

@end
