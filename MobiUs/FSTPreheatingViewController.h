//
//  FSTPreheatingViewController.h
//  FirstBuild
//
//  Created by Myles Caley on 5/12/15.
//  Copyright (c) 2015 FirstBuild. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FSTCookingMethod.h"

@interface FSTPreheatingViewController : UIViewController

@property (nonatomic,retain) FSTCookingMethod* cookingMethod;
@property (strong, nonatomic) IBOutlet UILabel *currentTemperatureLabel;
@property (strong, nonatomic) IBOutlet UILabel *targetTemperatureLabel;
@end
