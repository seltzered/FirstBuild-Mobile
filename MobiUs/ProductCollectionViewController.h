//
//  ProductCollectionViewController.h
//  MobiUs
//
//  Created by Myles Caley on 10/7/14.
//  Copyright (c) 2014 FirstBuild. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ProductCollectionViewDelegate <NSObject>

@required

- (void) noItemsInCollection;

@end

@interface ProductCollectionViewController : UICollectionViewController <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UIAlertViewDelegate>
@property (weak) id <ProductCollectionViewDelegate> delegate;
@property (strong, nonatomic) IBOutlet UICollectionView *productCollection;
@property (strong, nonatomic) NSMutableArray *products;
@property (strong, nonatomic) IBOutlet UISwipeGestureRecognizer *swipeLeftGesture;

@end
