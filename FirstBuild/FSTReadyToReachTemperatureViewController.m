//
//  FSTReadyToReachTemperatureViewController.m
//  FirstBuild
//
//  Created by Myles Caley on 5/12/15.
//  Copyright (c) 2015 FirstBuild. All rights reserved.
//

#import "FSTReadyToReachTemperatureViewController.h"
#import "FSTCookingViewController.h"
#import "MobiNavigationController.h"
#import "FSTRevealViewController.h"

@interface FSTReadyToReachTemperatureViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *pushButtonImageView;

@end

@implementation FSTReadyToReachTemperatureViewController

NSObject* _cookModeChangedObserver;


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    
    __weak typeof(self) weakSelf = self;
    
    _cookModeChangedObserver = [center addObserverForName:FSTCookingModeChangedNotification
                                                      object:weakSelf.currentParagon
                                                       queue:nil
                                                  usingBlock:^(NSNotification *notification)
    {
       if(weakSelf.currentParagon.cookMode != FSTParagonCookingStateOff)
       {
           [weakSelf performSegueWithIdentifier:@"segueCooking" sender:weakSelf];
       }
    }];
    self.navigationItem.hidesBackButton = YES;
    // remove the back button
    NSMutableArray* pushImages = [[NSMutableArray alloc] init];
    NSString* imageTitle;
    for (int ip = 0; ip <= 46; ip++) {// there are 47 frames for the push button animation
        imageTitle = [NSString stringWithFormat: @"animate-push-button_%05d", ip];
        UIImage *image = [UIImage imageNamed:imageTitle];
        if (!image) {
            NSLog(@"Could not load image named: %@", imageTitle);
        }
        else {
            [pushImages addObject:image];
        }
    }
    [self.pushButtonImageView setAnimationImages:pushImages]; // assign all the frames
    [self.pushButtonImageView setAnimationDuration:2.0];
    [self.pushButtonImageView startAnimating];
}

-(void)removeObservers
{
    [[NSNotificationCenter defaultCenter] removeObserver:_cookModeChangedObserver];
}

-(void)dealloc
{
    [self removeObservers];
}

- (void)viewWillAppear:(BOOL)animated
{

    MobiNavigationController* controller = (MobiNavigationController*)self.navigationController;
    [controller setHeaderText:@"GET READY" withFrameRect:CGRectMake(0, 0, 120, 30)];
    
    //TODO HACK
    //[self performSegueWithIdentifier:@"segueCooking" sender:self];
    
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    [self removeObservers];

    if ([segue.destinationViewController isKindOfClass:[FSTCookingViewController class]])
    {
        ((FSTCookingViewController*)segue.destinationViewController).currentParagon = self.currentParagon;
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)menuToggleTapped:(id)sender {
    [self.revealViewController rightRevealToggle:self.currentParagon];
}

@end
