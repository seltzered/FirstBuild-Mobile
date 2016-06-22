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

@property (weak, nonatomic) IBOutlet UIView *viewList;
@property (strong, nonatomic) NSMutableDictionary *frames;
@property (strong, nonatomic) NSString *selected;

@end

@implementation FSTOpalScheduleViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  
  // Do any additional setup after loading the view.
  self.frames = [[NSMutableDictionary alloc] init];
  
  UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(dragged:)];
  UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped:)];
  [self.view addGestureRecognizer:pan];
  [self.view addGestureRecognizer:tap];
  
  [self addDots];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
  MobiNavigationController* navigation = (MobiNavigationController*)self.navigationController;
  [navigation setHeaderText:@"SCHEDULE" withFrameRect:CGRectMake(0, 0, 160, 40)];
}

- (void)viewDidAppear:(BOOL)animated {
  [self updateData];
}

- (void)dealloc {
  
}

- (void)addDots
{
  NSArray *orderHour = @[@4, @5, @6, @7, @8, @9, @10, @11, @12, @13, @14, @15, @16, @17, @18, @19, @20, @21, @22, @23, @0, @1, @2, @3];
  
//  CGFloat eachWidth = (self.viewList.frame.size.width)/7;
//  CGFloat eachHeight = (self.viewList.frame.size.height)/24;
  
  for(int hour = 1; hour <= 24; hour++) {
    
    for(int day = 1; day <= 7; day++) {
      
      UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 6, 6)];
      [label setTranslatesAutoresizingMaskIntoConstraints:NO];
      [label setBackgroundColor:[UIColor redColor]];
      [label setClipsToBounds:YES];
      [label setUserInteractionEnabled:NO];
      [[label layer] setCornerRadius:3];
      
      NSLayoutConstraint *width = [NSLayoutConstraint constraintWithItem:label attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:6];
      NSLayoutConstraint *height = [NSLayoutConstraint constraintWithItem:label attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:6];
      [label addConstraints:@[width, height]];
      
      NSUInteger selectedHour = [[orderHour objectAtIndex:(hour-1)] unsignedIntegerValue];
      NSUInteger tag = (((selectedHour)*10)+day);
      [label setTag:tag];
      
      [self.viewList addSubview:label];
      
      CGFloat x = ((double)hour/24.5);
      CGFloat y = ((double)day/7.5);
  
      NSLayoutConstraint *xPos = [NSLayoutConstraint constraintWithItem:label attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.viewList attribute:NSLayoutAttributeBottom multiplier:x constant:0];
      NSLayoutConstraint *yPos = [NSLayoutConstraint constraintWithItem:label attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.viewList attribute:NSLayoutAttributeTrailing multiplier:y constant:0];
      
      [self.viewList addConstraints:@[xPos, yPos]];
      [self.frames setObject:[NSValue valueWithCGPoint:CGPointMake((day-1), (hour-1))] forKey:[NSString stringWithFormat:@"%ld", tag]];
    }
  }
}

- (void)tapped:(UITapGestureRecognizer *)gesture {
  
  CGPoint pos = [gesture locationInView:self.viewList];
  if(pos.x < 0 || pos.y < 0) {
    NSLog(@"out of range");
  }
  else {
    NSString *tag = [self getTag:pos];
    [self toggleBackground:tag];
    self.selected = nil;
  }
}

- (void)dragged:(UIPanGestureRecognizer *)gesture {
  
  if(gesture.state == UIGestureRecognizerStateEnded) {
    self.selected = nil;
  }
  else {
//    CGPoint vel = [gesture velocityInView:self.viewList];
//    NSLog(@"vert? %@", (vel.y > vel.x)? @"yes":@"no");
//    
    CGPoint pos = [gesture locationInView:self.viewList];
    if(pos.x < 0 || pos.y < 0) {
      NSLog(@"out of range");
    }
    else {
      NSString *tag = [self getTag:pos];
      [self toggleBackground:tag];
    }
  }
}

- (void)updateData {
  NSLog(@"schedule set as: %@", self.opal.schedules);
  
  for(int j=1; j<=7; j++) {
    
    NSString *time = [self.opal.schedules objectAtIndex:(j-1)];
    
    for(int i=0; i<24; i++) {
      
      NSString *indexed = [time substringWithRange:NSMakeRange(i, 1)];
      int tag = (i*10)+j;
      BOOL on = ([indexed isEqualToString:@"1"])?YES:NO;
      
      [self schdule:tag shouldOn:on];
    }
  }
}

- (NSString *)getTag:(CGPoint)point
{
  CGPoint got = CGPointMake(round(point.x /7/7) , round(point.y /24));
  
  for(NSValue *point in [self.frames allValues]) {
    
    CGPoint conv = point.CGPointValue;
    
    if(conv.x == got.x && conv.y == got.y){
      NSArray *list = [self.frames allKeysForObject:point];
      return  [list objectAtIndex:0];
    }
    
  }
  return nil;
}

- (void)toggleBackground:(NSString *)tag {
  
  if([self.selected isEqualToString:tag]) {
    // ignore
  }
  else {
    if(tag.length == 0){
      // ignore
    }
    else {
      int intTag = [tag intValue];
      UILabel *label = (UILabel *)[self.viewList viewWithTag:intTag];
      UIColor *color = [label backgroundColor];
      
      if([color isEqual:[UIColor lightGrayColor]]){
        [self schdule:intTag shouldOn:YES];
      }
      else {
        [self schdule:intTag shouldOn:NO];
      }

      self.selected = tag;
    }
  }
}

- (void)schdule:(int)tag shouldOn:(BOOL)on
{
  if(tag == 0) {
    //ignore
  }
  else {
    UILabel *label = (UILabel *)[self.viewList viewWithTag:tag];
    if(on) {
      label.backgroundColor = [UIColor redColor];
    }
    else {
      label.backgroundColor = [UIColor lightGrayColor];
    }
  }
}

@end
