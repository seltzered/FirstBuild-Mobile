//
//  FSTRecipe.m
//  FirstBuild
//
//  Created by John Nolan on 8/13/15.
//  Copyright (c) 2015 FirstBuild. All rights reserved.
//

#import "FSTRecipe.h"

@implementation FSTRecipe

-(id) initWithCoder:(NSCoder *)decoder {
    if (self = [super init]) {
        self.name = [decoder decodeObjectForKey:@"name"];
        self.note = [decoder decodeObjectForKey:@"note"];
        self.method = [decoder decodeObjectForKey:@"method"];
        self.photo = [decoder decodeObjectForKey:@"photo"];
    }
    return self;
}

-(instancetype) init {
    self = [super init];
    if (self) {
        self.photo = [[UIImageView alloc] init];
        self.method = [[FSTCookingMethod alloc] init];
    }
    return self;
}

-(void) encodeWithCoder:(NSCoder*)encoder {
    [encoder encodeObject:self.name forKey:@"name"];
    [encoder encodeObject:self.note forKey:@"note"];
    [encoder encodeObject:self.method forKey:@"method"]; // this session will need its own coder
    [encoder encodeObject:self.photo forKey:@"photo"];
}

@end
