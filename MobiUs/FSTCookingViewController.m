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

- (void)viewDidLoad {
    [super viewDidLoad];

    self.circleProgressView.timeLimit = 60*8;
    self.circleProgressView.elapsedTime = 0;
    
    [self startTimer];
    
    self.session = [[Session alloc] init];
    self.session.state = kSessionStateStop;
    self.session.startDate = [NSDate date];
    self.session.finishDate = nil;
    self.session.state = kSessionStateStart;
    
    UIColor *tintColor = [UIColor colorWithRed:184/255.0 green:233/255.0 blue:134/255.0 alpha:1.0];
    self.circleProgressView.status = NSLocalizedString(@"circle-progress-view.status-in-progress", nil);
    self.circleProgressView.tintColor = tintColor;
    self.circleProgressView.elapsedTime = 0;
    

}

- (void)startTimer {
    if ((!self.timer) || (![self.timer isValid])) {
        
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1.00
                                                      target:self
                                                    selector:@selector(poolTimer)
                                                    userInfo:nil
                                                     repeats:YES];
    }
}

- (void)poolTimer
{
    if ((self.session) && (self.session.state == kSessionStateStart))
    {
        self.circleProgressView.elapsedTime = self.session.progressTime;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

// Copyright belongs to original author
// http://code4app.net (en) http://code4app.com (cn)
// From the most professional code share website: Code4App.net
