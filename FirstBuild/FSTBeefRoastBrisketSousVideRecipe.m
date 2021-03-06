//
//  FSTBeefRoastBrisketSousVideRecipe.m
//  FirstBuild
//
//  Created by Myles Caley on 11/20/15.
//  Copyright © 2015 FirstBuild. All rights reserved.
//

#import "FSTBeefRoastBrisketSousVideRecipe.h"

@implementation FSTBeefRoastBrisketSousVideRecipe
- (id) init
{
    self = [super init];
    if (self)
    {
        self.name = @"Brisket";
        
        self.donenesses = @[@140,
                            @150,
                            @160,
                            ];
        
        self.donenessLabels = @{
                                @140:@"Medium",
                                @150:@"Medium-Well",
                                @160:@"Well",
                                };
        
        self.thicknesses = @[
                             @(0.25),
                             @(0.5),
                             @(0.75),
                             @(1),
                             @(1.25),
                             @(1.5),
                             @(1.75),
                             @(2)
                             ];
        
        self.thicknessLabels = @{
                                 @(0.25):@[@" ",@"1",@"4"],
                                 @(0.5):@[@" ",@"1",@"2"],
                                 @(0.75):@[@" ",@"3",@"4"],
                                 @(1):@[@"1",@"",@""],
                                 @(1.25):@[@"1",@"1",@"4"],
                                 @(1.5):@[@"1",@"1",@"2"],
                                 @(1.75):@[@"1",@"3",@"4"],
                                 @(2):@[@"2",@"",@""]
                                 };
        
        self.cookingTimes =
        @{
          @140:@{
                  @0.25:@[@24,@0,@72,@00],
                  @0.5:@[@24,@0,@72,@00],
                  @0.75:@[@24,@0,@72,@00],
                  @1:@[@24,@0,@72,@00],
                  @1.25:@[@24,@0,@72,@00],
                  @1.5:@[@24,@0,@72,@00],
                  @1.75:@[@24,@0,@72,@00],
                  @2:@[@24,@0,@72,@00],
                  },
          @150:@{
                  @0.25:@[@24,@0,@56,@0],
                  @0.5:@[@24,@0,@56,@0],
                  @0.75:@[@24,@0,@56,@0],
                  @1:@[@24,@0,@56,@0],
                  @1.25:@[@24,@0,@56,@0],
                  @1.5:@[@24,@0,@56,@0],
                  @1.75:@[@24,@0,@56,@0],
                  @2:@[@24,@0,@56,@0],
                  },
          @160:@{
                  @0.25:@[@24,@0,@48,@0],
                  @0.5:@[@24,@0,@48,@0],
                  @0.75:@[@24,@0,@48,@0],
                  @1:@[@24,@0,@48,@0],
                  @1.25:@[@24,@0,@48,@0],
                  @1.5:@[@24,@0,@48,@0],
                  @1.75:@[@24,@0,@48,@0],
                  @2:@[@24,@0,@48,@0],
                  },
          };
        
    }
    return self;
    
}
@end
