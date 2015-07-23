//
//  ProductTableViewCell.h
//  MobiUs
//
//  Created by Myles Caley on 10/7/14.
//  Copyright (c) 2014 FirstBuild. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProductBatteryView.h"

@interface ProductTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIView *mainView;
@property (strong, nonatomic) IBOutlet UIImageView *arrowButton;
@property (strong, nonatomic) IBOutlet UILabel *offlineLabel;
@property (strong, nonatomic) IBOutlet UIView *disabledView;
@property (strong, nonatomic) IBOutlet UILabel *friendlyName;
@property (strong, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UILabel *batteryLabel;
@property (weak, nonatomic) IBOutlet ProductBatteryView *batteryView;
@property (weak, nonatomic) IBOutlet UILabel *paragonStatusLabel;

@end
