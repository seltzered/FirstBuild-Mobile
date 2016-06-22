//
//  FSTOpalScheduleViewController.h
//  FirstBuild
//
//  Created by Gina on 6/14/16.
//  Copyright © 2016 FirstBuild. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FSTOpal.h"

@interface FSTOpalScheduleViewController : UIViewController  <FSTOpalDelegate>

@property (weak, nonatomic) FSTOpal* opal;

@end
