//
//  FSTOpalScheduleViewController.m
//  FirstBuild
//
//  Created by Gina on 6/14/16.
//  Copyright © 2016 FirstBuild. All rights reserved.
//

#import "MobiNavigationController.h"
#import "FSTOpalScheduleViewController.h"

@interface FSTOpalScheduleViewController ()

//@property (weak, nonatomic) IBOutlet UIView *viewList;
@property (strong, nonatomic) NSMutableDictionary *frames;
@property (strong, nonatomic) NSString *selected;

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
  
  // Today
  NSUInteger _today;
  
  // Schedule
  NSMutableArray *_schedule;
}

- (void)viewDidLoad {
  
  [super viewDidLoad];
  
  _days = @[_buttonSunday, _buttonMonday, _buttonTuesday, _buttonWednesday, _buttonThursday, _buttonFriday, _buttonSaturday];
  _hours = @[_buttonMidnight, _button1am, _button2am, _button3am, _button4am, _button5am, _button6am, _button7am, _button8am, _button9am, _button10am, _button11am, _buttonNoon, _button1pm, _button2pm, _button3pm, _button4pm, _button5pm, _button6pm, _button7pm, _button8pm, _button9pm, _button10pm, _button11pm];
  
  _schedule = [[NSMutableArray alloc] init];
  
  
  // Do any additional setup after loading the view.
//  self.frames = [[NSMutableDictionary alloc] init];
  
//  UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(dragged:)];
//  UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped:)];
//  [self.view addGestureRecognizer:pan];
//  [self.view addGestureRecognizer:tap];
//  
//  [self addDots];
  
  
}

- (void)didReceiveMemoryWarning {
  
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
  
}

- (void)viewWillAppear:(BOOL)animated {
  
  MobiNavigationController* navigation = (MobiNavigationController*)self.navigationController;
  [navigation setHeaderText:@"EDIT SCHEDULE" withFrameRect:CGRectMake(0, 0, 160, 40)];
  
  [self getSchedule];
  
}

- (void)viewDidAppear:(BOOL)animated {
  
  [self updateData];
  [self updateToday];
}

- (void)viewWillDisappear:(BOOL)animated {
  [self.opal configureSchedule:[self createData]];
}

- (void)getSchedule
{
  // make schedule to daily.
  NSMutableString *sun = [[NSMutableString alloc] init];
  NSMutableString *mon = [[NSMutableString alloc] init];
  NSMutableString *tue = [[NSMutableString alloc] init];
  NSMutableString *wed = [[NSMutableString alloc] init];
  NSMutableString *thu = [[NSMutableString alloc] init];
  NSMutableString *fri = [[NSMutableString alloc] init];
  NSMutableString *sat = [[NSMutableString alloc] init];
  
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
  
  [_schedule addObject:sun];
  [_schedule addObject:mon];
  [_schedule addObject:tue];
  [_schedule addObject:wed];
  [_schedule addObject:thu];
  [_schedule addObject:fri];
  [_schedule addObject:sat];
  
  NSLog(@"gina] schedule converted \n%@", _schedule);
}

