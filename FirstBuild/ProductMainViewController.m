//
//  ProductMainViewController.m
//  FirstBuild-Mobile
//
//  Created by Myles Caley on 12/17/14.
//  Copyright (c) 2014 FirstBuild. All rights reserved.
//

#import "ProductMainViewController.h"
#import "FSTBleCentralManager.h"
#import "FSTParagonDisconnectedLabel.h"
#import "FSTParagonMenuViewController.h"
#import "FSTBleProduct.h"
#import <SWRevealViewController.h>
#import "MobiNavigationController.h"

@interface ProductMainViewController ()

@end

@implementation ProductMainViewController
{
    NSObject* _bleCentralManagerPoweredOffObserver;
    NSObject* _menuItemSelectedObserver;
    NSObject* _bleDeviceDisconnectedObserver;
    NSObject* _bleDeviceConnectedObserver;
    NSObject* _bleCentralManagerPoweredOnObserver;
    
    NSMutableArray* _offlineDevices;
    
    FSTParagonDisconnectedLabel* _warningLabel;
    FSTParagonDisconnectedLabel* _bleOffWarningLabel;
}


- (void)viewDidLoad
{
    [super viewDidLoad];

    __weak typeof(self) weakSelf = self;
    _offlineDevices = [[NSMutableArray alloc]init];
    
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];

    _menuItemSelectedObserver = [center addObserverForName:FSTMenuItemSelectedNotification
                                                   object:nil
                                                    queue:nil
                                               usingBlock:^(NSNotification *notification)
    {
        NSString* item = (NSString*)notification.object;
        if([item isEqual:FSTMenuItemHome])
        {
            [weakSelf.navigationController popToRootViewControllerAnimated:NO];
        }
    }];
    
    //ble turned off
    _bleCentralManagerPoweredOffObserver = [center addObserverForName:FSTBleCentralManagerPoweredOff
                                                               object:nil
                                                                queue:nil
                                                           usingBlock:^(NSNotification *notification)
    {
        if (!_bleOffWarningLabel)
        {
            UIViewController* activeController = [[[UIApplication sharedApplication] keyWindow] rootViewController];//
            _bleOffWarningLabel = [[FSTParagonDisconnectedLabel alloc] initWithFrame:CGRectMake(0, 0, activeController.view.frame.size.width, activeController.view.frame.size.height/8.7)];
            _bleOffWarningLabel.delegate = self; // set delegate to main home screen
            _bleOffWarningLabel.message = @"Please enable bluetooth";
            [activeController.view addSubview:_bleOffWarningLabel];
            [[[UIApplication sharedApplication] keyWindow] setRootViewController:activeController]; // set all the changes made
        }
    }];
    
    //ble turned on
    _bleCentralManagerPoweredOnObserver = [center addObserverForName:FSTBleCentralManagerPoweredOn
                                                              object:nil
                                                               queue:nil
                                                          usingBlock:^(NSNotification *notification)
   {
       if (_bleOffWarningLabel)
       {
           [_bleOffWarningLabel removeFromSuperview];
           _bleOffWarningLabel = nil;
       }
   }];

    
    //device connected
    _bleDeviceConnectedObserver = [center addObserverForName:FSTBleCentralManagerDeviceConnected
                                                   object:nil
                                                    queue:nil
                                               usingBlock:^(NSNotification *notification)
    {
        CBPeripheral* peripheral = (CBPeripheral*)(notification.object);
        [_offlineDevices removeObject:peripheral];
        if (_offlineDevices.count == 0 && _warningLabel)
        {
            [_warningLabel removeFromSuperview];
            _warningLabel = nil;
        }
    }];

    
    //device disconnected
    _bleDeviceDisconnectedObserver = [center addObserverForName:FSTBleCentralManagerDeviceDisconnected
                                                       object:nil
                                                        queue:nil
                                                   usingBlock:^(NSNotification *notification)
    {

        if (!_warningLabel)
        {
            CBPeripheral* peripheral = (CBPeripheral*)notification.object;

            [_offlineDevices addObject:peripheral];
            UIViewController* activeController = [[[UIApplication sharedApplication] keyWindow] rootViewController];//
            _warningLabel = [[FSTParagonDisconnectedLabel alloc] initWithFrame:CGRectMake(0, 0, activeController.view.frame.size.width, activeController.view.frame.size.height/8.7)];
            _warningLabel.delegate = self; // set delegate to main home screen
            _warningLabel.message = @"A device is not connected.";
            [activeController.view addSubview:_warningLabel];//addSubview:warningLabel];//add label to take in space that view slid out
            [[[UIApplication sharedApplication] keyWindow] setRootViewController:activeController]; // set all the changes made
        }
    }];
    
}

