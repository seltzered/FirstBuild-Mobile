//
//  BeerBankViewController.m
//  FirstBuild
//
//  Created by Myles Caley on 5/4/15.
//  Copyright (c) 2015 FirstBuild. All rights reserved.
//

#import "BeerBankViewController.h"
#import <Firebase/Firebase.h>
#

@interface BeerBankViewController ()

@end

@implementation BeerBankViewController

bool animating = false;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.beerBank.firebaseRef removeAllObservers];
    [self.beerBank.firebaseRef observeEventType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
        id rawVal = snapshot.value;
        if (rawVal != [NSNull null])
        {
            NSDictionary* val = rawVal;
            uint32_t timeRemaining = [(NSNumber *)[val objectForKey:@"time_remaining"] floatValue];
            
            if (!animating)
            {
                [self displayOverlayWithSecondsRemaining:timeRemaining];
            }
        }
        NSLog(@"%@ -> %@", snapshot.key, snapshot.value);
    }];
}

-(void)displayOverlayWithSecondsRemaining: (uint32_t)timeRemaining
{
    self.unlockButton.hidden = true;
    CGFloat boundingHeight = self.view.frame.size.height;
    
    [UIView animateWithDuration:timeRemaining animations:^{
        if (self.overlayView.transform.ty==0)
        {
            [self.overlayView setTransform:CGAffineTransformMakeTranslation(0,-boundingHeight)];
        }
    } completion:^(BOOL finished) {
        self.unlockButton.hidden = false;
        animating = false;
    }];
    
}

-(void)removeOverlay
{
    self.unlockButton.hidden = true;
    
    [UIView animateWithDuration:1 animations:^{
        [self.overlayView setTransform:CGAffineTransformMakeTranslation(0,0)];
    } completion:^(BOOL finished) {
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)unlockButtonPressed:(id)sender {
    Firebase *ref = [self.beerBank.firebaseRef childByAppendingPath:@"beer_alarm"];
    [ref setValue:[NSNumber numberWithInt:1]];
    [self removeOverlay];
}

- (IBAction)openSwitchClicked:(id)sender
{
   
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
