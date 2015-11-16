//
//  FSTBeefSteaksToughCutsSousVideRecipe.m
//  FirstBuild
//
//  Created by John Nolan on 11/16/15.
//  Copyright © 2015 FirstBuild. All rights reserved.
//

#import "FSTBeefSteaksToughCutsSousVideRecipe.h"

@implementation FSTBeefSteaksToughCutsSousVideRecipe

- (id) init {
    
    self = [super init];
    
    if (self) {
        self.name = @"Steak Tough Cut";
        
        self.donenesses = @[@130,
                            @140,
                            @150,
                            @160,
                            @175];
        
        self.donenessLabels = @{@130: @"Medium-Rare",
                                @140: @"Medium",
                                @150: @"Medium-Well",
                                @160: @"Well",
                                @175: @"Well"};
        
        self.cookingTimes = @{
                              // dictionary of the hour and minutes for each thickness
                              // for each temperature
                              // medium-rare times
                              @130: @{
                                      @(0.25):@[@6, @0, @12, @0],
                                      @(0.5):@[@6, @0, @12, @0],
                                      @(0.75):@[@6, @0, @12, @0],
                                      @(1):@[@8, @0, @24, @0],
                                      @(1.25):@[@8, @0, @24, @0],
                                      @(1.5):@[@12, @0, @30, @0],
                                      @(1.75):@[@12, @0, @30, @0],
                                      @(2):@[@12, @0, @30, @0]
                                      },
                              
                              // medium
                              @140: @{
                                      @(0.25):@[@6, @0, @12, @0],
                                      @(0.5):@[@6, @0, @12, @0],
                                      @(0.75):@[@6, @0, @12, @0],
                                      @(1):@[@8, @0, @24, @0],
                                      @(1.25):@[@8, @0, @24, @0],
                                      @(1.5):@[@12, @0, @30, @0],
                                      @(1.75):@[@12, @0, @30, @0],
                                      @(2):@[@12, @0, @30, @0]
                                      },
                              
                              // medium-well
                              @150: @{
                                      @(0.25):@[@6, @0, @12, @0],
                                      @(0.5):@[@6, @0, @12, @0],
                                      @(0.75):@[@6, @0, @12, @0],
                                      @(1):@[@8, @0, @24, @0],
                                      @(1.25):@[@8, @0, @24, @0],
                                      @(1.5):@[@12, @0, @30, @0],
                                      @(1.75):@[@12, @0, @30, @0],
                                      @(2):@[@12, @0, @30, @0]
                                      },
                              
                              // well
                              @160: @{
                                      @(0.25):@[@4, @0, @6, @0],
                                      @(0.5):@[@4, @0, @6, @0],
                                      @(0.75):@[@4, @0, @6, @0],
                                      @(1):@[@6, @0, @10, @0],
                                      @(1.25):@[@6, @0, @10, @0],
                                      @(1.5):@[@8, @0, @12, @0],
                                      @(1.75):@[@8, @0, @12, @0],
                                      @(2):@[@8, @0, @12, @0]
                                      },
                              
                              // also well
                              // I made all of the times 10 and 14 since that
                              // was the only data available
                              @175: @{
                                      @(0.25):@[@10, @0, @14, @0],
                                      @(0.5):@[@10, @0, @14, @0],
                                      @(0.75):@[@10, @0, @14, @0],
                                      @(1):@[@10, @0, @14, @0],
                                      @(1.25):@[@10, @0, @14, @0],
                                      @(1.5):@[@10, @0, @14, @0],
                                      @(1.75):@[@10, @0, @14, @0],
                                      @(2):@[@10, @0, @14, @0]
                                      }}; // end cook-times dictionary
    } // end if self
    
    return self;
    
}
@end
