//
//  FSTBeefSteaksSousVideRecipe.m
//  FirstBuild
//
//  Created by John Nolan on 11/16/15.
//  Copyright © 2015 FirstBuild. All rights reserved.
//

#import "FSTBeefSteaksSousVideRecipe.h"

@implementation FSTBeefSteaksSousVideRecipe

- (id) init {
    
    self = [super init];
    
    if (self) {
        self.name = @"Beef Steak";
        
        // three possible temperatures
        // (anything below medium not recommended)
        self.donenesses = @[@140, @150, @158];
        
        // dictionary that references medium through well
        self.donenessLabels = @{@140: @"Medium",
                                @150: @"Medium-Well",
                                @158: @"Well"};
        
        // only have data for medium at the moment (this will probably cause a problem when we try to access it, so I will fill the others in with the same time)
        self.cookingTimes = @{
                              // for 140 degrees
                              @140: @{@(0.25):@[@3, @0, @6, @0],
                                        @(0.5):@[@3, @0, @6, @0],
                                        @(0.75):@[@3, @0, @6, @0],
                                        @(1):@[@4, @0, @8, @0],
                                        @(1.25):@[@4, @0, @8, @0],
                                        @(1.5):@[@6, @0, @10, @0],
                                        @(1.75):@[@6, @0, @10, @0],
                                        @(2):@[@6, @0, @10, @0]},
                              
                              // 150 degrees
                              @150: @{@(0.25):@[@3, @0, @6, @0],
                                      @(0.5):@[@3, @0, @6, @0],
                                      @(0.75):@[@3, @0, @6, @0],
                                      @(1):@[@4, @0, @8, @0],
                                      @(1.25):@[@4, @0, @8, @0],
                                      @(1.5):@[@6, @0, @10, @0],
                                      @(1.75):@[@6, @0, @10, @0],
                                      @(2):@[@6, @0, @10, @0]},
                              
                              // 158 degrees
                              @158: @{@(0.25):@[@3, @0, @6, @0],
                                      @(0.5):@[@3, @0, @6, @0],
                                      @(0.75):@[@3, @0, @6, @0],
                                      @(1):@[@4, @0, @8, @0],
                                      @(1.25):@[@4, @0, @8, @0],
                                      @(1.5):@[@6, @0, @10, @0],
                                      @(1.75):@[@6, @0, @10, @0],
                                      @(2):@[@6, @0, @10, @0]}};
        
    } // end if self
    
    return self;

}

@end
