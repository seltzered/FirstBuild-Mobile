//
//  ProductTableViewCell.h
//  MobiUs
//
//  Created by Myles Caley on 10/7/14.
//  Copyright (c) 2014 FirstBuild. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProductTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIView *mainView;
@property (strong, nonatomic) IBOutlet UIImageView *arrowButton;
@property (strong, nonatomic) IBOutlet UILabel *offlineLabel;
@property (strong, nonatomic) IBOutlet UIView *disabledView;
@property (strong, nonatomic) IBOutlet UILabel *friendlyName;
@property (strong, nonatomic) IBOutlet UILabel *statusLabel;

@end
