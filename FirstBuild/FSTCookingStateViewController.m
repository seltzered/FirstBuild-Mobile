//
//  FSTCookingStateViewController.m
//  FirstBuild
//
//  Created by John Nolan on 8/6/15.
//  Copyright (c) 2015 FirstBuild. All rights reserved.
//

#import "FSTCookingStateViewController.h"

@interface FSTCookingStateViewController ()
{
    CGFloat _startingTemp ;
}
@end

@implementation FSTCookingStateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

-(void) updatePercent {
}

-(void) updateLabels {
    
}

- (double)calculatePercent:(NSTimeInterval)fromTime toTime:(NSTimeInterval)toTime {

    if ((toTime > 0) && (fromTime > 0)) {
        
        CGFloat progress = 0;
        
        progress = fromTime / toTime;
        
        if ((progress * 100) > 100) {
            progress = 1.0f;
        }
        
        return progress;
    }
    else {
        return 0.0f;
    }
}

-(double)calculatePercentWithTemp {
    CGFloat progress = 0; // defaults to this
    
    // if target is greater than current then we are heating, thus
    // preheating, otherwise we are cooling down to temperature
    // and need to calculate the % diff
    if (self.cookingData.targetTemp > self.cookingData.currentTemp)
    {
        progress = (self.cookingData.currentTemp/self.cookingData.targetTemp);
        
        if ((progress * 100) > 100)
        {
            progress = 1.0f; // complete
        }
    }
    else
    {
        if (!_startingTemp)
        {
            _startingTemp = self.cookingData.currentTemp;
        }
        progress = 1 - (_startingTemp - self.cookingData.currentTemp)/(_startingTemp - self.cookingData.targetTemp);
        if (progress <=0)
        {
            progress = 0.0f; //complete
        }
        
        // kind of a hack, make it negative so the reaching temperature
        // layer knows this is a cooling view
        progress = progress * -1;
        
    }

    return progress;
}

#pragma mark - <CookingViewControllerDelegate>

-(void)dataChanged:(CookingStateModel *)data
{
    [self updatePercent];
    [self updateLabels];
}

@end
