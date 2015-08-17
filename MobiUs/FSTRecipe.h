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

@property (nonatomic, strong) FSTParagonCookingSession* session; // contains all the information provided in custom settings

@property (nonatomic, strong) NSMutableString* name; // name provided by user

@property (nonatomic, strong) NSMutableString* note;

@property (nonatomic, strong) UIImageView* photo; // photo taken of the user's meal (will use UIImagePickerController. need UIImageView to serialize, can take the UIImage property later

@end
