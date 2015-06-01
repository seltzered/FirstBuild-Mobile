//
//  FSTBeefSettingsViewController.m
//  FirstBuild
//
//  Created by Myles Caley on 5/12/15.
//  Copyright (c) 2015 FirstBuild. All rights reserved.
//

#import "FSTBeefSettingsViewController.h"
#import "FSTBeefSousVideCookingMethod.h"

@interface FSTBeefSettingsViewController ()

@property (strong, nonatomic) IBOutlet UIView *thicknessSelectionView;
@property (strong, nonatomic) IBOutlet UIView *meatView;



@end

const uint8_t TEMPERATURE_START_INDEX = 6;

@implementation FSTBeefSettingsViewController
{
    CGFloat _startingHeight;
    CGFloat _startingOrigin;
    CGFloat _startingSelectorXOrigin;
    CGFloat _maxHeight;
    CGFloat _meatHeightOffset;
    CGFloat _yBoundsTop;
    CGFloat _yBoundsBottom;
    FSTBeefSousVideCookingMethod* _beefCookingMethod;
    NSNumber* _currentThickness;
    NSNumber* _currentTemperature;
    NSMutableArray* _temperatureXOrigins;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    _beefCookingMethod = [[FSTBeefSousVideCookingMethod alloc]init];
    _maxHeight = self.thicknessSelectionView.frame.size.height;
    _meatHeightOffset = self.meatView.frame.origin.y;
    _yBoundsBottom = (self.thicknessSelectionView.frame.origin.y + _maxHeight) - _meatHeightOffset;
    _yBoundsTop = self.thicknessSelectionView.frame.origin.y;
    
    CGRect frame = self.thicknessSelectionView.frame;
    _currentThickness =[NSNumber numberWithDouble:[self meatThicknessWithActualViewHeight:frame.size.height-1]];
    _currentTemperature = [NSNumber numberWithDouble:[_beefCookingMethod.donenesses[TEMPERATURE_START_INDEX] doubleValue]];
    
    [self updateLabels];
    
     _temperatureXOrigins = [[NSMutableArray alloc]init];
    for (uint8_t i=0; i< self.donenessSelectionsView.subviews.count; i++)
    {
        NSNumber* originX = [[NSNumber alloc] initWithFloat:((UIView*)(self.donenessSelectionsView.subviews[i])).frame.origin.x];
        DLog(@"originX %@", originX);
        [_temperatureXOrigins insertObject:originX atIndex:i];
    }
}

