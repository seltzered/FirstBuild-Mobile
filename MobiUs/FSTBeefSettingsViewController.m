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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
        
        NSLog(@"start (frame o:%f,s:%f) (bounds o:%f, s:%f) (top: %f,bottom: %f)", self.thicknessSelectionView.frame.origin.y, self.thicknessSelectionView.frame.size.height, self.thicknessSelectionView.bounds.origin.y, self.thicknessSelectionView.bounds.size.height,_yBoundsTop,_yBoundsBottom);
    }
    else if (newOrigin > _yBoundsTop && newOrigin < _yBoundsBottom)
    {
        CGRect frame = self.thicknessSelectionView.frame;
        frame.origin.y = newOrigin;
        frame.size.height = newHeight;
        [self.thicknessSelectionView setFrame:frame];
        
         NSLog(@"translation: %f, gesture y %f, new y %f, new height %f, converted %f", yTranslation, yGestureLocation,frame.origin.y, frame.size.height, [self meatThicknessWithActualViewHeight:frame.size.height]);
    }
}

- (CGFloat) meatThicknessWithActualViewHeight: (CGFloat)height
{
    int index = floor((height-_meatHeightOffset)/(_maxHeight-_meatHeightOffset) * _beefCookingMethod.thicknesses.count);
    if (index < _beefCookingMethod.thicknesses.count)
    {
        NSNumber *thickness = [_beefCookingMethod.thicknesses objectAtIndex:index];
        return [thickness floatValue];
    }
    return 0;
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
