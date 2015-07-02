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
#import "FSTCookingViewController.h"

@interface ProductCollectionViewController ()

@end

@implementation ProductCollectionViewController

#pragma mark - Private

static NSString * const reuseIdentifier = @"ProductCell";
static NSString * const reuseIdentifierParagon = @"ProductCellParagon";
NSObject* _connectedToBleObserver;
NSObject* _deviceConnectedObserver;
NSObject* _newDeviceBoundObserver;
NSObject* _deviceRenamedObserver;

NSIndexPath *_indexPathForDeletion;

#pragma mark - <UIViewDelegate>
//TODO firebase objects
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.products = [[NSMutableArray alloc] init];
    [self.delegate itemCountChanged:0];
    
    //get all the saved BLE peripherals
    [self configureBleDevices];
    
    self.collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:_connectedToBleObserver];
    [[NSNotificationCenter defaultCenter] removeObserver:_deviceConnectedObserver];
    [[NSNotificationCenter defaultCenter] removeObserver:_newDeviceBoundObserver];
    [[NSNotificationCenter defaultCenter] removeObserver:_deviceRenamedObserver];
}

-(void)viewWillAppear:(BOOL)animated
{
    //[self.collectionView reloadData]; //added by John
    [self.collectionView.collectionViewLayout invalidateLayout];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Device Configuration

//TODO need to store device type so we can have other types of devices
-(void)configureBleDevices
{
    NSDictionary* devices = [[FSTBleCentralManager sharedInstance] getSavedPeripherals];
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    __weak typeof(self) weakSelf = self;
    
    //grab all our saved products and put them in a product array
    for (id key in devices)
    {
        FSTParagon* paragon = [FSTParagon new];
        paragon.online = NO;
        paragon.savedUuid = [[NSUUID alloc]initWithUUIDString:key];
        paragon.friendlyName = [devices objectForKeyedSubscript:key];
        [self.products addObject:paragon];
        [self.delegate itemCountChanged:self.products.count];
    }
    
    //attempt to connect to the BLE devices
    if ([[FSTBleCentralManager sharedInstance] isPoweredOn])
    {
        [self connectBleDevices];
    }
    
    //also listen for power on signal before connecting to devices
    _connectedToBleObserver = [center addObserverForName:FSTBleCentralManagerPoweredOn
                                                  object:nil
                                                   queue:nil
                                              usingBlock:^(NSNotification *notification)
    {
       [weakSelf connectBleDevices];
    }];
    
    
    //when a device is connected check and see if we have it in our products list
    //we may get messages here about devices that are connected that are not saved yet (commissioning)
    //in that case we listen to FSTBleCentralManagerNewDeviceBound
    _deviceConnectedObserver = [center addObserverForName:FSTBleCentralManagerDeviceConnected
                                                   object:nil
                                                    queue:nil
                                               usingBlock:^(NSNotification *notification)
    {
        CBPeripheral* peripheral = (CBPeripheral*)(notification.object);
        
        //search through attached products and mark online anything we already have stored
        for (FSTProduct* product in weakSelf.products)
        {
            if ([product isKindOfClass:[FSTBleProduct class]])
            {
                FSTBleProduct* bleProduct = (FSTBleProduct*)product;
                
                //need to compare the strings and not the actual object since they are not the same
                if ([[bleProduct.savedUuid UUIDString] isEqualToString:[peripheral.identifier UUIDString]])
                {
                    bleProduct.peripheral = peripheral;
                    bleProduct.peripheral.delegate = bleProduct;
                    DLog(@"discovering services for peripheral %@", bleProduct.peripheral.identifier);
                    [bleProduct.peripheral discoverServices:nil];
                    bleProduct.online = YES;
                    [weakSelf.collectionView reloadData];
                }
            }
        }
    }];
    
    //notify us of any new BLE devices that were added
    _newDeviceBoundObserver = [center addObserverForName:FSTBleCentralManagerNewDeviceBound
                                                  object:nil
                                                   queue:nil
                                              usingBlock:^(NSNotification *notification)
    {
        CBPeripheral* peripheral = (CBPeripheral*)(notification.object);
        NSDictionary* latestDevices = [[FSTBleCentralManager sharedInstance] getSavedPeripherals];

        FSTParagon* product = [FSTParagon new]; //TODO type; paragon hardcoded
        product.online = YES;
        product.peripheral = peripheral;
        product.peripheral.delegate = product;
        [product.peripheral discoverServices:nil];
        product.friendlyName = [latestDevices objectForKeyedSubscript:[peripheral.identifier UUIDString]];
        [self.products addObject:(FSTParagon*)product];
        [self.delegate itemCountChanged:self.products.count];
        [weakSelf.collectionView reloadData];
    }];
    
    //notify us of any BLE devices that were renamed
    _deviceRenamedObserver = [center addObserverForName:FSTBleCentralManagerDeviceNameChanged
                                                  object:nil
                                                   queue:nil
                                              usingBlock:^(NSNotification *notification)
    {
        CBPeripheral* peripheral = (CBPeripheral*)(notification.object);
        NSDictionary* latestDevices = [[FSTBleCentralManager sharedInstance] getSavedPeripherals];
        for (FSTProduct* product in weakSelf.products)
        {
            //get all ble products in the local products array
            if ([product isKindOfClass:[FSTBleProduct class]])
            {
                FSTBleProduct* bleProduct = (FSTBleProduct*)product;
                
                //search for ble peripheral that was renamed
                if (bleProduct.peripheral.identifier == peripheral.identifier)
                {
                    //grab it from the saved list
                    bleProduct.friendlyName = [latestDevices objectForKeyedSubscript:[peripheral.identifier UUIDString]];
                    [weakSelf.collectionView reloadData];
                    break;
                }
            }
        }
    }];
    
}

- (void)connectBleDevices
{
    for (FSTProduct* product in self.products)
    {
        if ([product isKindOfClass:[FSTBleProduct class]])
        {
            FSTBleProduct* bleDevice = (FSTBleProduct*)product;
            
            bleDevice.peripheral = [[FSTBleCentralManager sharedInstance] connectToSavedPeripheralWithUUID:bleDevice.savedUuid];
        }
    }
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

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    FSTProduct * product = self.products[indexPath.row];
    ProductCollectionViewCell *productCell;
    
    if ([product isKindOfClass:[FSTChillHub class]])
    {
        productCell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    }
    else if ([product isKindOfClass:[FSTParagon class]])
    {
        
        productCell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifierParagon forIndexPath:indexPath];
        productCell.friendlyName.text = product.friendlyName;
    }
    
    if (product.online)
    {
        //productCell.userInteractionEnabled = YES;
        productCell.disabledView.hidden = YES;
        productCell.arrowButton.hidden = NO;
    }
    else
    {
        //productCell.userInteractionEnabled = NO;
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
    
    if (product.online)
    {
        if ([product isKindOfClass:[FSTChillHub class]])
        {
            [self performSegueWithIdentifier:@"segueChillHub" sender:product];
        }
        if ([product isKindOfClass:[FSTParagon class]])
        {
            FSTParagon* paragon = (FSTParagon*)product;
            
            if (paragon.currentCookMode == kPARAGON_PREHEATING)
            {
                FSTCookingViewController *vc = [[UIStoryboard storyboardWithName:@"FSTParagon" bundle:nil] instantiateViewControllerWithIdentifier:@"FSTPreheatingViewController"];
                vc.currentParagon = paragon;
                [self.navigationController pushViewController:vc animated:YES];
            }
            else if(paragon.currentCookMode == kPARAGON_HEATING)
            {
                FSTCookingViewController *vc = [[UIStoryboard storyboardWithName:@"FSTParagon" bundle:nil] instantiateViewControllerWithIdentifier:@"FSTReadyToCookViewController"];
                vc.currentParagon = paragon;
                [self.navigationController pushViewController:vc animated:YES];
            }
            else if(paragon.currentCookMode == kPARAGON_HEATING_WITH_TIME)
            {
                FSTCookingViewController *vc = [[UIStoryboard storyboardWithName:@"FSTParagon" bundle:nil] instantiateViewControllerWithIdentifier:@"FSTReadyToCookViewController"];
                vc.currentParagon = paragon;
                [self.navigationController pushViewController:vc animated:YES];
            }
            else
            {
                [self performSegueWithIdentifier:@"segueParagon" sender:product];
            }
        }
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

#pragma mark - Gestures

- (IBAction)swipeLeft:(UIGestureRecognizer*)gestureRecognizer
{
    CGPoint tapLocation = [gestureRecognizer locationInView:self.collectionView];
    _indexPathForDeletion = [self.collectionView indexPathForItemAtPoint:tapLocation];

    if(gestureRecognizer.state == UIGestureRecognizerStateEnded && _indexPathForDeletion)
    {
        DLog(@"deleting item at location %ld", (long)_indexPathForDeletion.item);
        UIAlertView *deleteAlert = [[UIAlertView alloc]
                                    initWithTitle:@"Delete?"
                                    message:@"Are you sure you want to delete this device?"
                                    delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Yes", nil];
        [deleteAlert show];
    }
}

#pragma mark - <UIAlertViewDelegate>

//TODO assumes delete alertview
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"selected button index = %ld", buttonIndex);
    if (buttonIndex == 1)
    {
        NSLog(@"delete");
        FSTParagon * deletedItem = self.products[_indexPathForDeletion.item];
        [self.products removeObjectAtIndex:_indexPathForDeletion.item];
        [[FSTBleCentralManager sharedInstance] deleteSavedPeripheralWithUUIDString: [deletedItem.peripheral.identifier UUIDString]]; // hopefully identifier is a UUID String
        [self.collectionView reloadData];
        
        if (self.products.count==0)
        {
            [self.delegate itemCountChanged:0];
        }
    }
}

#pragma mark - BONEYARD

//-(void)configureFirebaseDevices
//{
//    //TODO: support multiple device types
//    Firebase *chillhubsRef = [[[FirebaseShared sharedInstance] userBaseReference] childByAppendingPath:@"devices/chillhubs"];
//    [chillhubsRef removeAllObservers];
//    
//    //device added
//    [chillhubsRef observeEventType:FEventTypeChildAdded withBlock:^(FDataSnapshot *snapshot) {
//        FSTChillHub* chillhub = [FSTChillHub new];
//        chillhub.firebaseRef = snapshot.ref ;
//        chillhub.identifier = snapshot.key;
//        id rawVal = snapshot.value;
//        if (rawVal != [NSNull null])
//        {
//            NSDictionary* val = rawVal;
//            if ( [(NSString*)[val objectForKey:@"status"] isEqualToString:@"connected"] )
//            {
//                chillhub.online = YES;
//            }
//            else
//            {
//                chillhub.online = NO;
//            }
//            [self.productCollection reloadData];
//        }
//        
//        [self.products addObject:chillhub];
//        [self.productCollection reloadData];
//        [self.delegate itemCountChanged:self.products.count];
//    }];
//    
//    //device removed
//    [chillhubsRef observeEventType:FEventTypeChildRemoved withBlock:^(FDataSnapshot *snapshot) {
//        for (long i=self.products.count-1; i>-1; i--)
//        {
//            FSTChillHub *chillhub = [self.products objectAtIndex:i];
//            if ([chillhub.identifier isEqualToString:snapshot.key])
//            {
//                [self.products removeObject:chillhub];
//                [self.productCollection reloadData];
//                break;
//            }
//        }
//        [self.delegate itemCountChanged:self.products.count];
//    }];
//    
//    //device online,offline status
//    [chillhubsRef observeEventType:FEventTypeChildChanged withBlock:^(FDataSnapshot *snapshot) {
//        for (long i=self.products.count-1; i>-1; i--)
//        {
//            FSTChillHub *chillhub = [self.products objectAtIndex:i];
//            if ([chillhub.identifier isEqualToString:snapshot.key])
//            {
//                id rawVal = snapshot.value;
//                if (rawVal != [NSNull null])
//                {
//                    NSDictionary* val = rawVal;
//                    if ( [(NSString*)[val objectForKey:@"status"] isEqualToString:@"connected"] )
//                    {
//                        chillhub.online = YES;
//                    }
//                    else
//                    {
//                        chillhub.online = NO;
//                    }
//                    [self.productCollection reloadData];
//                }
//                break;
//            }
//        }
//    }];
//}
//


//- (void)checkForCloudProducts
//{
//    //TODO: not sure if this is the correct pattern. we want to show the "no products"
//    //found if there really aren't any products. since there is no timeout concept on the firebase
//    //API then am not sure what the correct method is for detecting a network error.
//
//    Firebase * ref = [[[FirebaseShared sharedInstance] userBaseReference] childByAppendingPath:@"devices"];
//    [ref removeAllObservers];
//
//    __weak typeof(self) weakSelf = self;
//
//    [self.loadingIndicator startAnimating];
//
//    //detect if we have any products/if the products are removed it is
//    //detected in the embeded collection view controller and we registered as a delegate
//    [ref observeEventType:FEventTypeChildAdded withBlock:^(FDataSnapshot *snapshot) {
//        [weakSelf.loadingIndicator stopAnimating];
//        [weakSelf hideProducts:NO];
//        [weakSelf hideNoProducts:YES];
//        weakSelf.hasFirebaseProducts = YES;
//    } withCancelBlock:^(NSError *error) {
//        //TODO: if its really a permission error then we need to handle this differently
//        DLog(@"%@",error.localizedDescription);
//        [weakSelf.loadingIndicator stopAnimating];
//    }];
//
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//
//        if (!self.hasFirebaseProducts)
//        {
//            [self.loadingIndicator stopAnimating];
//            [self noItemsInCollection];
//        }
//    });
//}

@end
