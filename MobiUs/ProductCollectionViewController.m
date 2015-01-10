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
#import <ActionSheetStringPicker.h>
#import <RBStoryboardLink.h>
#import "FirebaseShared.h"
#import "FSTChillHub.h"
#import "ChillHubViewController.h"
#import "MobiNavigationController.h"

@interface ProductCollectionViewController ()

@end

@implementation ProductCollectionViewController

static NSString * const reuseIdentifier = @"ProductCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    self.products = [[NSMutableArray alloc] init];
   
    //TODO: support multiple device types
    Firebase *chillhubsAddRef = [[[FirebaseShared sharedInstance] userBaseReference] childByAppendingPath:@"devices/chillhubs"];
    [chillhubsAddRef observeEventType:FEventTypeChildAdded withBlock:^(FDataSnapshot *snapshot) {
                FSTChillHub* chillhub = [FSTChillHub new];
                chillhub.firebaseRef = snapshot.ref ;
                chillhub.identifier = snapshot.key;
                chillhub.friendlyName = @"My ChillHub";
                [self.products addObject:chillhub];
                [self.productCollection reloadData];
    }];
    
    Firebase *chillhubsRemRef = [[[FirebaseShared sharedInstance] userBaseReference] childByAppendingPath:@"devices/chillhubs"];
    [chillhubsRemRef observeEventType:FEventTypeChildRemoved withBlock:^(FDataSnapshot *snapshot) {
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
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) prepareForSegue: (UIStoryboardSegue *) segue sender: (id) sender
{
    //TODO: support other products
    RBStoryboardLink *destination = segue.destinationViewController;
    MobiNavigationController *rvc = (MobiNavigationController *)destination.scene;
    ChillHubViewController *vc = (ChillHubViewController*)rvc.topViewController;
    vc.product = sender;
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {

    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.products.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    ProductCollectionViewCell *productCell =
        [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];

    productCell.layer.cornerRadius = 10;
    productCell.layer.masksToBounds = YES;
 
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

}
/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/

@end
