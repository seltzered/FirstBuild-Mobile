//
//  FSTContainerViewController.m
//  FirstBuild
//
//  Created by John Nolan on 8/6/15.
//  Copyright (c) 2015 FirstBuild. All rights reserved.
//  Example by Michael Luton
//

#import "FSTContainerViewController.h"
#import "FSTCookingStateViewController.h"
#import "FSTCookingViewController.h"

@interface FSTContainerViewController ()

@end

@implementation FSTContainerViewController

- (void)viewDidLoad {
    [super viewDidLoad]; // should I set some default segue here?
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)segueToStateWithIdentifier:(NSString *)identifier sender:(id)sender {
    [self performSegueWithIdentifier:identifier sender:sender];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    ((FSTCookingViewController*)self.parentViewController).delegate = segue.destinationViewController; // set the current delegate to this parent, allowing for communications around this view controller

    if (self.childViewControllers.count > 0) {
        
        [self swapFromViewController:[self.childViewControllers objectAtIndex:0] toViewController:segue.destinationViewController];
    } else { // add the new child
        [self addChildViewController:segue.destinationViewController];
        ((UIViewController*)segue.destinationViewController).view.frame = self.view.frame;//CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
        [self.view addSubview:((UIViewController*)segue.destinationViewController).view]; // why only do this once?
        [segue.destinationViewController didMoveToParentViewController:self];
    }
    
    if ([segue.destinationViewController isKindOfClass:[FSTCookingStateViewController class]]) {
        FSTParagonCookingStage* stage = self.paragon.session.activeRecipe.paragonCookingStages[0];
        ((FSTCookingStateViewController*)segue.destinationViewController).targetMinTime = [stage.cookTimeMinimum doubleValue];
        ((FSTCookingStateViewController*)segue.destinationViewController).targetMaxTime = [stage.cookTimeMaximum doubleValue];
        ((FSTCookingStateViewController*)segue.destinationViewController).targetTemp = [stage.targetTemperature doubleValue];
        ((FSTCookingStateViewController*)segue.destinationViewController).elapsedTime = [stage.cookTimeElapsed doubleValue];
        
    }
    
}

-(void)swapFromViewController: (UIViewController*)fromController toViewController: (UIViewController*)toController {
    toController.view.frame = self.view.frame;//CGRectMake(0.0, 0.0, self.view.frame.size.width, self.view.frame.size.height); // problem with the subviews offset incorrectly
    
    NSLog(@"from %@ to %@", fromController, toController);
    [fromController willMoveToParentViewController:nil]; // needed before removing
    [self addChildViewController:toController];
    [self transitionFromViewController:fromController toViewController:toController duration:0.0 options:UIViewAnimationOptionTransitionCrossDissolve animations:nil completion:^(BOOL finished) {
    }];
    [fromController removeFromParentViewController];
    [toController didMoveToParentViewController:self];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
