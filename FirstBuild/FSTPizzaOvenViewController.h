//
//  FSTPizzaOvenViewController.h
//  FirstBuild
//
//  Created by Myles Caley on 10/5/15.
//  Copyright © 2015 FirstBuild. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FSTPizzaOven.h"

@interface FSTPizzaOvenViewController : UIViewController <FSTPizzaOvenDelegate>
@property (weak, nonatomic) FSTPizzaOven* oven;
@end
