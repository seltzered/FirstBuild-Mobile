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
    UIView* centerView = ((UINavigationController*) self.frontViewController).topViewController.view; // disable this center view in the front navigation controller
    if (self.frontViewPosition >= FrontViewPositionLeft) {// has already toggled
        centerView.userInteractionEnabled = true; // reenable view controller
        ((UINavigationController*)self.frontViewController).interactivePopGestureRecognizer.enabled = true; // keep things consistent I suppose
    } else{ // about to toggle the first time
        centerView.userInteractionEnabled = false;
        ((UINavigationController*)self.frontViewController).interactivePopGestureRecognizer.enabled = false; // keep users from sliding back
    }
}



@end
