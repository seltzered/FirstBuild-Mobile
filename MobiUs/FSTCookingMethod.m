//
//  FSTCookingMethod.m
//  FirstBuild
//
//  Created by Myles Caley on 5/13/15.
//  Copyright (c) 2015 FirstBuild. All rights reserved.
//

#import "FSTCookingMethod.h"

@implementation FSTCookingMethod

-(id) initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        self.session = [aDecoder decodeObjectForKey:@"session"];
    }
    return self;
}
-(id) init
{
    self = [super init];
    return self;
}

- (FSTParagonCookingSession*) createCookingSession
{
    self.session = [[FSTParagonCookingSession alloc] init];
    return self.session;
}

- (FSTParagonCookingStage*) addStageToCookingSession
{
    FSTParagonCookingStage* stage = [[FSTParagonCookingStage alloc] init];
    [self.session.paragonCookingStages addObject:stage];
    return stage;
}
-(void) encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.session forKey:@"session"];
}
@end