- (void)updateToday {
  
  // get today's day of week
  NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
  NSDateComponents *comps = [gregorian components:NSCalendarUnitWeekday fromDate:[NSDate date]];
  NSUInteger weekday = [comps weekday];
  _today = weekday - 1; // make it to index
  
  [self setSelected:YES to:[_days objectAtIndex:_today]];
  [self updateTime:_today];
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

- (void)setSelected:(BOOL)on to:(UIButton*)button {
  
  if(on){
    [button setBackgroundColor:[self selectedColor]];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
  }
  else {
    [button setBackgroundColor:[self unselectedColor]];
    [button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
  }
}

- (void)addDots
{
//  NSArray *orderHour = @[@4, @5, @6, @7, @8, @9, @10, @11, @12, @13, @14, @15, @16, @17, @18, @19, @20, @21, @22, @23, @0, @1, @2, @3];
//  
//  for(int hour = 1; hour <= 24; hour++) {
//    for(int day = 1; day <= 7; day++) {
//      
//      UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 6, 6)];
//      [label setTranslatesAutoresizingMaskIntoConstraints:NO];
//      [label setBackgroundColor:[self nonSelectedColor]];
//      [label setClipsToBounds:YES];
//      [label setUserInteractionEnabled:NO];
//      [[label layer] setCornerRadius:5];
//      
//      NSLayoutConstraint *width = [NSLayoutConstraint constraintWithItem:label attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:10];
//      NSLayoutConstraint *height = [NSLayoutConstraint constraintWithItem:label attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:10];
//      [label addConstraints:@[width, height]];
//      
//      NSUInteger selectedHour = [[orderHour objectAtIndex:(hour-1)] unsignedIntegerValue];
//      NSUInteger tag = (((selectedHour)*10)+day);
//      [label setTag:tag];
//      [self.viewList addSubview:label];
//      
//      CGFloat x = ((double)hour/24.3);
//      CGFloat y = ((double)day/7.4);
//  
//      NSLayoutConstraint *xPos = [NSLayoutConstraint constraintWithItem:label attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.viewList attribute:NSLayoutAttributeBottom multiplier:x constant:0];
//      NSLayoutConstraint *yPos = [NSLayoutConstraint constraintWithItem:label attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.viewList attribute:NSLayoutAttributeTrailing multiplier:y constant:0];
//      
//      [self.viewList addConstraints:@[xPos, yPos]];
//      [self.frames setObject:[NSValue valueWithCGPoint:CGPointMake((day-1), (hour-1))] forKey:[NSString stringWithFormat:@"%ld", tag]];
//    }
//  }
}

- (void)tapped:(UITapGestureRecognizer *)gesture {
  
  NSLog(@"taped!");
//  CGPoint pos = [gesture locationInView:self.viewList];
//  if(pos.y < 0) {
//    // out of range
//  }
//  else {
//    NSString *tag = [self getTag:pos];
//    [self toggleBackground:tag];
//    self.selected = nil;
//  }
}

- (void)dragged:(UIPanGestureRecognizer *)gesture {
  
//  if(gesture.state == UIGestureRecognizerStateEnded) {
//    
//    self.selected = nil;
//  }
//  else {
//    
////    CGPoint vel = [gesture velocityInView:self.viewList];
////    NSLog(@"vert? %@", (vel.y > vel.x)? @"yes":@"no");
////    
//    CGPoint pos = [gesture locationInView:self.viewList];
//    
//    if(pos.y < 0) {
//      // out of range
//    }
//    else {
//      NSString *tag = [self getTag:pos];
//      [self toggleBackground:tag];
//    }
//  }
}

- (void)updateData {
  
  for(int i=1; i<=237; i++) { //237 - last tag number of dots. 23 - hour, 7 day(sat)
    
    int day = i%10;
    
    if(day > 0 && day < 8) {
      
      int hour = (i-day) / 10;
      NSString *time = [self.opal.schedules objectAtIndex:hour];
      
      NSString *indexed= [time substringWithRange:NSMakeRange((day-1), 1)];
      
      BOOL on = ([indexed isEqualToString:@"1"])?YES:NO;
      
      [self schdule:i shouldOn:on];
    }
  }
}

- (NSString *)getTag:(CGPoint)point {

//  CGFloat targetWidth = self.viewList.frame.size.width;//+100;
//  CGFloat targetHeight = self.viewList.frame.size.height+25; // 25 day title height
//  
//  CGFloat x = round(((point.x-40) / targetWidth) * 7);
//  CGFloat y = round((point.y / (targetHeight)) * 24);
//  
//  for(NSValue *point in [self.frames allValues]) {
//    
//    CGPoint conv = point.CGPointValue;
//    
//    if(conv.x == x && conv.y == y){
//      NSArray *list = [self.frames allKeysForObject:point];
//      return  [list objectAtIndex:0];
//    }
//    
//  }
  return nil;
}

- (void)toggleBackground:(NSString *)tag {
  
//  if([self.selected isEqualToString:tag]) {
//    // ignore
//  }
//  else {
//    if(tag.length == 0){
//      // ignore
//    }
//    else {
//      
//      NSLog(@"update the button. %@", tag);
//      int intTag = [tag intValue];
//      UILabel *label = (UILabel *)[self.viewList viewWithTag:intTag];
//      UIColor *color = [label backgroundColor];
//      
//      if([color isEqual:[self nonSelectedColor]]){
//        [self schdule:intTag shouldOn:YES];
//      }
//      else {
//        [self schdule:intTag shouldOn:NO];
//      }
//
//      self.selected = tag;
//    }
//  }
}

- (void)schdule:(int)tag shouldOn:(BOOL)on
{
//  if(tag == 0) {
//    //ignore
//  }
//  else {
//    UILabel *label = (UILabel *)[self.viewList viewWithTag:tag];
//    if(on) {
//      label.backgroundColor = [self selectedColor];
//    }
//    else {
//      label.backgroundColor = [self nonSelectedColor];
//    }
//  }
}

- (NSArray *)createData {
//  NSMutableString *data = [[NSMutableString alloc] init];
//  
//  for(int i=1; i<=237; i++) { //237 - last tag number of dots. 23 - hour, 7 day(sat)
//    
//    int day = i%10;
//    
//    if(day > 0 && day < 8) {
//      
//      UILabel *label = (UILabel *)[self.viewList viewWithTag:i];
//      BOOL isSelected = [label.backgroundColor isEqual:[self selectedColor]];
//      
//      [data appendString:(isSelected)?@"1":@"0"];
//      
//      if(day == 7 && i != 237){
//        [data appendString:@"\n"];
//      }
//    }
//  }
//  
//  NSArray *array = [data componentsSeparatedByString:@"\n"];
//  return array;
    return nil;
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
