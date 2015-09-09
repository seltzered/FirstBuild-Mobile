//
//  ProductAddWrapperViewController.m
//  FirstBuild-Mobile
//
//  Created by Myles Caley on 1/8/15.
//  Copyright (c) 2015 FirstBuild. All rights reserved.
//

#import "ProductAddWrapperViewController.h"
#import "UILabel+MultiLineAutoSize.h"
#import <SWRevealViewController.h>

@interface ProductAddWrapperViewController ()

@end

@implementation ProductAddWrapperViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

-(void)viewWillAppear:(BOOL)animated
{
     [self.lblHeader adjustFontSizeToFitMultiLine];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];    
}

- (IBAction)revealButtonClick:(id)sender {
    [self.revealViewController rightRevealToggle:sender];
}

@end
