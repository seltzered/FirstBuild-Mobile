//
//  FSTParagonCookingStage.m
//  FirstBuild
//
//  Created by Myles Caley on 6/2/15.
//  Copyright (c) 2015 FirstBuild. All rights reserved.
//

#import "FSTParagonCookingStage.h"

@implementation FSTParagonCookingStage

- (id) initWithCoder:(NSCoder *)aDecoder {
    
    if (self = [super init]) {
        _targetTemperature = [aDecoder decodeObjectForKey:@"target_temp"];
        _cookTimeMinimum = [aDecoder decodeObjectForKey:@"min_time"];
        _cookTimeMaximum = [aDecoder decodeObjectForKey:@"max_time"];
        _cookingLabel = [aDecoder decodeObjectForKey:@"cook_label"];
        _maxPowerLevel =[aDecoder decodeObjectForKey:@"power_level"];
        _automaticTransition = [aDecoder decodeObjectForKey:@"automatic_transition"];
    }
    
    return self;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        _targetTemperature = [NSNumber numberWithInt:0];
        _cookTimeMinimum = [NSNumber numberWithInt:0];
        _cookTimeMaximum = [NSNumber numberWithInt:0];
        _maxPowerLevel = [NSNumber numberWithInt:5];
        _cookingLabel = @"";
        _automaticTransition = [NSNumber numberWithBool:NO];
    }
    return self;
}

-(void) encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:_targetTemperature forKey:@"target_temp"];
    [aCoder encodeObject:_cookTimeMinimum  forKey:@"min_time"];
    [aCoder encodeObject:_cookTimeMaximum  forKey:@"max_time"];
    [aCoder encodeObject:_cookingLabel forKey:@"cook_label"];
    [aCoder encodeObject:_maxPowerLevel forKey:@"power_level"];
    [aCoder encodeObject:_automaticTransition forKey:@"automatic_transition"];
}
@end
