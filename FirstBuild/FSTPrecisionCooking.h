//
//  FSTPrecisionCooking.h
//  FirstBuild
//
//  Created by Myles Caley on 9/25/15.
//  Copyright © 2015 FirstBuild. All rights reserved.
//

#ifndef FSTPrecisionCooking_h
#define FSTPrecisionCooking_h

//these are the master states for the application
typedef enum {
    
    //off
    FSTCookingStateOff = 0, //done
    
    //precision cooking
    FSTCookingStatePrecisionCookingReachingTemperature = 1, //done
    FSTCookingStatePrecisionCookingTemperatureReached = 2,
    FSTCookingStatePrecisionCookingReachingMinTime = 4,
    FSTCookingStatePrecisionCookingReachingMaxTime = 5,
    FSTCookingStatePrecisionCookingPastMaxTime = 6,
    FSTCookingStatePrecisionCookingWithoutTime = 7,
    FSTCookingStatePrecisionCookingCurrentStageDone = 8,
    
    //direct cooking
    FSTCookingDirectCooking,
    FSTCookingDirectCookingWithTime,
    
    //unknown
    FSTCookingStateUnknown
    
} ParagonCookMode;



#endif /* FSTPrecisionCooking_h */
