//
//  BeerBankViewController.h
//  FirstBuild
//
//  Created by Myles Caley on 5/4/15.
//  Copyright (c) 2015 FirstBuild. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "FSTBeerBank.h"

@interface BeerBankViewController : UIViewController
@property (strong, nonatomic) FSTBeerBank *beerBank;
@property (strong, nonatomic) IBOutlet UISwitch *alarmSetButton;

@end
