//
//  FSTRecipe.h
//  FirstBuild
//
//  Created by John Nolan on 8/13/15.
//  Copyright (c) 2015 FirstBuild. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FSTParagonCookingSession.h"

@interface FSTRecipe : NSObject <NSCoding>

// name provided by user
@property (nonatomic, strong) NSMutableString* friendlyName;

//@property (nonatomic, strong) FSTCookingMethod* method; // contains all the information provided in custom settings

@property (nonatomic, strong) NSString* recipeId;

@property (nonatomic, strong) NSMutableString* note;

@property (nonatomic, strong) NSMutableString* ingredients;

@property (nonatomic, strong) UIImageView* photo; // photo taken of the user's meal (will use UIImagePickerController. need UIImageView to serialize, can take the UIImage property later




@property (nonatomic, retain) NSString* name;
@property (nonatomic, retain) FSTParagonCookingSession* session;

- (FSTParagonCookingSession*) createCookingSession;
- (FSTParagonCookingStage*) addStageToCookingSession;

@end
