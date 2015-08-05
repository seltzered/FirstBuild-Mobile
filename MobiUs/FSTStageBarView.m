//
//  FSTStageBarView.m
//  FirstBuild
//
//  Created by John Nolan on 7/14/15.
//  Copyright (c) 2015 FirstBuild. All rights reserved.
//

#import "FSTStageBarView.h"
#import "FSTStageCircleView.h"

@interface FSTStageBarView()

@property (nonatomic, strong) FSTStageCircleView* circleMarker;

@property (nonatomic) CGFloat lineWidth; // this was public before, could just be a global variable

@end

@implementation FSTStageBarView

CGFloat point1, point2, point3, point4;

-(id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViews];
    }
    return self;
}

-(void) awakeFromNib {
    [self setupViews];
}

-(void)setupViews { // could happen after init or awake from nib. Initialize subviews
    self.circleMarker = [[FSTStageCircleView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.height, self.bounds.size.height)]; // always proportional to height
    [self addSubview:self.circleMarker]; // create the circle marker
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.lineWidth = 4*self.bounds.size.width/5; //update scaled linewidth so subviews can match (same proportion set in drawRect, but with scaled up
    [self updateCircle];
}

- (void) updateCircle {
    CGFloat new_x = 0; // change x position of stageCircle
    CGFloat mid_x = self.bounds.size.width/2;
    CGFloat start_x = mid_x - self.lineWidth/2; //start of bar (line is slightly inset)
    switch (self.circleState) {
        case kPreheating:
            new_x = start_x; // beginning of bar
            break;
        case kReadyToCook:
            new_x = start_x + self.lineWidth/3;
            break;
        case kReachingMinimumTime:
            new_x = start_x + 2*self.lineWidth/3;
            break;
        case kReachingMaximumTime:
            new_x = start_x + self.lineWidth;
            break;
        case kPostMaximumTime:
            new_x = start_x + self.lineWidth;
            break;
        default:
            NSLog(@"NO STATE FOR STAGE BAR\n");
            break;
    }
    CGFloat new_w = self.bounds.size.height; // the circle is always 1 to 1 and fills the height
    [self.circleMarker setFrame:CGRectMake(new_x - new_w/2, 0, new_w, new_w)]; // set new circle frame with width and x value.
}
- (void)setCircleState:(ProgressState)circleState { // state changed externally
    _circleState = circleState;
    [self updateCircle];
}

- (void)drawRect:(CGRect)rect {
    // replaced self.frame with rect
    CGFloat x_start = rect.size.width/10; // the starting x coordinate (starts at beginning
    CGFloat x_end = rect.size.width - x_start;
    CGFloat width = x_end - x_start; // width of the whole line
    CGFloat y = rect.size.height/2; // mid point as every y coordinate
    UIBezierPath* underPath = [UIBezierPath bezierPath];
    CGFloat dotRadius = rect.size.height/8;
    
    self.lineWidth = width; // let the viewContoller access that for position calculations
    [underPath moveToPoint:CGPointMake(x_start, y)];
    [underPath addLineToPoint:CGPointMake(x_end, y)];
    [[UIColor lightGrayColor] setStroke];
    [underPath stroke]; // paint it light gray
    
    // points for dots set here
    point1 = x_start;
    point2 = x_start + width/3;
    point3 = x_start + 2*width/3;
    point4 = x_start + width;
    UIBezierPath* dot1 = [UIBezierPath bezierPathWithArcCenter:CGPointMake(x_start, y) radius:dotRadius startAngle:0 endAngle:2*M_PI clockwise:false];
    UIBezierPath* dot2 = [UIBezierPath bezierPathWithArcCenter:CGPointMake(x_start + width/3, y) radius:dotRadius startAngle:0 endAngle:2*M_PI clockwise:false];
    UIBezierPath* dot3 = [UIBezierPath bezierPathWithArcCenter:CGPointMake(x_start + 2*width/3, y) radius:dotRadius startAngle:0 endAngle:2*M_PI clockwise:false];
    UIBezierPath* dot4 = [UIBezierPath bezierPathWithArcCenter:CGPointMake(x_start + width, y) radius:dotRadius startAngle:0 endAngle:2*M_PI clockwise:false];
    dot1.lineWidth = dotRadius*2;
    dot2.lineWidth = dotRadius*2;
    dot3.lineWidth = dotRadius*2;
    dot4.lineWidth = dotRadius*2;
    
    [[UIColor orangeColor] setStroke];

    [dot1 stroke]; // might prefer fill
    [dot2 stroke];
    [dot3 stroke];
    [dot4 stroke];
    
    //[self updateCircle]; // set circle position after drawing. layoutSubviews might take care of this
}

@end
