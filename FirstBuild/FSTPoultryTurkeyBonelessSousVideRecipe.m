//
//  FSTPoultryTurkeyBonelessSousVideRecipe.m
//  FirstBuild
//
//  Created by Myles Caley on 12/18/15.
//  Copyright © 2015 FirstBuild. All rights reserved.
//

#import "FSTPoultryTurkeyBonelessSousVideRecipe.h"

@implementation FSTPoultryTurkeyBonelessSousVideRecipe
- (id) init
{
    self = [super init];
    if (self)
    {
        self.name = @"Breast (boneless)";
        
        self.donenesses = @[@150,
                            @165,
                            ];
        
        self.donenessLabels = @{@150:@"Medium-Well",
                                @165:@"Well",
                                };
        
        self.thicknesses = @[
                             @(1),
                             @(1.25),
                             @(1.5),
                             @(1.75),
                             @(2)
                             ];
        
        self.thicknessLabels = @{
                                 @(1):@[@"1",@"",@""],
                                 @(1.25):@[@"1",@"1",@"4"],
                                 @(1.5):@[@"1",@"1",@"2"],
                                 @(1.75):@[@"1",@"3",@"4"],
                                 @(2):@[@"2",@"",@""]
                                 };
        
        self.cookingTimes =
        @{
          @150:@{
                  @1:@[@3,@0,@6,@0],
                  @1.25:@[@3,@0,@6,@0],
                  @1.5:@[@3,@0,@6,@0],
                  @1.75:@[@3,@0,@6,@0],
                  @2:@[@3,@0,@6,@0],
                  },
          @165:@{
                  @1:@[@2,@30,@6,@0],
                  @1.25:@[@2,@30,@6,@0],
                  @1.5:@[@2,@30,@6,@0],
                  @1.75:@[@2,@30,@6,@0],
                  @2:@[@2,@30,@6,@0],
                  },
          };
        
    }
    return self;
    
}

@end
