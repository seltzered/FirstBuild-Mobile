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

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    _cookingStage = (FSTParagonCookingStage*)(self.currentParagon.currentCookingMethod.session.paragonCookingStages[0]);
    _temperatureChangedObserver = [center addObserverForName:FSTActualTemperatureChangedNotification
                        object:self.currentParagon
                         queue:nil
                    usingBlock:^(NSNotification *notification)
    {
        NSNumber* actualTemperature = _cookingStage.actualTemperature;
        self.currentTemperatureLabel.text = [actualTemperature stringValue];
        
        if ([actualTemperature doubleValue] >= [_cookingStage.targetTemperature doubleValue])
        {
            [self performSegueWithIdentifier:@"segueReadyToCook" sender:self];
        }
        
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

    [self pulseAnimation:pulse];
    
}

- (void)pulseAnimation:(UIImageView *)pulse { // might need to call and repeat through NSTimer or some other object, since the animation never updates

    // movement animation
    [UIView animateWithDuration:2.0
                          delay:0.5
                        options:UIViewAnimationOptionCurveEaseOut | UIViewAnimationOptionAllowAnimatedContent | UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionRepeat
                     animations: ^(void) {
                         CGAffineTransform transform = CGAffineTransformMakeTranslation(0,-self.temperatureScrollerHeightConstraint.constant); // needs to go to top of red area (was at -_scrollViewSizeYMax)
                         // need to update the y value, this block only calls once.
                         pulse.transform = transform;
                     }
                     completion:nil
    ];
    
    // alpha animation
    [UIView animateWithDuration:1.0
                          delay:0.5
                        options:UIViewAnimationOptionAutoreverse | UIViewAnimationOptionRepeat
                     animations: ^(void) {
                         pulse.alpha=1.0;
                     }
                     completion: nil
     ];

   }

- (void)viewWillAppear:(BOOL)animated
{
    _cookingStage = (FSTParagonCookingStage*)(self.currentParagon.currentCookingMethod.session.paragonCookingStages[0]);
    FSTParagonCookingStage* stage = (FSTParagonCookingStage*)self.currentParagon.currentCookingMethod.session.paragonCookingStages[0];
    self.targetTemperatureLabel.text = [[stage.targetTemperature stringValue] stringByAppendingString:@"\u00b0 F"];
    self.temperatureScrollerView.hidden = YES;
     _temperatureViewHeight = self.temperatureBox.frame.origin.y + self.temperatureBox.frame.size.height;
   
#ifdef SIMULATE_PARAGON
    [self.currentParagon startSimulateHeating];
    [self.currentParagon setSimulatorHeatingTemperatureIncrement:1];
    [self.currentParagon setSimulatorHeatingUpdateInterval:200];
#endif
    
    
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    [[NSNotificationCenter defaultCenter] removeObserver:_temperatureChangedObserver];
    if ([segue.destinationViewController isKindOfClass:[FSTReadyToCookViewController class]])
    {
        ((FSTReadyToCookViewController*)segue.destinationViewController).currentParagon = self.currentParagon;
    }    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
