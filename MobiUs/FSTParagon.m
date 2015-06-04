//
//  FSTParagon.m
//  FirstBuild
//
//  Created by Myles Caley on 3/12/15.
//  Copyright (c) 2015 FirstBuild. All rights reserved.
//

#import "FSTParagon.h"

@implementation FSTParagon

NSString * const FSTActualTemperatureChangedNotification = @"FSTActualTemperatureChangedNotification";
NSString * const FSTCookModeChangedNotification = @"FSTCookModeChangedNotification";

#ifdef SIMULATE_PARAGON
uint8_t _simulatePreheatIndex = 0;
uint8_t _simulateCookIndex = 0;
NSArray* _simulatePreheat ;
NSArray* _simulateCook ;
#endif

- (id)init
{
    self = [super init];
    return self;
}

#ifdef SIMULATE_PARAGON
- (void)startSimulatePreheat
{
    _simulatePreheat =  @[@73,
                          @80,
                          @85,
                          @87,
                          @95,
                          @100,
                          @110,
                          @127,
                          @128,
                          @130,
                          @133,
                          @134.5,
                          @136.5,
                          @138,
                          @140,
                          @142,
                          @143.5,
                          @145.5,
                          @147,
                          @149,
                          @151,
                          @158,
                          @160
                          ];
    
    _simulatePreheatIndex = 0;
    
    if (self.currentCookingMethod.session.paragonCookingStages[0])
    {
        [self simulatePreheat];
    }
    
}

- (void)startSimulateCookModeChanged
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:FSTCookModeChangedNotification object:self];
    });
}

- (void)simulatePreheat
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        FSTParagonCookingStage* stage = (FSTParagonCookingStage*)self.currentCookingMethod.session.paragonCookingStages[0];
        
        //reset back to 0 if we hit the end
        if (_simulatePreheatIndex == _simulatePreheat.count)
        {
            _simulatePreheatIndex = 0;
        }
        stage.actualTemperature = _simulatePreheat[_simulatePreheatIndex];

        [[NSNotificationCenter defaultCenter] postNotificationName:FSTActualTemperatureChangedNotification object:self];

        _simulatePreheatIndex++;
        [self simulatePreheat];
        
    });
}
#endif

@end
