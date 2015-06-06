//
//  FSTCookingViewController.m
//  FirstBuild
//
//  Created by Myles Caley on 5/12/15.
//  Copyright (c) 2015 FirstBuild. All rights reserved.
//

//
//  ProgressViewController.m
//  CircularProgressControl
//
//  Created by Carlos Eduardo Arantes Ferreira on 22/11/14.
//  Copyright (c) 2014 Mobistart. All rights reserved.
//

#import "FSTCookingViewController.h"
#import "Session.h"

@interface FSTCookingViewController ()

@property (strong, nonatomic) NSTimer *timer;
@property (nonatomic) Session *session;
@end

@implementation FSTCookingViewController

FSTParagonCookingStage* _cookingStage;
NSObject* _temperatureChangedObserver;
NSObject* _timeElapsedChangedObserver;

- (void)viewDidLoad {
    [super viewDidLoad];
    _cookingStage = (FSTParagonCookingStage*)(self.currentParagon.currentCookingMethod.session.paragonCookingStages[0]);

    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    
    _temperatureChangedObserver = [center addObserverForName:FSTActualTemperatureChangedNotification
                                                      object:self.currentParagon
                                                       queue:nil
                                                  usingBlock:^(NSNotification *notification)
    {
        //
    }];
    
    _timeElapsedChangedObserver = [center addObserverForName:FSTActualTemperatureChangedNotification
                                                      object:self.currentParagon
                                                       queue:nil
                                                  usingBlock:^(NSNotification *notification)
   {
       self.circleProgressView.elapsedTime = [_cookingStage.cookTimeElapsed doubleValue]/60;
       DLog("elapsed %@", _cookingStage.cookTimeElapsed);
   }];
    
    self.circleProgressView.timeLimit = [_cookingStage.cookTimeRequested doubleValue];
    self.circleProgressView.elapsedTime = 0;
    
    //[self startTimer];
    [self.currentParagon startSimulatingTimeWithTemperatureRegulating];
    
//    self.session = [[Session alloc] init];
//    self.session.state = kSessionStateStop;
//    self.session.startDate = [NSDate date];
//    self.session.finishDate = nil;
//    self.session.state = kSessionStateStart;
    
    UIColor *tintColor = UIColorFromRGB(0xD43326);
    //self.circleProgressView.status = NSLocalizedString(@"Stuff", nil);
    self.circleProgressView.tintColor = tintColor;
    self.circleProgressView.elapsedTime = 0;

}

//- (void)startTimer {
//    if ((!self.timer) || (![self.timer isValid])) {
//        
//        self.timer = [NSTimer scheduledTimerWithTimeInterval:1.00
//                                                      target:self
//                                                    selector:@selector(poolTimer)
//                                                    userInfo:nil
//                                                     repeats:YES];
//    }
//}
//
//- (void)poolTimer
//{
//    if ((self.session) && (self.session.state == kSessionStateStart))
//    {
//        self.circleProgressView.elapsedTime = self.session.progressTime;
//    }
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

// Copyright belongs to original author
// http://code4app.net (en) http://code4app.com (cn)
// From the most professional code share website: Code4App.net
