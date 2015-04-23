//
//  LedgeViewController.h
//  FirstBuild
//
//  Created by Myles Caley on 4/22/15.
//  Copyright (c) 2015 FirstBuild. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "FSTLedge.h"

@interface LedgeViewController : UIViewController

@property (strong, nonatomic) FSTLedge *ledge;

@property (strong, nonatomic) IBOutlet UISlider *sliderR;

@property (strong, nonatomic) IBOutlet UISlider *sliderG;

@property (strong, nonatomic) IBOutlet UISlider *sliderB;

@end
