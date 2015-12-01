//
//  FSTParagonUserInformation.m
//  FirstBuild
//
//  Created by Myles Caley on 12/1/15.
//  Copyright © 2015 FirstBuild. All rights reserved.
//

#import "FSTParagonUserInformation.h"

@implementation FSTParagonUserInformation

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.recipeId = 0;
        self.recipeType = 0;
    }
    return self;
}
@end
