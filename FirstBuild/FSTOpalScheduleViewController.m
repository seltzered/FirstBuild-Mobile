//
//  FSTOpalScheduleViewController.m
//  FirstBuild
//
//  Created by Gina on 6/14/16.
//  Copyright © 2016 FirstBuild. All rights reserved.
//

#import "MobiNavigationController.h"
#import "FTSOpalScheduleInstructionViewcontroller.h"
#import "FSTOpalScheduleViewController.h"

@interface FSTOpalScheduleViewController ()
@end

@implementation FSTOpalScheduleViewController {
  
  // Days
  NSArray *_days;
  __weak IBOutlet UIButton *_buttonSunday;
  __weak IBOutlet UIButton *_buttonMonday;
  __weak IBOutlet UIButton *_buttonTuesday;
  __weak IBOutlet UIButton *_buttonWednesday;
  __weak IBOutlet UIButton *_buttonThursday;
  __weak IBOutlet UIButton *_buttonFriday;
  __weak IBOutlet UIButton *_buttonSaturday;
  
  NSArray *_labels;
  __weak IBOutlet UILabel *_labelSunday;
  __weak IBOutlet UILabel *_labelMonday;
  __weak IBOutlet UILabel *_labelTuesday;
  __weak IBOutlet UILabel *_labelWednesday;
  __weak IBOutlet UILabel *_labelThursday;
  __weak IBOutlet UILabel *_labelFriday;
  __weak IBOutlet UILabel *_labelSaturday;
  
  // Hours
  NSArray *_hours;
  __weak IBOutlet UIButton *_buttonMidnight;
  __weak IBOutlet UIButton *_button1am;
  __weak IBOutlet UIButton *_button2am;
  __weak IBOutlet UIButton *_button3am;
  __weak IBOutlet UIButton *_button4am;
  __weak IBOutlet UIButton *_button5am;
  __weak IBOutlet UIButton *_button6am;
  __weak IBOutlet UIButton *_button7am;
  __weak IBOutlet UIButton *_button8am;
  __weak IBOutlet UIButton *_button9am;
  __weak IBOutlet UIButton *_button10am;
  __weak IBOutlet UIButton *_button11am;
  __weak IBOutlet UIButton *_buttonNoon;
  __weak IBOutlet UIButton *_button1pm;
  __weak IBOutlet UIButton *_button2pm;
  __weak IBOutlet UIButton *_button3pm;
  __weak IBOutlet UIButton *_button4pm;
  __weak IBOutlet UIButton *_button5pm;
  __weak IBOutlet UIButton *_button6pm;
  __weak IBOutlet UIButton *_button7pm;
  __weak IBOutlet UIButton *_button8pm;
  __weak IBOutlet UIButton *_button9pm;
  __weak IBOutlet UIButton *_button10pm;
  __weak IBOutlet UIButton *_button11pm;
  
  __weak IBOutlet UIView *_viewHours;
  
  __weak IBOutlet UIButton *_buttonApplyAll;
  
  // Today
  NSUInteger _selectedDay;
  
  // Schedule
  NSMutableArray *_schedule;
  
  CGPoint _dragBegin;
}

- (void)viewDidLoad {
  
  [super viewDidLoad];
  
  _days = @[_buttonSunday, _buttonMonday, _buttonTuesday, _buttonWednesday, _buttonThursday, _buttonFriday, _buttonSaturday];
  _labels = @[_labelSunday, _labelMonday, _labelTuesday, _labelWednesday, _labelThursday, _labelFriday, _labelSaturday];
  _hours = @[_buttonMidnight, _button1am, _button2am, _button3am, _button4am, _button5am, _button6am, _button7am, _button8am, _button9am, _button10am, _button11am, _buttonNoon, _button1pm, _button2pm, _button3pm, _button4pm, _button5pm, _button6pm, _button7pm, _button8pm, _button9pm, _button10pm, _button11pm];
  
  _schedule = [[NSMutableArray alloc] init];
  
  UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(onTimeDragged:)];
  [_viewHours addGestureRecognizer:pan];
}

- (void)didReceiveMemoryWarning {
  
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  self.opal.delegate = self;
  
  MobiNavigationController* navigation = (MobiNavigationController*)self.navigationController;
  [navigation setHeaderText:@"EDIT SCHEDULE" withFrameRect:CGRectMake(0, 0, 160, 40)];
  
  // set question button
  UIBarButtonItem *instructionButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon-question"] style:UIBarButtonItemStylePlain target:self action:@selector(onQuestionPressed:)];
  self.navigationItem.rightBarButtonItem = instructionButton;
  
  [self getSchedule];
}

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  [self updateToday];
}

- (void)viewDidDisappear:(BOOL)animated {
  [self resetAllApplyButton];
  [super viewDidDisappear:animated];
}

