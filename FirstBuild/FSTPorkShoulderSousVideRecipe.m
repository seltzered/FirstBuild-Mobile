//
//  FSTPorkShoulderSousVideRecipe.m
//  FirstBuild
//
//  Created by Myles Caley on 12/18/15.
//  Copyright © 2015 FirstBuild. All rights reserved.
//

#import "FSTPorkShoulderSousVideRecipe.h"

@implementation FSTPorkShoulderSousVideRecipe
- (id) init
{
    self = [super init];
    if (self)
    {
        self.name = @"Shoulder";
        
        self.donenesses = @[@140,
                            @160,
                            ];
        
        self.donenessLabels = @{@140:@"Medium",
                                @160:@"Medium-Well",
                                };
        
        self.thicknesses = @[
                             @(1),
                             @(1.25),
                             @(1.5),
                             @(1.75),
                             @(2),
                             @(2.25),
                             @(2.5),
                             @(2.75),
                             @(3),
                             @(3.25),
                             @(3.5),
                             @(3.75),
                             @(4)
                             ];
        
        self.thicknessLabels = @{
                                 @(1):@[@"1",@"",@""],
                                 @(1.25):@[@"1",@"1",@"4"],
                                 @(1.5):@[@"1",@"1",@"2"],
                                 @(1.75):@[@"1",@"3",@"4"],
                                 @(2):@[@"2",@"",@""],
                                 @(2.25):@[@"2",@"1",@"4"],
                                 @(2.5):@[@"2",@"1",@"2"],
                                 @(2.75):@[@"2",@"3",@"4"],
                                 @(3):@[@"3",@"",@""],
                                 @(3.25):@[@"3",@"1",@"4"],
                                 @(3.5):@[@"3",@"1",@"2"],
                                 @(3.75):@[@"3",@"3",@"4"],
                                 @(24):@[@"4",@"",@""]
                                 };
        
        self.cookingTimes =
        @{
          @140:@{
                  @0.25:    @[@24,@0,@36,@0],
                  @0.5:     @[@24,@0,@36,@0],
                  @0.75:    @[@24,@0,@36,@0],
                  @1:       @[@24,@0,@36,@0],
                  @1.25:    @[@24,@0,@36,@0],
                  @1.5:     @[@24,@0,@36,@0],
                  @1.75:    @[@24,@0,@36,@0],
                  @2:       @[@24,@0,@36,@0],
                  @2.25:    @[@24,@0,@36,@0],
                  @2.5:     @[@24,@0,@36,@0],
                  @2.75:    @[@24,@0,@36,@0],
                  @3:       @[@24,@0,@36,@0],
                  @3.25:    @[@24,@0,@36,@0],
                  @3.5:     @[@24,@0,@36,@0],
                  @3.75:    @[@24,@0,@36,@0],
                  @4.0:     @[@24,@0,@36,@0],
                  
                  },
          @160:@{
                  @0.25:    @[@24,@0,@30,@0],
                  @0.5:     @[@24,@0,@30,@0],
                  @0.75:    @[@24,@0,@30,@0],
                  @1:       @[@24,@0,@30,@0],
                  @1.25:    @[@24,@0,@30,@0],
                  @1.5:     @[@24,@0,@30,@0],
                  @1.75:    @[@24,@0,@30,@0],
                  @2:       @[@24,@0,@30,@0],
                  @2.25:    @[@24,@0,@30,@0],
                  @2.5:     @[@24,@0,@30,@0],
                  @2.75:    @[@24,@0,@30,@0],
                  @3:       @[@24,@0,@30,@0],
                  @3.25:    @[@24,@0,@30,@0],
                  @3.5:     @[@24,@0,@30,@0],
                  @3.75:    @[@24,@0,@30,@0],
                  @4.0:     @[@24,@0,@30,@0],
                  
                  },
          };
        
    }
    return self;
    
}
@end