//
//  FSTOpalDiagnosticsViewController.h
//  FirstBuild
//
//  Created by Myles Caley on 4/27/16.
//  Copyright © 2016 FirstBuild. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FSTOpal.h"

@interface FSTOpalDiagnosticsViewController : UIViewController <FSTOpalDelegate>

@property (nonatomic, strong) FSTOpal* currentOpal;

@end
