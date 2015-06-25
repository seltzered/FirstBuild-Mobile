//
//  ProductMainViewController.m
//  MobiUs
//
//  Created by Myles Caley on 12/17/14.
//  Copyright (c) 2014 FirstBuild. All rights reserved.
//

#import "ProductMainViewController.h"
#import "FirebaseShared.h"
#import "MenuViewController.h"
#import <Firebase/Firebase.h>
#import <SWRevealViewController.h>

@interface ProductMainViewController ()

@end

@implementation ProductMainViewController

//BOOL _hasBleProducts = NO;
NSObject* _kvoObserver;
NSObject* _menuItemSelectedObserver;

//TODO: re-implement loading of cloud products
//TODO: continue clean up hide/nohide with KVO
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.hasBleProducts = NO;
    self.hasFirebaseProducts = NO;
    
    __weak typeof(self) weakSelf = self;
    
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];

    _menuItemSelectedObserver = [center addObserverForName:FSTMenuItemSelectedNotification
                                                   object:nil
                                                    queue:nil
                                               usingBlock:^(NSNotification *notification)
    {
        NSString* item = (NSString*)notification.object;
        if([item isEqual:FSTMenuItemAddNewProduct])
        {
            [weakSelf performSegueWithIdentifier:@"segueAddNewProduct" sender:self];
        }
        if([item isEqual:FSTMenuItemHome])
        {
            [self.navigationController popToRootViewControllerAnimated:NO];
        }
    }];
    
    [self addObserver:self forKeyPath:@"hasBleProducts" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    
    [self checkForBleProducts];
}

-(void) dealloc
{
    //[self removeObserver:self forKeyPath:@"hasBleProducts"];
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    
    if (self.hasFirebaseProducts || self.hasBleProducts)
    {
        [self hideNoProducts:NO];
        [self hideNoProducts:YES];
    }
    else
    {
        [self hideProducts:YES];
        [self hideNoProducts:NO];
    }
}

- (void)checkForBleProducts
{
    NSArray* bleDevices = [[NSUserDefaults standardUserDefaults] objectForKey:@"ble-devices"];
    if (bleDevices && bleDevices.count > 0)
    {
        self.hasBleProducts = YES;
    }
    else
    {
         self.hasBleProducts = NO;
    }
}

- (void)checkForCloudProducts
{
    //TODO: not sure if this is the correct pattern. we want to show the "no products"
    //found if there really aren't any products. since there is no timeout concept on the firebase
    //API then am not sure what the correct method is for detecting a network error.
    
    Firebase * ref = [[[FirebaseShared sharedInstance] userBaseReference] childByAppendingPath:@"devices"];
    [ref removeAllObservers];
    
    __weak typeof(self) weakSelf = self;
    
    [self.loadingIndicator startAnimating];

    //detect if we have any products/if the products are removed it is
    //detected in the embeded collection view controller and we registered as a delegate
    [ref observeEventType:FEventTypeChildAdded withBlock:^(FDataSnapshot *snapshot) {
        [weakSelf.loadingIndicator stopAnimating];
        [weakSelf hideProducts:NO];
        [weakSelf hideNoProducts:YES];
        weakSelf.hasFirebaseProducts = YES;
    } withCancelBlock:^(NSError *error) {
        //TODO: if its really a permission error then we need to handle this differently
        DLog(@"%@",error.localizedDescription);
        [weakSelf.loadingIndicator stopAnimating];
    }];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        if (!self.hasFirebaseProducts)
        {
            [self.loadingIndicator stopAnimating];
            [self noItemsInCollection];
        }
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // intercept the segue to the embedded container controller
    NSString * segueName = segue.identifier;
    if ([segueName isEqualToString: @"segueCollectionView"]) {
        ProductCollectionViewController * productsCollection = (ProductCollectionViewController *) [segue destinationViewController];
        productsCollection.delegate = self;
    }
}

- (IBAction)revealButtonClick:(id)sender {
    [self.revealViewController rightRevealToggle:sender];
}

- (void) noItemsInCollection
{
    [self hideProducts:YES];
    [self hideNoProducts:NO];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:1.5];
    [UIView setAnimationDelay:1];
    [UIView setAnimationRepeatCount:HUGE_VAL];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    [UIView setAnimationBeginsFromCurrentState:YES];
    
    // The transform matrix
    CGAffineTransform transform = CGAffineTransformMakeTranslation(0, 80);
    CGAffineTransform transform2 = CGAffineTransformMakeScale(.7,.7);
    CGAffineTransform final = CGAffineTransformConcat(transform, transform2);
    self.teardropImage.transform = final;
    
    // Commit the changes
    [UIView commitAnimations];
}

-(void) hideProducts: (BOOL)setHidden
{
    if(setHidden==YES)
    {
        self.productsCollectionView.alpha = 1;
        [UIView animateWithDuration:0.5 animations:^{
            self.productsCollectionView.alpha = 0;
        }];
        self.productsCollectionView.hidden = YES;
    }
    else
    {
        self.productsCollectionView.alpha = 0;
        self.productsCollectionView.hidden = NO;
        [UIView animateWithDuration:0.5 animations:^{
            self.productsCollectionView.alpha = 1;
        }];
    }
    [UIView commitAnimations];

}

-(void) hideNoProducts: (BOOL)setHidden
{
    if(setHidden==YES)
    {
        self.noProductsView.alpha = 1;
        [UIView animateWithDuration:0.5 animations:^{
            self.noProductsView.alpha = 0;
        }];
        self.noProductsView.hidden = YES;
    }
    else
    {
        self.noProductsView.alpha = 0;
        self.noProductsView.hidden = NO;
        [UIView animateWithDuration:0.5 animations:^{
            self.noProductsView.alpha = 1;
        }];
    }
    [UIView commitAnimations];
}

@end
