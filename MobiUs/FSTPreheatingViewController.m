//
//  FSTPreheatingViewController.m
//  FirstBuild
//
//  Created by Myles Caley on 5/12/15.
//  Copyright (c) 2015 FirstBuild. All rights reserved.
//

#import "FSTPreheatingViewController.h"

@interface FSTPreheatingViewController ()

@end

@implementation FSTPreheatingViewController

FSTParagonCookingStage* _cookingStage;

CGFloat _scrollViewTop;
CGFloat _scrollViewBottom;
CGFloat _scrollViewSizeY;
CGFloat _temperaturePrecisionDegrees = 0.5;
CGFloat _minTemperatureDegrees = 72;
CGFloat _rangeMinAndMaxTemperatures ;
CGFloat _numberOfDivisions;
CGFloat _heightIncrementOnChange;
NSMutableArray* _tempHeightLookup;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    self.currentParagon.delegate = self;
    _cookingStage = (FSTParagonCookingStage*)(self.currentParagon.currentCookingMethod.session.paragonCookingStages[0]);
    FSTParagonCookingStage* stage = (FSTParagonCookingStage*)self.currentParagon.currentCookingMethod.session.paragonCookingStages[0];
    self.targetTemperatureLabel.text = [[stage.targetTemperature stringValue] stringByAppendingString:@"\u00b0 F"];
    
    _scrollViewTop = self.topOrangeBarView.frame.origin.y + self.topOrangeBarView.frame.size.height;
    _scrollViewBottom = self.temperatureScrollerView.frame.origin.y + self.temperatureScrollerView.frame.size.height;
    _scrollViewSizeY = _scrollViewBottom - _scrollViewTop;
    
    _rangeMinAndMaxTemperatures = [_cookingStage.targetTemperature doubleValue] - _minTemperatureDegrees;
    _numberOfDivisions = _rangeMinAndMaxTemperatures / _temperaturePrecisionDegrees;
    _heightIncrementOnChange = _scrollViewSizeY / _numberOfDivisions;
    
    
//    _tempHeightLookup = [[NSMutableArray alloc]init];
//    for (uint16_t i = 0; i<=_numberOfDivisions; i++)
//    {
//        [_tempHeightLookup addObject:[NSNumber numberWithDouble:<#(double)#>]]
//    }
    
#ifdef SIMULATE_PARAGON
    [self.currentParagon startSimulatePreheat];
#endif
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    self.currentParagon.delegate = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)actualTemperatureChanged:(NSNumber *)actualTemperature
{
    self.currentTemperatureLabel.text = [actualTemperature stringValue];
    
    CGFloat _change = [actualTemperature doubleValue] ;
    CGFloat _newYOrigin = _scrollViewBottom - (_change * _heightIncrementOnChange);
    NSLog(@"bottom: %f, top: %f, incr: %f, new y origin: %f", _scrollViewBottom, _scrollViewTop, _heightIncrementOnChange, _newYOrigin);
    
    if ([actualTemperature doubleValue] >= [_cookingStage.targetTemperature doubleValue])
    {
        [self performSegueWithIdentifier:@"segueReadyToCook" sender:self];
    }
}

@end
