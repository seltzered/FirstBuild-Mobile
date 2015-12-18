//
//  FSTPoultryTurkeyBoneInSousVideRecipe.m
//  FirstBuild
//
//  Created by Myles Caley on 12/18/15.
//  Copyright © 2015 FirstBuild. All rights reserved.
//

#import "FSTPoultryTurkeyBoneInSousVideRecipe.h"

@implementation FSTPoultryTurkeyBoneInSousVideRecipe
- (id) init
{
    self = [super init];
    if (self)
    {
        self.name = @"Breast (bone-in)";
        
        self.donenesses = @[@149,
                            @165,
                            ];
        
        self.donenessLabels = @{@149:@"Medium-Well",
                                @165:@"Well",
                                };
        
        self.thicknesses = @[
                             @(2),
                             @(2.25),
                             @(2.5),
                             @(2.75),
                             @(3)
                             ];
        
        self.thicknessLabels = @{
                                 @(2):@[@"2",@"",@""],
                                 @(2.25):@[@"2",@"1",@"4"],
                                 @(2.5):@[@"2",@"1",@"2"],
                                 @(2.75):@[@"2",@"3",@"4"],
                                 @(3):@[@"3",@"",@""]
                                 };
        
        self.cookingTimes =
        @{
          @150:@{
                  @2:@[@4,@0,@8,@0],
                  @2.25:@[@4,@0,@8,@0],
                  @2.5:@[@4,@0,@8,@0],
                  @2.75:@[@4,@0,@8,@0],
                  @3:@[@4,@0,@8,@0],
                  },
          @165:@{
                  @2:@[@3,@0,@6,@0],
                  @2.25:@[@3,@0,@6,@0],
                  @2.5:@[@3,@0,@6,@0],
                  @2.75:@[@3,@0,@6,@0],
                  @3:@[@3,@0,@6,@0],
                  },
          };
        
    }
    return self;
    
}

@end
