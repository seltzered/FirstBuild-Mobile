//
//  ProductTableViewController.h
//  FirstBuild-Mobile
//
//  Created by Myles Caley on 10/7/14.
//  Copyright (c) 2014 FirstBuild. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ProductTableViewDelegate <NSObject>

@required

- (void) itemCountChanged: (NSUInteger)count;

@end

@interface ProductTableViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate>
@property (weak) id <ProductTableViewDelegate> delegate;
@property (strong, nonatomic) IBOutlet UITableView *productTable;
@property (strong, nonatomic) NSMutableArray *products;
@property (strong, nonatomic) IBOutlet UISwipeGestureRecognizer *swipeLeftGesture;


@end
