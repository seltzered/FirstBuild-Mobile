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
        _cookTimeElapsed = [aDecoder decodeObjectForKey:@"elapsed_time"];
        _cookingLabel = [aDecoder decodeObjectForKey:@"cook_label"];
        _powerLevel =[aDecoder decodeObjectForKey:@"power_level"];
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
        _cookTimeElapsed = [NSNumber numberWithInt:0];
        _powerLevel = [NSNumber numberWithInt:0];
        _cookingLabel = @"";
    }
    return self;
}

-(void) encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:_targetTemperature forKey:@"target_temp"];
    [aCoder encodeObject:_cookTimeMinimum  forKey:@"min_time"];
    [aCoder encodeObject:_cookTimeMaximum  forKey:@"max_time"];
    [aCoder encodeObject:_cookTimeElapsed forKey:@"elapsed_time"];
    [aCoder encodeObject:_cookingLabel forKey:@"cook_label"];
    [aCoder encodeObject:_powerLevel forKey:@"power_level"];
}
@end
