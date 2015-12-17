//
//  FSTPoultryDuckBreastSousVideRecipe.m
//  FirstBuild
//
//  Created by Myles Caley on 12/17/15.
//  Copyright © 2015 FirstBuild. All rights reserved.
//

#import "FSTPoultryDuckBreastSousVideRecipe.h"

@implementation FSTPoultryDuckBreastSousVideRecipe

- (id) init
{
    self = [super init];
    if (self)
    {
        self.name = @"Breast";
        
        self.donenesses = @[@135,
                            @140,
                            ];
        
        self.donenessLabels = @{@135:@"Medium-Rare",
                                @140:@"Medium",
                                };
        
        self.thicknesses = @[
                             @(0.25),
                             @(0.5),
                             @(0.75),
                             @(1),
                             ];
        
        self.thicknessLabels = @{
                                 @(0.25):@[@" ",@"1",@"4"],
                                 @(0.5):@[@" ",@"1",@"2"],
                                 @(0.75):@[@" ",@"3",@"4"],
                                 @(1):@[@"1",@"",@""],
                                 };
        
        self.cookingTimes =
        @{
          @135:@{
                  @0.25:@[@3,@0,@4,@0],
                  @0.5:@[@3,@0,@4,@0],
                  @0.75:@[@3,@0,@4,@0],
                  @1:@[@3,@0,@4,@0],
                  },
          @140:@{
                  @0.25:@[@1,@30,@3,@30],
                  @0.5:@[@1,@30,@3,@30],
                  @0.75:@[@1,@30,@3,@30],
                  @1:@[@1,@30,@3,@30],
                  },
          };
        
    }
    return self;
    
}

@end