-(void)viewWillAppear:(BOOL)animated {
    
    MobiNavigationController* navigation = (MobiNavigationController*)self.navigationController;
    [navigation setHeaderText:@"MY PRODUCTS" withFrameRect:CGRectMake(0, 0, 160, 40)]; // a bit larger for this text
    [navigation.navigationBar setBarTintColor:[UIColor blackColor]];
    //self.addButton.width = 2;
}

-(void) dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:_menuItemSelectedObserver];
    [[NSNotificationCenter defaultCenter] removeObserver:_bleDeviceDisconnectedObserver];
    [[NSNotificationCenter defaultCenter] removeObserver:_bleDeviceConnectedObserver];
    [[NSNotificationCenter defaultCenter] removeObserver:_bleCentralManagerPoweredOffObserver];
    [[NSNotificationCenter defaultCenter] removeObserver:_bleCentralManagerPoweredOnObserver];


}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // intercept the segue to the embedded container controller so we can be a delegate
    // and listen for changes in the data to determine what to do in the main screen
    NSString * segueName = segue.identifier;
    if ([segueName isEqualToString: @"segueTable"]) { // embed segue
        ProductTableViewController * productsTable = (ProductTableViewController *) [segue destinationViewController];
        productsTable.delegate = self;
    }
}

- (IBAction)revealButtonClick:(id)sender {
    [self.revealViewController rightRevealToggle:sender];
}

- (IBAction)addButtonClick:(id)sender {
    [self performSegueWithIdentifier:@"segueAddNewProduct" sender:self];
}

- (void) itemCountChanged: (NSUInteger)count
{
    if (count==0)
    {
        [self hideProducts:YES];
        [self hideNoProducts:NO];
        //self.teardropImage.transform = CGAffineTransformMakeScale(0.1, 0.1); // start it very small in storyboard, and with now translation
        self.teardropImage.alpha = 1.0;
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:1.5];
        [UIView setAnimationDelay:1];
        [UIView setAnimationRepeatCount:HUGE_VAL];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [UIView setAnimationBeginsFromCurrentState:YES];
        
        // The transform matrix
        CGAffineTransform transform = CGAffineTransformMakeTranslation(0, 35); // was 80
        CGAffineTransform transform2 = CGAffineTransformMakeScale(4.0,4.0); //grow from small size, was .7 .7
        CGAffineTransform final = CGAffineTransformConcat(transform, transform2);
        self.teardropImage.transform = final;
        self.teardropImage.alpha = 0.0; // fade out at end
        
        // Commit the changes
        [UIView commitAnimations];
    }
    else
    {
        [self hideProducts:NO];
        [self hideNoProducts:YES];
    }
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

-(void) popFromWarning { // label delegate method
    
    //remove all warnings
    [self.navigationController popToViewController:self animated:NO];
    UIViewController* activeController = [[[UIApplication sharedApplication] keyWindow] rootViewController]; // get back that swholder (might be a better way)
    
    for (UIView* subview in activeController.view.subviews) {
        if ([subview isKindOfClass:[FSTParagonDisconnectedLabel class]]) {
            [subview removeFromSuperview];
        }
    }
    
    //activeController.view.frame = CGRectOffset(activeController.view.frame, 0, -activeController.view.frame.size.height/9); // set back the root view controller (a lot of hard-coding to reset this, maybe its better through a transform or all down from that holder view

    [[[UIApplication sharedApplication] keyWindow] setRootViewController:activeController]; // set all the changes made
}

@end
