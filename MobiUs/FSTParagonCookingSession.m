//
//  FSTParagonCookingSession.m
//  FirstBuild
//
//  Created by Myles Caley on 6/2/15.
//  Copyright (c) 2015 FirstBuild. All rights reserved.
//

#import "FSTParagonCookingSession.h"

@implementation FSTParagonCookingSession

-(id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        self.paragonCookingStages = [aDecoder decodeObjectForKey:@"Stages"];
    }
    return self;
}
-(instancetype)init
{
    self = [super init];
    if (self) {
        self.paragonCookingStages = [[NSMutableArray alloc]init];
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.paragonCookingStages forKey:@"Stages"];
}
@end
