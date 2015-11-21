//
//  FSTBeefSteakSousVideRecipe.m
//  FirstBuild
//
//  Created by Myles Caley on 11/19/15.
//  Copyright © 2015 FirstBuild. All rights reserved.
//

#import "FSTBeefSteakTenderSousVideRecipe.h"

@implementation FSTBeefSteakTenderSousVideRecipe


- (id) init
{
    self = [super init];
    if (self)
    {
        
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
                  @0.25:@[@0,@30,@1,@30], //<--start here>
                  @0.5:@[@0,@30,@1,@30],
                  @0.75:@[@0,@30,@1,@30],
                  @1:@[@1,@0,@3,@00],
                  @1.25:@[@1,@0,@3,@00],
                  @1.5:@[@1,@30,@3,@30],
                  @1.75:@[@1,@30,@3,@30],
                  @2:@[@1,@30,@3,@30],
                  },
          @140:@{
                  @0.25:@[@0,@30,@1,@30],
                  @0.5:@[@0,@30,@1,@30],
                  @0.75:@[@0,@30,@1,@30],
                  @1:@[@1,@00,@3,@00],
                  @1.25:@[@1,@0,@3,@00],
                  @1.5:@[@1,@30,@5,@00],
                  @1.75:@[@1,@30,@5,@00],
                  @2:@[@1,@30,@5,@00],
                  },
          @150:@{
                  @0.25:@[@0,@30,@1,@30],
                  @0.5:@[@0,@30,@1,@30],
                  @0.75:@[@0,@30,@1,@30],
                  @1:@[@0,@45,@3,@00],
                  @1.25:@[@0,@45,@3,@00],
                  @1.5:@[@1,@30,@4,@00],
                  @1.75:@[@1,@30,@4,@00],
                  @2:@[@1,@30,@4,@00],
                  },
          @158:@{
                  @0.25:@[@0,@30,@1,@30],
                  @0.5:@[@0,@30,@1,@30],
                  @0.75:@[@0,@30,@1,@30],
                  @1:@[@1,@45,@3,@00],
                  @1.25:@[@0,@45,@3,@00],
                  @1.5:@[@1,@30,@4,@00],
                  @1.75:@[@1,@30,@4,@00],
                  @2:@[@1,@30,@4,@00],
                  },
          };
        
    }
    return self;
    
}

@end

