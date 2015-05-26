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

@implementation FSTBeefSettingsViewController
{
    CGFloat _startingHeight;
    CGFloat _startingOrigin;
    CGFloat _maxHeight;
    CGFloat _meatHeightOffset;
    CGFloat _yBoundsTop;
    CGFloat _yBoundsBottom;
    FSTBeefSousVideCookingMethod* _beefCookingMethod;
    
    NSNumber* _currentThickness;
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
}

- (void)drawBeefSettingsLabel
{
    UIFont *timeFont = [UIFont fontWithName:@"PT Sans Narrow" size:18.0];
    NSDictionary *timeFontDict = [NSDictionary dictionaryWithObject: timeFont forKey:NSFontAttributeName];
    
    UIFont *labelFont = [UIFont fontWithName:@"PT Sans Narrow" size:13.0];
    NSDictionary *labelFontDict = [NSDictionary dictionaryWithObject: labelFont forKey:NSFontAttributeName];
    
    
    NSNumber* hour = (NSNumber*)(((NSArray*)([[_beefCookingMethod.cookingTimes objectForKey:@143.5] objectForKey:_currentThickness]))[1]);
    
    DLog(@"val: %@", hour);
    
    NSMutableAttributedString *hourString = [[NSMutableAttributedString alloc] initWithString:[hour stringValue] attributes: timeFontDict];
    NSMutableAttributedString *hourLabel = [[NSMutableAttributedString alloc] initWithString:@"H" attributes: labelFontDict];
    
    [hourString appendAttributedString:hourLabel];

    self.beefSettingsLabel.text = [hour stringValue];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)continueTapGesture:(id)sender {
    NSLog(@"touched continue");
    [self performSegueWithIdentifier:@"seguePreheat" sender:self];
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
        
        DLog(@"start (frame o:%f,s:%f) (bounds o:%f, s:%f) (top: %f,bottom: %f)", self.thicknessSelectionView.frame.origin.y, self.thicknessSelectionView.frame.size.height, self.thicknessSelectionView.bounds.origin.y, self.thicknessSelectionView.bounds.size.height,_yBoundsTop,_yBoundsBottom);
    }
    else if (newOrigin > _yBoundsTop && newOrigin < _yBoundsBottom)
    {
        CGRect frame = self.thicknessSelectionView.frame;
        frame.origin.y = newOrigin;
        frame.size.height = newHeight;
        
        _currentThickness =[NSNumber numberWithDouble:[self meatThicknessWithActualViewHeight:frame.size.height]];
        
        DLog(@"translation: %f, gesture y %f, new y %f, new height %f, converted %@", yTranslation, yGestureLocation,frame.origin.y, frame.size.height, _currentThickness);
        
        self.beefSizeVerticalConstraint.constant =  newOrigin - (self.timeTemperatureView.frame.origin.y + self.timeTemperatureView.frame.size.height);
        [self.thicknessSelectionView needsUpdateConstraints];
        [self.thicknessSelectionView setFrame:frame];
        [self drawBeefSettingsLabel];
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
