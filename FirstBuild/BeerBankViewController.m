//
//  BeerBankViewController.m
//  FirstBuild
//
//  Created by Myles Caley on 5/4/15.
//  Copyright (c) 2015 FirstBuild. All rights reserved.
//

#ifdef CHILLHUB

#import "BeerBankViewController.h"
#import <Firebase/Firebase.h>


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
            uint32_t beerAlarm = [(NSNumber *)[val objectForKey:@"beer_alarm"] floatValue];
            
            //if the beer alarm is 0 (open to take one), its not currently animating, and there is some time remaining then update
            if (!animating && beerAlarm==0 && timeRemaining > 0)
            {
                NSLog(@"firebase value changed, displaying overlay");
                [self displayOverlayWithSecondsRemaining:timeRemaining];
            }
            else if (beerAlarm==1)
            {
                NSLog(@"firebase value changed, QUICKLY showing overlay");
                [self.overlayView.layer removeAllAnimations];
                [self displayOverlayWithSecondsRemaining:0];
            }
            else
            {
                NSLog(@"firebase value changed, but nothing to do");
            }
        }
        NSLog(@"%@ -> %@", snapshot.key, snapshot.value);
    }];
}

-(void)displayOverlayWithSecondsRemaining: (uint32_t)timeRemaining
{
    self.unlockButton.hidden = true;
    NSLog(@"animate %d", timeRemaining);
    CGFloat boundingHeight = self.view.frame.size.height;
    
    [UIView animateWithDuration:timeRemaining delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        //if (self.overlayView.transform.ty==0)
        {
            [self.overlayView setTransform:CGAffineTransformMakeTranslation(0,-boundingHeight)];
        }
    } completion:^(BOOL finished) {
        self.unlockButton.hidden = false;
        self.relockButton.hidden = true;
        animating = false;
    }];
    
}
- (IBAction)lockIconTapGesture:(id)sender {
    [self unlock];
}

- (IBAction)relockIconClicked:(id)sender {
    Firebase *ref = [self.beerBank.firebaseRef childByAppendingPath:@"beer_alarm"];
    [ref setValue:[NSNumber numberWithInt:1]];
    [self displayOverlayWithSecondsRemaining:0];
}

-(void)removeOverlay
{
    self.unlockButton.hidden = true;
    self.relockButton.hidden = false;
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
    [self unlock];
}

-(void)unlock
{
    Firebase *ref = [self.beerBank.firebaseRef childByAppendingPath:@"beer_alarm"];
    [ref setValue:[NSNumber numberWithInt:0]];
    [self removeOverlay];
    
}

@end

#endif
