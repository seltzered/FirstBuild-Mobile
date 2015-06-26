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

NSObject* _menuItemSelectedObserver;

- (void)viewDidLoad
{
    [super viewDidLoad];

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
    
}

-(void) dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:_menuItemSelectedObserver];
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
    if ([segueName isEqualToString: @"segueCollectionView"]) {
        ProductCollectionViewController * productsCollection = (ProductCollectionViewController *) [segue destinationViewController];
        productsCollection.delegate = self;
    }
}

- (IBAction)revealButtonClick:(id)sender {
    [self.revealViewController rightRevealToggle:sender];
}

- (void) itemCountChanged: (NSUInteger)count
{
    if (count==0)
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

@end
