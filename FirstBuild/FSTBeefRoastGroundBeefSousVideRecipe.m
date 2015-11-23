//
//  FSTBeefRoastGroundBeefSousVideRecipe.m
//  FirstBuild
//
//  Created by Myles Caley on 11/20/15.
//  Copyright © 2015 FirstBuild. All rights reserved.
//

#import "FSTBeefRoastGroundBeefSousVideRecipe.h"

@implementation FSTBeefRoastGroundBeefSousVideRecipe
- (id) init
{
    self = [super init];
    if (self)
    {
        self.name = @"Ground Beef";
        
        self.donenesses = @[@130,
                            @140,
                            @150,
                            @158
                            ];
        
        self.donenessLabels = @{@130:@"Medium-Rare",
                                @140:@"Medium",
                                @150:@"Medium-Well",
                                @160:@"Well"
                                };
        
        self.thicknesses = @[
                             @(0.5),
                             @(0.75),
                             @(1)
                             ];
        
        self.thicknessLabels = @{
                                 @(0.5):@[@" ",@"1",@"2"],
                                 @(0.75):@[@" ",@"3",@"4"],
                                 @(1):@[@"1",@"",@""]
                                 };
        
        self.cookingTimes =
        @{
          @130:@{
                  @0.5:@[@2,@0,@3,@0],
                  @0.75:@[@2,@0,@3,@0],
                  @1:@[@2,@0,@3,@0]
                  },
          @140:@{
                  @0.5:@[@1,@0,@2,@0],
                  @0.75:@[@1,@0,@2,@0],
                  @1:@[@1,@0,@2,@0]
                  },
          @150:@{
                  @0.5:@[@1,@0,@2,@0],
                  @0.75:@[@1,@0,@2,@0],
                  @1:@[@1,@0,@2,@0]
                  },
          @160:@{
                  @0.5:@[@1,@0,@2,@0],
                  @0.75:@[@1,@0,@2,@0],
                  @1:@[@1,@0,@2,@0]
                  },
          };
        
    }
    return self;
    
}
@end
