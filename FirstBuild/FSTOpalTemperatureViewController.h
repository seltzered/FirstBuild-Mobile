//
//  FSTOpalTemperatureViewController.h
//  FirstBuild
//
//  Created by Myles Caley on 5/23/16.
//  Copyright © 2016 FirstBuild. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BEMSimpleLineGraphView.h"
#import "FSTOpal.h"

@interface FSTOpalTemperatureViewController : UIViewController <FSTOpalDelegate, BEMSimpleLineGraphDataSource, BEMSimpleLineGraphDelegate>

@property (nonatomic, strong) FSTOpal* opal;

@end
