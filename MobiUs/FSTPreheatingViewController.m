//
//  FSTPreheatingViewController.m
//  FirstBuild
//
//  Created by Myles Caley on 5/12/15.
//  Copyright (c) 2015 FirstBuild. All rights reserved.
//

#import "FSTPreheatingViewController.h"
#import "FSTReadyToCookViewController.h"

@interface FSTPreheatingViewController ()

@end

@implementation FSTPreheatingViewController

FSTParagonCookingStage* _cookingStage;

//bottom of the scrollview
CGFloat _scrollViewBottom;

//max size of the scrollview
CGFloat _scrollViewSizeYMax;

//min start temperature
CGFloat _minTemperatureDegrees = 72;

//target temperature - min temperature
CGFloat _rangeMinAndMaxTemperatures ;

//how much to change with each temperature increment
CGFloat _heightIncrementOnChange;

//the height of the label, need to discount that in our calculations
CGFloat _temperatureViewHeight;

NSObject* _temperatureChangedObserver;
NSObject* _cookModeChangedObserver;

NSTimer* _pulseTimer;

#pragma mark UIView

- (void)viewDidLoad {
    [super viewDidLoad];
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    _cookingStage = (FSTParagonCookingStage*)(self.currentParagon.currentCookingMethod.session.paragonCookingStages[0]);
    self.targetTemperatureLabel.text = [[_cookingStage.targetTemperature stringValue] stringByAppendingString:@"\u00b0 F"];
    self.temperatureScrollerView.hidden = YES;
    
    [self.currentParagon startHeatingWithTemperature:_cookingStage.targetTemperature];
    
    //if we are already in heating mode then just transition
    if(self.currentParagon.currentCookMode == kPARAGON_HEATING)
    {
        [self performSegueWithIdentifier:@"segueReadyToCook" sender:self];
    }
    
    //if we get notice that we are done preheating then move on
    _cookModeChangedObserver = [center addObserverForName:FSTCookModeChangedNotification
                                                   object:self.currentParagon
                                                    queue:nil
                                               usingBlock:^(NSNotification *notification)
    {
        if(self.currentParagon.currentCookMode == kPARAGON_HEATING)
        {
            [self performSegueWithIdentifier:@"segueReadyToCook" sender:self];
        }
    }];
    
    _temperatureChangedObserver = [center addObserverForName:FSTActualTemperatureChangedNotification
                        object:self.currentParagon
                         queue:nil
                    usingBlock:^(NSNotification *notification)
    {
        NSNumber* actualTemperature = _cookingStage.actualTemperature;
        self.currentTemperatureLabel.text = [actualTemperature stringValue];
        
        CGFloat newTemp = [actualTemperature doubleValue] ;
        
        //find the temperature in proportion to the view
        CGFloat newHeight = _heightIncrementOnChange*(newTemp - _minTemperatureDegrees) + _temperatureViewHeight;
        
        // update constraints with height corresponding to temperature.
        self.temperatureScrollerHeightConstraint.constant = newHeight;
        [self.temperatureScrollerView needsUpdateConstraints];

        [UIView animateWithDuration:0.3 delay:0
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^(void) {
                             [self.temperatureScrollerView layoutIfNeeded];
                         }
                         completion: ^(BOOL complete) {
                             
                         }
         ];
        
        self.temperatureScrollerView.hidden = NO;
    }];
}

-(void)viewDidLayoutSubviews
{
    _scrollViewBottom = self.buttonWrapperView.frame.origin.y - _temperatureViewHeight - self.scrollerViewDistanceFromClosestUIElementConstraint.constant;

    CGFloat scrollViewTopMax = self.topOrangeBarView.frame.origin.y + self.topOrangeBarView.frame.size.height;
    _scrollViewSizeYMax = _scrollViewBottom - scrollViewTopMax;
    
    _rangeMinAndMaxTemperatures = [_cookingStage.targetTemperature doubleValue] - _minTemperatureDegrees;
    _heightIncrementOnChange = _scrollViewSizeYMax / _rangeMinAndMaxTemperatures;

}

-(void)viewDidAppear:(BOOL)animated
{
    CGRect frame = self.temperatureScrollerView.frame;
    frame.size.height = 30;
    //frame.size.width = 300;
    frame.origin.y = self.temperatureScrollerView.frame.size.height-frame.size.height;
    UIImageView *pulse =[[UIImageView alloc] initWithFrame:self.temperatureScrollerView.frame];
    pulse.image=[UIImage imageNamed:@"pulse.png"];
    pulse.alpha = 0.0;
    [self.view addSubview:pulse];
    
    [self pulseAnimation:pulse]; // begin repeat invocation and alpha animation
    
}

- (void)viewWillAppear:(BOOL)animated
{
    _temperatureViewHeight = self.temperatureBox.frame.origin.y + self.temperatureBox.frame.size.height;
    
#ifdef SIMULATE_PARAGON
    [self.currentParagon startSimulateHeating];
    [self.currentParagon setSimulatorHeatingTemperatureIncrement:1];
    [self.currentParagon setSimulatorHeatingUpdateInterval:200];
#endif
    
}

-(void)dealloc
{
    [self removeObservers];
}

#pragma mark animations

- (void)pulseAnimation:(UIImageView *)pulse { // might need to call and repeat through NSTimer or some other object, since the animation never updates
    _pulseTimer = [NSTimer scheduledTimerWithTimeInterval:2.5 target:self selector:@selector(moveOnePulse:) userInfo:pulse repeats:YES]; // starts interval that calls moveOnePulse with this pulse
    
    [_pulseTimer fire]; // start it once at the start, then it will repeat at the next interval

    // alpha animation
        [UIView animateWithDuration:1.25
                          delay:0.0
                        options: UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionAutoreverse | UIViewAnimationOptionRepeat
                     animations: ^(void) {
                         pulse.alpha=1.0;
                     }
                     completion: nil
     ];

   }

-(void)moveOnePulse:(NSTimer *)timer {
    UIImageView *pulse = [timer userInfo];
    pulse.transform = CGAffineTransformIdentity; // resets to original position, apparently all these
    // transformations are stored, as matrices of course, so when setting a new transform it just transitions to a new transform matrix, never actually changing the position
    
    [UIView animateWithDuration:2.5
                          delay:0.0 // this should be twice the alpha animation delay
                        options:UIViewAnimationOptionCurveEaseOut
                     animations: ^(void) {
                         CGAffineTransform transform = CGAffineTransformMakeTranslation(0, -self.temperatureScrollerHeightConstraint.constant + pulse.frame.size.height); // height contraint increases, add height to keep pulse within it
                         // movement animation
                         pulse.transform = transform;
                     }
                     completion:nil
     ];

}

#pragma mark transition

-(void)removeObservers
{
    [[NSNotificationCenter defaultCenter] removeObserver:_temperatureChangedObserver];
    [[NSNotificationCenter defaultCenter] removeObserver:_cookModeChangedObserver];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    [self removeObservers];
    [_pulseTimer invalidate]; // free the timer to stop calling the animation
    _pulseTimer = nil;
    if ([segue.destinationViewController isKindOfClass:[FSTReadyToCookViewController class]])
    {
        ((FSTReadyToCookViewController*)segue.destinationViewController).currentParagon = self.currentParagon;
    }    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