- (void)getSchedule
{
  // make schedule to daily.
  NSMutableString *sun = [[NSMutableString alloc] initWithCapacity:24];
  NSMutableString *mon = [[NSMutableString alloc] initWithCapacity:24];
  NSMutableString *tue = [[NSMutableString alloc] initWithCapacity:24];
  NSMutableString *wed = [[NSMutableString alloc] initWithCapacity:24];
  NSMutableString *thu = [[NSMutableString alloc] initWithCapacity:24];
  NSMutableString *fri = [[NSMutableString alloc] initWithCapacity:24];
  NSMutableString *sat = [[NSMutableString alloc] initWithCapacity:24];
  
  for(NSString *times in self.opal.schedules) {
    
    for(int index = 0; index < times.length; index++){
      
      NSString *enabled = [times substringWithRange:NSMakeRange(index, 1)];
      if(index == 0) {
        [sun appendString:enabled];
      }
      else if(index == 1) {
        [mon appendString:enabled];
      }
      else if(index == 2) {
        [tue appendString:enabled];
      }
      else if(index == 3) {
        [wed appendString:enabled];
      }
      else if(index == 4) {
        [thu appendString:enabled];
      }
      else if(index == 5) {
        [fri appendString:enabled];
      }
      else if(index == 6) {
        [sat appendString:enabled];
      }
    }
  }
  
  if(_schedule.count > 0) {
    [_schedule removeAllObjects];
  }
  
  [_schedule addObject:sun];
  [_schedule addObject:mon];
  [_schedule addObject:tue];
  [_schedule addObject:wed];
  [_schedule addObject:thu];
  [_schedule addObject:fri];
  [_schedule addObject:sat];
  
  NSLog(@"schedule converted as daily \n%@", _schedule);
}

- (void)updateToday {
  
  // get today's day of week
  NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
  NSDateComponents *comps = [gregorian components:NSCalendarUnitWeekday fromDate:[NSDate date]];
  NSUInteger weekday = [comps weekday];
  _selectedDay = weekday - 1; // make it to index
  
  [self setDaySelected:_selectedDay];
  
  NSString *today = [_schedule objectAtIndex:_selectedDay];
  BOOL isAllSame = YES;
  
  // check schedule
  for(NSString *daily in _schedule) {
    
    if([today isEqualToString:daily] == NO) {
      isAllSame = NO;
      break;
    }
  }
  
  if(isAllSame) {
    [self updateDayDots];
    [self didAllApplied];
  }
}

- (void)updateTime:(NSUInteger)day {
  
  NSString *time = [_schedule objectAtIndex:day];
  
  for(int index = 0; index < time.length; index++){
    
    NSString *data = [time substringWithRange:NSMakeRange(index, 1)];
    UIButton *button = [_hours objectAtIndex:index];
    
    if([data isEqualToString:@"1"]){
      [self setSelected:YES to:button];
    }
    else {
      [self setSelected:NO to:button];
    }
  }
}

#pragma mark - selected
- (void)setDaySelected:(NSUInteger)day {
  
  _selectedDay = day;
  
  for(int index = 0; index < _days.count; index++){
    
    if(index == day) {
      [self setSelected:YES to:[_days objectAtIndex:index]];
      [self updateTime:index];
    }
    else {
      [self setSelected:NO to:[_days objectAtIndex:index]];
    }
  }
}

