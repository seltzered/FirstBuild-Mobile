//
//  ProductCollectionViewController.m
//  MobiUs
//
//  Created by Myles Caley on 10/7/14.
//  Copyright (c) 2014 FirstBuild. All rights reserved.
//

#import "ProductCollectionViewController.h"
#import "ProductCollectionViewCell.h"
#import <SWRevealViewController.h>
#import <RBStoryboardLink.h>
#import "FirebaseShared.h"
#import "FSTChillHub.h"
#import "FSTParagon.h"
#import "ChillHubViewController.h"
#import "MobiNavigationController.h"
#import "FSTCookingMethodViewController.h"
#import "FSTBleCentralManager.h"

@interface ProductCollectionViewController ()

@end

@implementation ProductCollectionViewController

static NSString * const reuseIdentifier = @"ProductCell";
static NSString * const reuseIdentifierParagon = @"ProductCellParagon";

- (void)viewDidLoad {
    [super viewDidLoad];
    self.products = [[NSMutableArray alloc] init];
   
    //[self configureFirebaseDevices];
    [self configureBleDevices];
    
    FSTParagon* paragon = [FSTParagon new];
    [self.products addObject:paragon];
    
    self.collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
}

-(void)configureBleDevices
{
    [FSTBleCentralManager sharedInstance];
}

-(void)configureFirebaseDevices
{
    //TODO: support multiple device types
    Firebase *chillhubsRef = [[[FirebaseShared sharedInstance] userBaseReference] childByAppendingPath:@"devices/chillhubs"];
    [chillhubsRef removeAllObservers];
    
    [chillhubsRef observeEventType:FEventTypeChildAdded withBlock:^(FDataSnapshot *snapshot) {
        FSTChillHub* chillhub = [FSTChillHub new];
        chillhub.firebaseRef = snapshot.ref ;
        chillhub.identifier = snapshot.key;
        id rawVal = snapshot.value;
        if (rawVal != [NSNull null])
        {
            NSDictionary* val = rawVal;
            if ( [(NSString*)[val objectForKey:@"status"] isEqualToString:@"connected"] )
            {
                chillhub.online = YES;
            }
            else
            {
                chillhub.online = NO;
            }
            [self.productCollection reloadData];
        }
        
        [self.products addObject:chillhub];
        [self.productCollection reloadData];
    }];
    
    [chillhubsRef observeEventType:FEventTypeChildRemoved withBlock:^(FDataSnapshot *snapshot) {
        for (long i=self.products.count-1; i>-1; i--)
        {
            FSTChillHub *chillhub = [self.products objectAtIndex:i];
            if ([chillhub.identifier isEqualToString:snapshot.key])
            {
                [self.products removeObject:chillhub];
                [self.productCollection reloadData];
                break;
            }
        }
        if (self.products.count == 0)
        {
            [self.delegate noItemsInCollection];
        }
    }];
    
    [chillhubsRef observeEventType:FEventTypeChildChanged withBlock:^(FDataSnapshot *snapshot) {
        for (long i=self.products.count-1; i>-1; i--)
        {
            FSTChillHub *chillhub = [self.products objectAtIndex:i];
            if ([chillhub.identifier isEqualToString:snapshot.key])
            {
                id rawVal = snapshot.value;
                if (rawVal != [NSNull null])
                {
                    NSDictionary* val = rawVal;
                    if ( [(NSString*)[val objectForKey:@"status"] isEqualToString:@"connected"] )
                    {
                        chillhub.online = YES;
                    }
                    else
                    {
                        chillhub.online = NO;
                    }
                    [self.productCollection reloadData];
                }
                break;
            }
        }
    }];
}

-(void)viewWillAppear:(BOOL)animated
{
    [self.collectionView.collectionViewLayout invalidateLayout];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) prepareForSegue: (UIStoryboardSegue *) segue sender: (id) sender
{
    RBStoryboardLink *destination = segue.destinationViewController;
    
    if ([sender isKindOfClass:[FSTParagon class]])
    {
        if ([destination.scene isKindOfClass:[FSTCookingMethodViewController class]])
        {
            FSTCookingMethodViewController *vc = (FSTCookingMethodViewController*)destination.scene;
            vc.product = sender;
        }
    }
    else if ([sender isKindOfClass:[FSTChillHub class]])
    {
        ChillHubViewController *vc = (ChillHubViewController*)destination.scene;
        vc.product = sender;
    }
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {

    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.products.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    
    FSTProduct * product = self.products[indexPath.row];
    ProductCollectionViewCell *productCell;
    
    if ([product isKindOfClass:[FSTChillHub class]])
    {
        productCell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    }
    else if ([product isKindOfClass:[FSTParagon class]])
    {
        //TODO: temp code...
        product.online = YES;
        productCell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifierParagon forIndexPath:indexPath];
    }
    
    if (product.online)
    {
        productCell.userInteractionEnabled = YES;
        productCell.disabledView.hidden = YES;
        productCell.arrowButton.hidden = NO;
    }
    else
    {
        productCell.userInteractionEnabled = NO;
        productCell.disabledView.hidden = NO;
        productCell.arrowButton.hidden = YES;
    }
    
    return productCell;
}

#pragma mark <UICollectionViewDelegate>

- (void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    FSTProduct * product = self.products[indexPath.row];
    NSLog(@"selected %@", product.identifier);
    
    if ([product isKindOfClass:[FSTChillHub class]])
    {
        [self performSegueWithIdentifier:@"segueChillHub" sender:product];
    }
    if ([product isKindOfClass:[FSTParagon class]])
    {
        [self performSegueWithIdentifier:@"segueParagon" sender:product];
    }
}

-(void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    [self.collectionView.collectionViewLayout invalidateLayout];
}

- (CGSize) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake([[UIScreen mainScreen] bounds].size.width, 150);
}

- (UIEdgeInsets) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

@end
