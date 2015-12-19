//
//  FSTRecipeCompleteViewController.h
//  FirstBuild
//
//  Created by Myles Caley on 12/19/15.
//  Copyright © 2015 FirstBuild. All rights reserved.
//

#import "FSTCookingStateViewController.h"

@interface FSTRecipeCompleteViewController : FSTCookingStateViewController <FSTParagonDelegate>
@property (nonatomic,weak) FSTParagon* currentParagon;

@end
