//
//  FSTRevealViewController.m
//  FirstBuild
//
//  Created by Myles Caley on 7/27/15.
//  Copyright (c) 2015 FirstBuild. All rights reserved.
//

#import "FSTRevealViewController.h"
#import "FSTParagon.h"
#import "FSTParagonMenuViewController.h"

@interface FSTRevealViewController ()

@end

@implementation FSTRevealViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)rightRevealToggle:(id)sender
{
    UIViewController *vc;
    
    if ([sender isKindOfClass:[FSTParagon class]])
    {
        vc = [[self storyboard] instantiateViewControllerWithIdentifier:@"paragonMenu"];
       // ((FSTParagonMenuViewController*)vc).currentParagon = sender;
    }
    
    
    if (vc)
    {
        self.rightViewController = vc;        
    }
    
    [super rightRevealToggle:sender];
    
    [self.rightViewController.view setFrame:CGRectMake(self.rightViewRevealOverdraw, 0, self.view.frame.size.width - self.rightViewRevealOverdraw, self.view.frame.size.height)]; // set frame of right menu to remove the portion covered by the center. 
}



@end
