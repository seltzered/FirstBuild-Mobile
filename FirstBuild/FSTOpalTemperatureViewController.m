//
//  FSTOpalTemperatureViewController.m
//  FirstBuild
//
//  Created by Myles Caley on 5/23/16.
//  Copyright © 2016 FirstBuild. All rights reserved.
//

#import "FSTOpalTemperatureViewController.h"

@interface FSTOpalTemperatureViewController ()
@property (weak, nonatomic) IBOutlet BEMSimpleLineGraphView *graphView;
@property (strong, nonatomic) IBOutlet UILabel *labelDates;
@property (strong, nonatomic) IBOutlet UILabel *labelValues;

@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@end

@implementation FSTOpalTemperatureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.opal.delegate = self;
    self.graphView.dataSource = self;
    self.graphView.delegate = self;
    self.graphView.enableTouchReport = YES;
    if (self.opal.temperatureHistory.count > 1) {
      self.activityIndicator.hidden = YES;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfPointsInLineGraph:(BEMSimpleLineGraphView *)graph
{
  return self.opal.temperatureHistory.count;
}

- (CGFloat)lineGraph:(BEMSimpleLineGraphView *)graph valueForPointAtIndex:(NSInteger)index {
  
  CGFloat value = [[self.opal.temperatureHistory objectAtIndex:index] floatValue];
  return value;

}

- (NSString *)labelForDateAtIndex:(NSInteger)index {
  NSDate *date = self.opal.temperatureHistoryDates[index];
  NSDateFormatter *df = [[NSDateFormatter alloc] init];
  df.dateFormat = @"h:mm:ss";
  NSString *label = [df stringFromDate:date];
  return label;
}

- (NSInteger)numberOfGapsBetweenLabelsOnLineGraph:(BEMSimpleLineGraphView *)graph {
  return 2;
}

- (NSString *)lineGraph:(BEMSimpleLineGraphView *)graph labelOnXAxisForIndex:(NSInteger)index {
  
  NSString *label = [self labelForDateAtIndex:index];
  return [label stringByReplacingOccurrencesOfString:@" " withString:@"\n"];
}

- (void)lineGraph:(BEMSimpleLineGraphView *)graph didTouchGraphWithClosestIndex:(NSInteger)index {
  self.labelValues.text = [NSString stringWithFormat:@"%@", [self.opal.temperatureHistory objectAtIndex:index]];
  self.labelDates.text = [NSString stringWithFormat:@"%@", [self labelForDateAtIndex:index]];
}

- (void)lineGraph:(BEMSimpleLineGraphView *)graph didReleaseTouchFromGraphWithClosestIndex:(CGFloat)index {
//  [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
//    self.labelValues.alpha = 0.0;
//    self.labelDates.alpha = 0.0;
//  } completion:^(BOOL finished) {
//    self.labelValues.text = [NSString stringWithFormat:@"%i", [[self.myGraph calculatePointValueSum] intValue]];
//    self.labelDates.text = [NSString stringWithFormat:@"between %@ and %@", [self labelForDateAtIndex:0], [self labelForDateAtIndex:self.arrayOfDates.count - 1]];
//    
//    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
//      self.labelValues.alpha = 1.0;
//      self.labelDates.alpha = 1.0;
//    } completion:nil];
//  }];
}

- (void)lineGraphDidFinishLoading:(BEMSimpleLineGraphView *)graph {
//  self.labelValues.text = [NSString stringWithFormat:@"%i", [[self.myGraph calculatePointValueSum] intValue]];
//  self.labelDates.text = [NSString stringWithFormat:@"between %@ and %@", [self labelForDateAtIndex:0], [self labelForDateAtIndex:self.arrayOfDates.count - 1]];
}


- (IBAction)cancelTap:(id)sender
{
  [self dismissViewControllerAnimated:YES completion:nil];
}

-(void) iceMakerTemperatureChanged:(int)temperature
{
  if (self.opal.temperatureHistory.count > 1) {
    self.activityIndicator.hidden = YES;
  }
  [self.graphView reloadGraph];
}


@end
