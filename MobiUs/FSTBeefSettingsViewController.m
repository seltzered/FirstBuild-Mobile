//
//  FSTBeefSettingsViewController.m
//  FirstBuild
//
//  Created by Myles Caley on 5/12/15.
//  Copyright (c) 2015 FirstBuild. All rights reserved.
//

#import "FSTBeefSettingsViewController.h"
#import "FSTBeefSousVideCookingMethod.h"
#import "FSTReadyToPreheatViewController.h"

@interface FSTBeefSettingsViewController ()

@property (strong, nonatomic) IBOutlet UIView *thicknessSelectionView;
@property (strong, nonatomic) IBOutlet UIView *meatView;

@end

const uint8_t TEMPERATURE_START_INDEX = 6;

@implementation FSTBeefSettingsViewController
{
    //starting height of the view for the thickness pan gesture
    CGFloat _startingHeight;
    
    //starting origin of the view for the thickness pan gesture
    CGFloat _startingOrigin;
    
    //max height the thickness view can go
    CGFloat _maxHeight;
    
    //where does the meat view actually start.
    CGFloat _meatHeightOffset;
    
    //bounding of the thickness view top
    CGFloat _yBoundsTop;
    
    //bounding of the thickness view bottom
    CGFloat _yBoundsBottom;
    
    //data values for corresponding view relationships
    NSNumber* _currentThickness;
    NSNumber* _currentTemperature;
    FSTBeefSousVideCookingMethod* _beefCookingMethod;
    
    //where is the selector view positioned for the selector pan gesture
    CGFloat _startingSelectorXOrigin;
    
    //array of possible cook times for the selected temperature
    NSArray* _currentCookTimeArray;
    
    //array of the X origins for the donesness views; storyboard defines these
    //ensure the doneness objects in the corresponding model object line up
    NSMutableArray* _temperatureXOrigins;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    //create a new cooking session and a single stage cook
    [self.currentParagon.currentCookingMethod createCookingSession];
    [self.currentParagon.currentCookingMethod addStageToCookingSession];
}

