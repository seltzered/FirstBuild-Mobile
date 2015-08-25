//
//  FSTParagonCookingSession.h
//  FirstBuild
//
//  Created by Myles Caley on 6/2/15.
//  Copyright (c) 2015 FirstBuild. All rights reserved.
//

#import "FSTRecipe.h"

@interface FSTParagonCookingSession : NSObject

@property (nonatomic, strong) FSTRecipe* activeRecipe;
@property (nonatomic, strong) FSTRecipe* toBeRecipe;

@property (nonatomic) int currentStage;

@end
