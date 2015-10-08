//
//  FSTReadyToReachTemperatureViewController.h
//  FirstBuild
//
//  Created by Myles Caley on 5/12/15.
//  Copyright (c) 2015 FirstBuild. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FSTParagon.h"

@interface FSTReadyToReachTemperatureViewController : UIViewController <FSTParagonDelegate>

@property (nonatomic,weak) FSTParagon* currentParagon;

@end
