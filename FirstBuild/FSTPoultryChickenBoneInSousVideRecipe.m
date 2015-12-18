//
//  FSTPoultryChickenBoneInSousVideRecipe.m
//  FirstBuild
//
//  Created by Myles Caley on 12/18/15.
//  Copyright © 2015 FirstBuild. All rights reserved.
//

#import "FSTPoultryChickenBoneInSousVideRecipe.h"

@implementation FSTPoultryChickenBoneInSousVideRecipe
- (id) init
{
    self = [super init];
    if (self)
    {
        self.name = @"Breast (bone-in)";
        
        self.donenesses = @[@140,
                            @150,
                            @165,
                            ];
        
        self.donenessLabels = @{@140:@"Medium",
                                @150:@"Medium-Well",
                                @165:@"Well",
                                };
        
        self.thicknesses = @[
                             @(1.5),
                             @(1.75),
                             @(2)
                             ];
        
        self.thicknessLabels = @{
                                 @(1.5):@[@"1",@"1",@"2"],
                                 @(1.75):@[@"1",@"3",@"4"],
                                 @(2):@[@"2",@"",@""]
                                 };
        
        self.cookingTimes =
        @{
          @140:@{
                  @1.5:     @[@3,@30,@5,@0],
                  @1.75:    @[@3,@30,@5,@0],
                  @2:       @[@3,@30,@5,@0],
                  },
          @150:@{
                  @1.5:     @[@3,@15,@5,@0],
                  @1.75:    @[@3,@15,@5,@0],
                  @2:       @[@3,@15,@5,@0],
                  },
          @165:@{
                  @1.5:     @[@2,@0,@5,@0],
                  @1.75:    @[@2,@0,@5,@0],
                  @2:       @[@2,@0,@5,@0],
                  },
          };
        
    }
    return self;
    
}
@end
