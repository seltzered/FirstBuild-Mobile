//
//  FSTCookingMethod.h
//  FirstBuild
//
//  Created by Myles Caley on 5/13/15.
//  Copyright (c) 2015 FirstBuild. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FSTParagonCookingSession.h"

@interface FSTCookingMethod : NSObject <NSCoding>

@property (nonatomic, retain) NSString* name;
@property (nonatomic, retain) FSTParagonCookingSession* session;

- (FSTParagonCookingSession*) createCookingSession;
- (FSTParagonCookingStage*) addStageToCookingSession;

@end
