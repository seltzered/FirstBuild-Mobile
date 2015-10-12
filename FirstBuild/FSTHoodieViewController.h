//
//  FSTHoodieViewController.h
//  FirstBuild
//
//  Created by Myles Caley on 10/5/15.
//  Copyright © 2015 FirstBuild. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FSTHoodie.h"

@interface FSTHoodieViewController : UIViewController <FSTHoodieDelegate>
@property (weak, nonatomic) FSTHoodie* hoodie;
@end