- (void)setSelected:(BOOL)on to:(UIButton*)button {
  
  if(on){
    NSLog(@"gina] %@ selected", button.titleLabel.text);
    [button setBackgroundColor:[self selectedColor]];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
  }
  else {
    NSLog(@"gina] %@ unselected", button.titleLabel.text);
    [button setBackgroundColor:[self unselectedColor]];
    [button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
  }
}

- (void)setDayData:(NSUInteger)index to:(BOOL)data {
  
  NSString *string = nil;
  if(data) {
    string = @"1";
  }
  else {
    string = @"0";
  }
  
  NSMutableString *daily = [[_schedule objectAtIndex:_selectedDay] mutableCopy];
  [daily replaceCharactersInRange:NSMakeRange(index, 1) withString:string];
  [_schedule replaceObjectAtIndex:_selectedDay withObject:daily];
  
  NSLog(@"updated! %@", _schedule);
  [self resetAllApplyButton];
  [self resetDayDots];
}

#pragma mark - buttons
- (IBAction)onDayPressed:(id)sender {
  
  NSUInteger index = [_days indexOfObject:sender];
  
  [self setDaySelected:index];
  
  if([_buttonApplyAll.backgroundColor isEqual:[self selectedColor]]){
    [self updateDayDots];
  }
}

- (IBAction)onTimePressed:(id)sender {
  
  UIButton *button = (UIButton *)sender;
  NSLog(@"%@ tapped!", button.titleLabel.text);
  
  BOOL data = NO;
  
  if([button.backgroundColor isEqual:[self selectedColor]]) {
    data = NO;
  }
  else {
    data = YES;
  }
  
  [self setSelected:data to:sender];

  NSUInteger index = [_hours indexOfObject:sender];
  [self setDayData:index to:data];
  [self sendData];
}

- (void)onTimeDragged:(UIPanGestureRecognizer *)gesture {
  
  if(gesture.state == UIGestureRecognizerStateBegan) {
    _dragBegin = [gesture locationInView:_viewHours];
    
    NSLog(@"gina] drag began %f %f", _dragBegin.x, _dragBegin.y);
  }
  else if(gesture.state == UIGestureRecognizerStateEnded){
    CGPoint end = [gesture locationInView:_viewHours];
    
    NSLog(@"gina] ended %f %f", end.x, end.y);
    [self getAreaFrom:_dragBegin to:end];
  }
}

- (void)getAreaFrom:(CGPoint)begin to:(CGPoint)end {
  
  if(begin.x < 0 || begin.y < 0 ||
     begin.x > _viewHours.frame.size.width ||  begin.y > _viewHours.frame.size.height) {
    NSLog(@"out of frame x: %f y: %f", begin.x, begin.y);
  }
  else {
    [self updateButtonsInArea:begin to:end];
  }
}

- (void)updateButtonsInArea:(CGPoint)begin to:(CGPoint)end {
  
  CGFloat startXPoint = floorf((begin.x / _viewHours.frame.size.width)* 3);
  CGFloat startYPoint = floorf((begin.y / _viewHours.frame.size.height) * 8);
  CGFloat endXPoint = floorf((end.x / _viewHours.frame.size.width)* 3);
  CGFloat endYPoint = floorf((end.y / _viewHours.frame.size.height) * 8);
  
  endXPoint = (endXPoint > 2)?2:endXPoint;
  endYPoint = (endYPoint > 7)?7:endYPoint;
  
  NSArray *indexes = @[@[@0, @1, @2], @[@3, @4, @5], @[@6, @7, @8], @[@9, @10, @11], @[@12, @13, @14], @[@15, @16, @17], @[@18, @19, @20], @[@21, @22, @23]];
  
  NSUInteger startIndex = [[[indexes objectAtIndex:startYPoint] objectAtIndex:startXPoint] unsignedIntegerValue];
  NSUInteger endIndex = [[[indexes objectAtIndex:endYPoint] objectAtIndex:endXPoint] unsignedIntegerValue];
  
  for(NSUInteger index = startIndex; index <= endIndex; index++) {
    UIButton *button = [_hours objectAtIndex:index];
    
    [self setSelected:YES to:button];
    [self setDayData:index to:YES];
  }
  
  [self sendData];
}

- (IBAction)onApplyAllPressed:(id)sender {
  
  [self updateDayDots];
  [_buttonApplyAll setUserInteractionEnabled:NO];
  
  NSMutableString *currentDayData = [_schedule objectAtIndex:_selectedDay];
  
  for(int index = 0; index < _schedule.count; index++) {
    
    if(index != _selectedDay) {
      [_schedule replaceObjectAtIndex:index withObject:currentDayData];
    }
  }
  
  [self sendData];
}

- (void)onQuestionPressed:(id)sender
{
  NSLog(@"gina] show instruction");
  // grab the view controller we want to show
  UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Opal" bundle:nil];
  UIViewController *controller = [storyboard instantiateViewControllerWithIdentifier:@"ScheduleInstruction"];
  
  controller.modalPresentationStyle = UIModalPresentationOverCurrentContext;
  [self presentViewController:controller animated:YES completion:nil];
}

#pragma mark - ui update
- (void)updateDayDots {
  for(int index = 0; index < _labels.count; index++){
    
    UILabel *label = [_labels objectAtIndex:index];
    
    if(index == _selectedDay) {
      [label setHidden:YES];
    }
    else {
      [label setHidden:NO];
    }
  }
}

- (void)resetDayDots {
  for(int index = 0; index < _labels.count; index++){
    
    UILabel *label = [_labels objectAtIndex:index];
    [label setHidden:YES];
  }
}

- (void)didAllApplied {
  
  [_buttonApplyAll setBackgroundColor:[self selectedColor]];
  [_buttonApplyAll setTitle:@"APPLIED ALL" forState:UIControlStateNormal];
  [_buttonApplyAll setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
  [_buttonApplyAll setUserInteractionEnabled:YES];
}

- (void)resetAllApplyButton {
  
  if([_buttonApplyAll.backgroundColor isEqual:[self selectedColor]]) {
    [_buttonApplyAll setBackgroundColor:[UIColor whiteColor]];
    [_buttonApplyAll setTitle:@"APPLY ALL DAYS" forState:UIControlStateNormal];
    [_buttonApplyAll setTitleColor:[self selectedColor] forState:UIControlStateNormal];
    [_buttonApplyAll setUserInteractionEnabled:YES];
  }
}

- (void)sendData {
  
  NSLog(@"created %@", [self createData]);
  [self.opal configureSchedule:[self createData]];
}

- (NSArray *)createData {
  
  NSMutableString *midnight = [[NSMutableString alloc] initWithCapacity:8];
  NSMutableString *oneAm = [[NSMutableString alloc] initWithCapacity:8];
  NSMutableString *twoAm = [[NSMutableString alloc] initWithCapacity:8];
  NSMutableString *threeAm = [[NSMutableString alloc] initWithCapacity:8];
  NSMutableString *fourAm = [[NSMutableString alloc] initWithCapacity:8];
  NSMutableString *fiveAm = [[NSMutableString alloc] initWithCapacity:8];
  NSMutableString *sixAm = [[NSMutableString alloc] initWithCapacity:8];
  NSMutableString *sevenAm = [[NSMutableString alloc] initWithCapacity:8];
  NSMutableString *eightAm = [[NSMutableString alloc] initWithCapacity:8];
  NSMutableString *nineAm = [[NSMutableString alloc] initWithCapacity:8];
  NSMutableString *tenAm = [[NSMutableString alloc] initWithCapacity:8];
  NSMutableString *elevenAm = [[NSMutableString alloc] initWithCapacity:8];
  NSMutableString *noon = [[NSMutableString alloc] initWithCapacity:8];
  NSMutableString *onePm = [[NSMutableString alloc] initWithCapacity:8];
  NSMutableString *twoPm = [[NSMutableString alloc] initWithCapacity:8];
  NSMutableString *threePm = [[NSMutableString alloc] initWithCapacity:8];
  NSMutableString *fourPm = [[NSMutableString alloc] initWithCapacity:8];
  NSMutableString *fivePm = [[NSMutableString alloc] initWithCapacity:8];
  NSMutableString *sixPm = [[NSMutableString alloc] initWithCapacity:8];
  NSMutableString *sevenPm = [[NSMutableString alloc] initWithCapacity:8];
  NSMutableString *eightPm = [[NSMutableString alloc] initWithCapacity:8];
  NSMutableString *ninePm = [[NSMutableString alloc] initWithCapacity:8];
  NSMutableString *tenPm = [[NSMutableString alloc] initWithCapacity:8];
  NSMutableString *elevenPm = [[NSMutableString alloc] initWithCapacity:8];

  NSArray *times = @[midnight, oneAm, twoAm, threeAm, fourAm, fiveAm, sixAm, sevenAm, eightAm, nineAm, tenAm, elevenAm,
                     noon, onePm, twoPm, threePm, fourPm, fivePm, sixPm, sevenPm, eightPm, ninePm, tenPm, elevenPm];
  
  // convert to daily
  for(NSString *daily in _schedule) {
    
    for(int index = 0; index < daily.length; index++) {
      
      NSString *selected = [daily substringWithRange:NSMakeRange(index, 1)];
      NSMutableString *string = [times objectAtIndex:index];
      
      [string appendString:selected];
    }
  }
  
  // Add zero at the end
  for(NSMutableString *string in times) {
    [string appendString:@"0"];
  }
  
  return @[midnight, oneAm, twoAm, threeAm, fourAm, fiveAm, sixAm, sevenAm, eightAm, nineAm, tenAm, elevenAm,
           noon, onePm, twoPm, threePm, fourPm, fivePm, sixPm, sevenPm, eightPm, ninePm, tenPm, elevenPm];
}

#pragma mark - opal delegate
- (void)iceMakerScheduleWritten: (NSError *)error {
  
  if(!_buttonApplyAll.isUserInteractionEnabled) {
    
    // update all apply button if only the button is pressed
    [self didAllApplied];
  }
}

- (UIColor *)selectedColor {
  return [UIColor colorWithRed:252.0f/255.0f green:88.0f/255.0f blue:45.0f/255.0f alpha:1];
}

- (UIColor *)unselectedColor {
  return [UIColor colorWithRed:239.0f/255.0f green:237.0f/255.0f blue:238.0f/255.0f alpha:1];
}

- (UIImage *)createImageFromColor:(UIColor *)color {
  
  CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f); // Don't need to bigger that it. The color is solid.

  UIGraphicsBeginImageContext(rect.size);
  CGContextRef context = UIGraphicsGetCurrentContext();
  CGContextSetFillColorWithColor(context, [color CGColor]);
  CGContextFillRect(context, rect);
  
  UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();
  
  return image;
}

@end
