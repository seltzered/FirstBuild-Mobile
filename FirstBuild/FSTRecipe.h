//
//  FSTRecipe.h
//  FirstBuild
//
//  Created by John Nolan on 8/13/15.
//  Copyright (c) 2015 FirstBuild. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FSTParagonCookingStage.h"

typedef enum {
    FSTRecipeTypeUndefined = 0,
    FSTRecipeTypeFirstBuildSousVide = 1,
//    FSTRecipeTypeFirstBuildSingleStage = 2,
    FSTRecipeTypeFirstBuildMultiStage = 3,
//    FSTRecipeTypeUserSousVide = 4,
//    FSTRecipeTypeUserSingleStage = 5,
//    FSTRecipeTypeUserMultiStage = 6
} RecipeType;

@interface FSTRecipe : NSObject <NSCoding>

// name provided by user
@property (nonatomic, strong) NSMutableString* friendlyName;
@property (nonatomic, strong) NSNumber* recipeId;
@property (nonatomic, strong) NSMutableString* note;
@property (nonatomic, strong) NSMutableString* ingredients;
@property (nonatomic, strong) UIImageView* photo;
@property (nonatomic, retain) NSString* name;
@property (nonatomic, strong) NSMutableArray* paragonCookingStages;
@property (nonatomic, strong) NSNumber* recipeType;

- (FSTParagonCookingStage*) addStage;



@end
