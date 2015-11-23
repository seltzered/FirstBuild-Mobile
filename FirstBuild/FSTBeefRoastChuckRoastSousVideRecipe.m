//
//  FSTBeefRoastChuckRoastSousVideRecipe.m
//  FirstBuild
//
//  Created by Myles Caley on 11/20/15.
//  Copyright © 2015 FirstBuild. All rights reserved.
//

#import "FSTBeefRoastChuckRoastSousVideRecipe.h"

@implementation FSTBeefRoastChuckRoastSousVideRecipe
- (id) init
{
    self = [super init];
    if (self)
    {
        self.name = @"Chuck Roast";
        
        self.donenesses = @[@125,
                            @130,
                            @140,
                            @150,
                            @158
                            ];
        
        self.donenessLabels = @{@125:@"Rare",
                                @130:@"Medium-Rare",
                                @140:@"Medium",
                                @150:@"Medium-Well",
                                @158:@"Well"
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
          @125:@{
                  @0.25:@[@0,@30,@1,@30],
                  @0.5:@[@0,@30,@1,@30],
                  @0.75:@[@0,@30,@1,@30],
                  @1:@[@1,@0,@3,@0],
                  @1.25:@[@1,@0,@3,@0],
                  @1.5:@[@1,@30,@3,@30],
                  @1.75:@[@1,@30,@3,@30],
                  @2:@[@1,@30,@3,@30],
                  },
          @130:@{
                  @0.25:@[@1,@0,@1,@30],
                  @0.5:@[@1,@15,@1,@30],
                  @0.75:@[@1,@30,@1,@30],
                  @1:@[@1,@45,@1,@30],
                  @1.25:@[@2,@0,@1,@30],
                  @1.5:@[@2,@15,@1,@30],
                  @1.75:@[@2,@30,@1,@30],
                  @2:@[@3,@7,@1,@30],
                  },
          @140:@{
                  @0.25:@[@0,@45,@1,@30],
                  @0.5:@[@0,@55,@1,@30],
                  @0.75:@[@1,@15,@1,@30],
                  @1:@[@1,@30,@1,@30],
                  @1.25:@[@2,@0,@1,@30],
                  @1.5:@[@2,@0,@1,@30],
                  @1.75:@[@2,@15,@1,@30],
                  @2:@[@3,@4,@1,@30],
                  },
          @150:@{
                  @0.25:@[@0,@40,@1,@30],
                  @0.5:@[@0,@45,@1,@30],
                  @0.75:@[@1,@0,@1,@30],
                  @1:@[@1,@15,@1,@30],
                  @1.25:@[@1,@45,@1,@30],
                  @1.5:@[@2,@0,@1,@30],
                  @1.75:@[@2,@15,@1,@30],
                  @2:@[@3,@1,@1,@30],
                  },
          @158:@{
                  @0.25:@[@0,@30,@1,@30],
                  @0.5:@[@0,@40,@1,@30],
                  @0.75:@[@0,@55,@1,@30],
                  @1:@[@1,@15,@1,@30],
                  @1.25:@[@1,@30,@1,@30],
                  @1.5:@[@1,@45,@1,@30],
                  @1.75:@[@2,@0,@1,@30],
                  @2:@[@2,@34,@1,@30],
                  },
          };
        
    }
    return self;
    
}
@end