- (void)viewDidAppear:(BOOL)animated
{
    
    //how big can the thickness selection view grow
    _maxHeight = self.thicknessSelectionView.frame.size.height;
    
    //where does the actual view for the meat start
    _meatHeightOffset = self.meatView.frame.origin.y;
    
    //set the bounds to which the entire set of things in the thickness view can move
    //need to restrict the bottom by subtracting the height (y origin of meat portion of view)
    //that way the meat view doesnt go out of the southern bounds
    _yBoundsTop = self.thicknessSelectionView.frame.origin.y;
    _yBoundsBottom = (_yBoundsTop + _maxHeight) - _meatHeightOffset;
    
    //set up or data objects
    _beefCookingMethod = [[FSTBeefSousVideCookingMethod alloc]init];
    _currentThickness =[NSNumber numberWithDouble:[self meatThicknessWithSliderValue:self.thicknessSlider.value]];
    _currentTemperature = [NSNumber numberWithDouble:[_beefCookingMethod.donenesses[TEMPERATURE_START_INDEX] doubleValue]];
    _currentCookTimeArray = ((NSArray*)([[_beefCookingMethod.cookingTimes objectForKey:_currentTemperature] objectForKey:_currentThickness]));
    [self updateLabels];
    
    //loop through all of the subviews of the different temperatures and add their X origin to
    //an array of locations to be later used for a loop
    /*_temperatureXOrigins = [[NSMutableArray alloc]init];
    for (uint8_t i=0; i< self.donenessSelectionsView.subviews.count; i++)
    {
        NSNumber* originX = [[NSNumber alloc] initWithFloat:((UIView*)(self.donenessSelectionsView.subviews[i])).frame.origin.x];
        DLog(@"originX %@", originX);
        [_temperatureXOrigins insertObject:originX atIndex:i];
    }*/
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
    /*NSArray* labelDetails = (NSArray*)([_beefCookingMethod.thicknessLabels objectForKey:_currentThickness]);
    
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
    }*/
    
    NSMutableAttributedString* thicknessString = [[NSMutableAttributedString alloc] initWithString:[_currentThickness stringValue] attributes:labelFontDict];
    NSMutableAttributedString* thicknessStringTag = [[NSMutableAttributedString alloc] initWithString:@"\" Thickness" attributes:labelFontDict];
    [thicknessString appendAttributedString:thicknessStringTag];
    // number then '" Thickness'
    
    [self.thicknessLabel setAttributedText:thicknessString];
    
    // label above doneness slider
    [self.donenessLabel setAttributedText:[[NSAttributedString alloc] initWithString:[_beefCookingMethod.donenessLabels objectForKey:_currentTemperature]]];
    NSLog(@" %@\n", self.donenessLabel);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)continueTapGesture:(id)sender {
    FSTParagonCookingStage* stage = (FSTParagonCookingStage*)(self.currentParagon.currentCookingMethod.session.paragonCookingStages[0]);
    stage.targetTemperature = _currentTemperature;
    double cookingMinutes = ([(NSNumber*)_currentCookTimeArray[0] integerValue] * 60) + ([(NSNumber*)_currentCookTimeArray[1] integerValue]);
    stage.cookTimeRequested = [NSNumber numberWithDouble:cookingMinutes];
    stage.cookingLabel = [NSString stringWithFormat:@"%@ (%@)",@"Steak",[_beefCookingMethod.donenessLabels objectForKey:_currentTemperature]];
    [self performSegueWithIdentifier:@"seguePreheat" sender:self];
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{    
    if ([segue.destinationViewController isKindOfClass:[FSTReadyToPreheatViewController class]])
    {
        //TODO HACK 
        FSTParagonCookingStage* stage = (FSTParagonCookingStage*)(self.currentParagon.currentCookingMethod.session.paragonCookingStages[0]);
        [self.currentParagon startHeatingWithTemperature:stage.targetTemperature];

        ((FSTReadyToPreheatViewController*)segue.destinationViewController).currentParagon = self.currentParagon;
    }
}
- (IBAction)donenessSlid:(id)sender {
    
    UISlider* slider = sender;
    uint8_t donenessIndex;
    donenessIndex = floor((_beefCookingMethod.donenesses.count - 1)*slider.value); // donenesses mapped to the slider
    _currentTemperature = [NSNumber numberWithDouble:[_beefCookingMethod.donenesses[donenessIndex] doubleValue]];
    _currentCookTimeArray = ((NSArray*)([[_beefCookingMethod.cookingTimes objectForKey:_currentTemperature] objectForKey:_currentThickness]));
    [self updateLabels];
}

/*- (IBAction)selectorPanGesture:(id)sender {
   
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

        _currentTemperature = [NSNumber numberWithDouble:[_beefCookingMethod.donenesses[shortestDistanceIndex] doubleValue]];
        _currentCookTimeArray = ((NSArray*)([[_beefCookingMethod.cookingTimes objectForKey:_currentTemperature] objectForKey:_currentThickness]));
        
        if (gesture.state == UIGestureRecognizerStateEnded)
        {
            CGRect finalFrame = v.frame;
            finalFrame.origin.x = [_temperatureXOrigins[shortestDistanceIndex] floatValue];
            [v setFrame:finalFrame];
        }
        [self updateLabels];
    }
    
}*/

- (IBAction)thicknessSlid:(id)sender {
    // used the thicknessSlider
    UISlider* slider = sender; // get the slider
    _currentThickness =[NSNumber numberWithDouble:[self meatThicknessWithSliderValue: slider.value]];
    _currentCookTimeArray = ((NSArray*)([[_beefCookingMethod.cookingTimes objectForKey:_currentTemperature] objectForKey:_currentThickness]));
    [self updateLabels];
}

/*- (IBAction)thicknessPanGesture:(id)sender {
    UIPanGestureRecognizer* gesture = (UIPanGestureRecognizer*)sender;
    
    CGFloat yTranslation =[gesture translationInView:gesture.view.superview].y;
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
        _currentCookTimeArray = ((NSArray*)([[_beefCookingMethod.cookingTimes objectForKey:_currentTemperature] objectForKey:_currentThickness]));
        
        self.beefSizeVerticalConstraint.constant =  newOrigin - (self.timeTemperatureView.frame.origin.y + self.timeTemperatureView.frame.size.height);
        [self.thicknessSelectionView needsUpdateConstraints];
        [self.thicknessSelectionView setFrame:frame];
        [self updateLabels];
    }
    
}*/

- (double) meatThicknessWithSliderValue: (CGFloat)value
{
    //find our closest index of thicknesss based on the height of the current view in relation
    //to the maximum size it can grow. that will then give a proportion we can use to search
    //in an array of thicknesses and find the closest one
    int index = floor(value*(_beefCookingMethod.thicknesses.count - 1));//floor((height-_meatHeightOffset)/(_maxHeight-_meatHeightOffset) * _beefCookingMethod.thicknesses.count); // just give it the range of a slider from 0 to 1. (need to subtract 1 to stay within bounds)
    if (index < _beefCookingMethod.thicknesses.count)
    {
        NSNumber *thickness = [_beefCookingMethod.thicknesses objectAtIndex:index];
        return [thickness doubleValue];
    }
    return 0;
}

@end
