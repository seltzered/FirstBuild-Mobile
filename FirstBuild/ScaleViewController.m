//
//  ScaleViewController.m
//  FirstBuild-Mobile
//
//  Created by Myles Caley on 10/17/14.
//  Copyright (c) 2014 FirstBuild. All rights reserved.
//
#ifdef CHILLHUB

#import "ScaleViewController.h"
#import "FirebaseShared.h"

#import <Firebase/Firebase.h>

@implementation ScaleViewController

float amplitude;

- (void)loadMilkJugWithPercent: (float)percent
{
    amplitude = .5;
   
    //create a clipping mask in the shape of the path in the milk gallon
    CAShapeLayer *mask = [CAShapeLayer layer];
    mask.path = self.clippingView.clippingPath.CGPath  ;
    self.whiteView.layer.mask = mask;

    //add it to the run loop for animation
    CADisplayLink *displaylink = [CADisplayLink displayLinkWithTarget:self selector:@selector(animateMilkWave)];
    [displaylink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    [self.waveView setWaveColor:[UIColor whiteColor]];
   
    //fill in the jug and then stop the wave effect upon completion
    [UIView animateWithDuration:.8f animations:^{
        int increments = self.clippingView.bounds.size.height/100;
        self.whiteFillView.frame =CGRectMake(0, self.clippingView.bounds.size.height, self.clippingView.bounds.size.width, -(increments*percent));
        self.waveView.frame =CGRectMake(0, self.clippingView.bounds.size.height-(increments*percent+12), self.clippingView.bounds.size.width, 24);
    } completion:^(BOOL finished) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 2 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            amplitude = 0;
            [displaylink removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
        });
    }];
}

- (void)animateMilkWave
{
    [self.waveView updateWithLevel:amplitude];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //create the view with the same dimensions as the clipping view, this will hold the "white" object which
    //will be clipped by the clipping bezier path. since we are drawing the "milk" from the bottom we need to reverse
    //the y origin and grow the box negative
    self.whiteFillView = [[UIView alloc]initWithFrame:CGRectMake(0, self.clippingView.bounds.size.height, self.clippingView.bounds.size.width, 0)];
    self.whiteFillView.backgroundColor = [UIColor whiteColor];
    [self.whiteView addSubview:self.whiteFillView];
    
    //create a wave view that sits on the top of the milk. we need to start that box just above the top of the milk
    //and the height should be the same proportion below it. the wave view centers the wave it draws.
    self.waveView = [[SCSiriWaveformView alloc]initWithFrame:CGRectMake(0, self.clippingView.bounds.size.height, self.clippingView.bounds.size.width, 24)];
    self.waveView.backgroundColor = [UIColor clearColor];
    [self.whiteView addSubview:self.waveView];

    [self.milkyWeigh.firebaseRef removeAllObservers];
    [self.milkyWeigh.firebaseRef observeEventType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
        id rawVal = snapshot.value;
        if (rawVal != [NSNull null])
        {
            NSDictionary* val = rawVal;
            float percentageLeft = [(NSNumber *)[val objectForKey:@"weight"] doubleValue];
            [self loadMilkJugWithPercent:percentageLeft];
        }
        NSLog(@"%@ -> %@", snapshot.key, snapshot.value);
    }];
}

@end
#endif