- (void)updateLabels
{
   
    //temperature label
    UIFont *boldFont = [UIFont fontWithName:@"PTSans-NarrowBold" size:22.0];
    NSDictionary *boldFontDict = [NSDictionary dictionaryWithObject: boldFont forKey:NSFontAttributeName];
    
    UIFont *labelFont = [UIFont fontWithName:@"PT Sans Narrow" size:18.0];
    NSDictionary *labelFontDict = [NSDictionary dictionaryWithObject: labelFont forKey:NSFontAttributeName];
    
    NSNumber* hour = (NSNumber*)(((NSArray*)([[_beefCookingMethod.cookingTimes objectForKey:_currentTemperature] objectForKey:_currentThickness]))[0]);
    NSNumber* minute = (NSNumber*)(((NSArray*)([[_beefCookingMethod.cookingTimes objectForKey:_currentTemperature] objectForKey:_currentThickness]))[1]);
    
    DLog(@"val: %@:%@", hour, minute);
    
    NSMutableAttributedString *hourString = [[NSMutableAttributedString alloc] initWithString:[hour stringValue] attributes: boldFontDict];
    NSMutableAttributedString *hourLabel = [[NSMutableAttributedString alloc] initWithString:@"H : " attributes: labelFontDict];
    NSMutableAttributedString *minuteString = [[NSMutableAttributedString alloc] initWithString:[minute stringValue] attributes: boldFontDict];
    NSMutableAttributedString *minuteLabel = [[NSMutableAttributedString alloc] initWithString:@"MIN" attributes: labelFontDict];
    NSMutableAttributedString *separator = [[NSMutableAttributedString alloc] initWithString:@"  |  " attributes: boldFontDict];
    NSMutableAttributedString *temperature = [[NSMutableAttributedString alloc] initWithString:[_currentTemperature stringValue] attributes: boldFontDict];
    NSMutableAttributedString *degreeString = [[NSMutableAttributedString alloc] initWithString:@"\u00b0" attributes:boldFontDict];
    NSMutableAttributedString *temperatureLabel = [[NSMutableAttributedString alloc] initWithString:@" F" attributes: boldFontDict];
    
    [hourString appendAttributedString:hourLabel];
    [hourString appendAttributedString:minuteString];
    [hourString appendAttributedString:minuteLabel];
    [hourString appendAttributedString:separator];
    [hourString appendAttributedString:temperature];
    [hourString appendAttributedString:degreeString];
    [hourString appendAttributedString:temperatureLabel];

    [self.beefSettingsLabel setAttributedText:hourString];
    
    // thickness label
    NSArray* labelDetails = (NSArray*)([_beefCookingMethod.thicknessLabels objectForKey:_currentThickness]);
    
    self.wholeNumberLabel.text = (NSString*)labelDetails[0];
    self.numeratorLabel.text = (NSString*)labelDetails[1];
    self.denominatorLabel.text = (NSString*)labelDetails[2];
    
    if (((NSString*)labelDetails[1]).length==0)
    {
        self.fractionView.hidden = YES;
    }
    else
    {
        self.fractionView.hidden = NO;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)continueTapGesture:(id)sender {
    DLog(@"touched continue");
    [self performSegueWithIdentifier:@"seguePreheat" sender:self];
}

- (IBAction)selectorPanGesture:(id)sender {
   
    UIPanGestureRecognizer* gesture = (UIPanGestureRecognizer*)sender;
    UIView* v = gesture.view;
    CGFloat xTranslation = [gesture translationInView:self.donenessSelectionsView].x;
    CGFloat newXOrigin = _startingSelectorXOrigin + xTranslation;
    
    if (gesture.state == UIGestureRecognizerStateBegan)
    {
        _startingSelectorXOrigin = v.frame.origin.x;
    }
    else
    {
        CGRect frame = v.frame;
        frame.origin.x = newXOrigin;
        [v setFrame:frame];

        float shortestDistance=MAXFLOAT;
        uint8_t shortestDistanceIndex=0;
        
        for (uint8_t i=0; i < _temperatureXOrigins.count; i++)
        {
            float distance = fabs(newXOrigin - [_temperatureXOrigins[i] floatValue]) ;
            if (distance < shortestDistance)
            {
                shortestDistance = distance;
                shortestDistanceIndex = i;
            }
        }
        
        NSLog(@"shortest origin distance: (st:%f, x: %f, dist:%f, ix: %d)", _startingSelectorXOrigin, newXOrigin, shortestDistance, shortestDistanceIndex);
        
        _currentTemperature = [NSNumber numberWithDouble:[_beefCookingMethod.donenesses[shortestDistanceIndex] doubleValue]];
        
        if (gesture.state == UIGestureRecognizerStateEnded)
        {
            CGRect finalFrame = v.frame;
            finalFrame.origin.x = [_temperatureXOrigins[shortestDistanceIndex] floatValue];
            [v setFrame:finalFrame];
        }
        [self updateLabels];
    }
    
}

- (IBAction)thicknessPanGesture:(id)sender {
    UIPanGestureRecognizer* gesture = (UIPanGestureRecognizer*)sender;
    
    CGFloat yTranslation =[gesture translationInView:gesture.view.superview].y;
    CGFloat yGestureLocation = [gesture locationInView:gesture.view.superview].y;
    CGFloat newOrigin = _startingOrigin + yTranslation;
    CGFloat newHeight = _startingHeight - yTranslation;
    
    if (gesture.state == UIGestureRecognizerStateBegan)
    {
        _startingHeight = self.thicknessSelectionView.frame.size.height;
        _startingOrigin = self.thicknessSelectionView.frame.origin.y;
    }
    else if (newOrigin > _yBoundsTop && newOrigin < _yBoundsBottom)
    {
        CGRect frame = self.thicknessSelectionView.frame;
        frame.origin.y = newOrigin;
        frame.size.height = newHeight;
        
        _currentThickness =[NSNumber numberWithDouble:[self meatThicknessWithActualViewHeight:frame.size.height]];
        
        self.beefSizeVerticalConstraint.constant =  newOrigin - (self.timeTemperatureView.frame.origin.y + self.timeTemperatureView.frame.size.height);
        [self.thicknessSelectionView needsUpdateConstraints];
        [self.thicknessSelectionView setFrame:frame];
        [self updateLabels];
    }
    
}

- (double) meatThicknessWithActualViewHeight: (CGFloat)height
{
    int index = floor((height-_meatHeightOffset)/(_maxHeight-_meatHeightOffset) * _beefCookingMethod.thicknesses.count);
    if (index < _beefCookingMethod.thicknesses.count)
    {
        NSNumber *thickness = [_beefCookingMethod.thicknesses objectAtIndex:index];
        return [thickness doubleValue];
    }
    return 0;
}

@end
