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
        self.recipeId = [decoder decodeObjectForKey:@"recipeId"];
        self.friendlyName = [decoder decodeObjectForKey:@"friendlyName"];
        self.note = [decoder decodeObjectForKey:@"note"];
        self.ingredients = [decoder decodeObjectForKey:@"ingredients"];
        self.photo = [decoder decodeObjectForKey:@"photo"];
    }
    return self;
}

-(instancetype) init {
    self = [super init];
    if (self) {
        self.photo = [[UIImageView alloc] init];
        self.recipeId = [[NSUUID UUID] UUIDString];
    }
    return self;
}

-(void) encodeWithCoder:(NSCoder*)encoder {
    [encoder encodeObject:self.recipeId forKey:@"recipeId"];
    [encoder encodeObject:self.friendlyName forKey:@"friendlyName"];
    [encoder encodeObject:self.note forKey:@"note"];
    [encoder encodeObject:self.ingredients forKey:@"ingredients"];
    [encoder encodeObject:self.photo forKey:@"photo"];
}

- (FSTParagonCookingStage*) addStage
{
    FSTParagonCookingStage* stage = [[FSTParagonCookingStage alloc] init];
    [self.paragonCookingStages addObject:stage];
    return stage;
}

@end
