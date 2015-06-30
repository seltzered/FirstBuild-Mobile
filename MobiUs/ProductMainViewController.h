//
//  ProductMainViewController.h
//  MobiUs
//
//  Created by Myles Caley on 12/17/14.
//  Copyright (c) 2014 FirstBuild. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SWRevealViewController.h>

#import "ProductCollectionViewController.h"
#import "FSTParagonDisconnectedLabel.h"

@interface ProductMainViewController : UIViewController <ProductCollectionViewDelegate, FSTParagonDisconnectedLabelDelegate>

@property (strong, nonatomic) IBOutlet UIView *noProductsView;
@property (strong, nonatomic) IBOutlet UIView *productsCollectionView;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *loadingIndicator;
@property (strong, nonatomic) IBOutlet UIImageView *teardropImage;

@end
