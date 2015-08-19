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

//@property (nonatomic, strong) FSTStageCircleView* circleMarker;

@property (nonatomic, strong) CAShapeLayer* ring; // animated shape that replaces the static circleMarker

//@property (nonatomic, strong) NSMutableArray* dotPaths;

@property (nonatomic, strong) NSMutableArray* grayDots;

@property (nonatomic) CGFloat lineWidth; // this was public before, could just be a global variable

@end

@implementation FSTStageBarView



-(id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupDots];
        //self.dotPaths = [[NSMutableArray alloc] init];
    }
    return self;
}

-(void) awakeFromNib {
    //self.dotPaths = [[NSMutableArray alloc] init];
    [self setupDots];
}

-(void)setupDots { // could happen after init or awake from nib. Initialize subviews
    //self.circleMarker = [[FSTStageCircleView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.height, self.bounds.size.height)]; // always proportional to height
    //[self addSubview:self.circleMarker]; // create the circle marker
    //self.dotPaths = [[NSMutableArray alloc] init];
    self.grayDots = [[NSMutableArray alloc] init]; // an array to hold all the dot subviews
    /*for (int idots = 0; idots < 4; idots++) {
        [self.dotPaths addObject:[UIBezierPath bezierPath]];
    } // instantiate four bezier paths*/
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.lineWidth = 4*self.bounds.size.width/5; //update scaled linewidth so subviews can match (same proportion set in drawRect, but with scaled up
    [self updateCircle];
}

- (void) updateCircle {
    /*CGFloat new_x = 0; // change x position of stageCircle
    CGFloat mid_x = self.bounds.size.width/2;
    CGFloat start_x = mid_x - self.lineWidth/2; //start of bar (line is slightly inset)*/ // is there a better place to set the dot paths?
    // points for dots set here
    // I need to call draw rect again
    if (self.grayDots.count >= 4) { // sometimes can enter updateCircle before drawing the rect, so grayDots need to be set first.
        switch (self.circleState) {
            case FSTParagonCookingStatePrecisionCookingPreheating:
                self.ring.path = ((CAShapeLayer*)self.grayDots[0]).path;//new_x = start_x; // beginning of bar
                    ((CAShapeLayer*)self.grayDots[0]).strokeColor = [UIColor orangeColor].CGColor;
                    ((CAShapeLayer*)self.grayDots[1]).strokeColor = [UIColor orangeColor].CGColor;
                    ((CAShapeLayer*)self.grayDots[2]).strokeColor = [UIColor orangeColor].CGColor;
                    ((CAShapeLayer*)self.grayDots[3]).strokeColor = [UIColor orangeColor].CGColor;
                break;
            case FSTParagonCookingStatePrecisionCookingPreheatingReached:
                self.ring.path = ((CAShapeLayer*)self.grayDots[1]).path;//new_x = start_x + self.lineWidth/3;
                ((CAShapeLayer*)self.grayDots[0]).strokeColor = [UIColor grayColor].CGColor;
                ((CAShapeLayer*)self.grayDots[1]).strokeColor = [UIColor orangeColor].CGColor;
                ((CAShapeLayer*)self.grayDots[2]).strokeColor = [UIColor orangeColor].CGColor;
                ((CAShapeLayer*)self.grayDots[3]).strokeColor = [UIColor orangeColor].CGColor;
                break;
            case FSTParagonCookingStatePrecisionCookingReachingMinTime:
                self.ring.path = ((CAShapeLayer*)self.grayDots[2]).path;//new_x = start_x + 2*self.lineWidth/3;
                ((CAShapeLayer*)self.grayDots[0]).strokeColor = [UIColor grayColor].CGColor;
                ((CAShapeLayer*)self.grayDots[1]).strokeColor = [UIColor grayColor].CGColor;
                ((CAShapeLayer*)self.grayDots[2]).strokeColor = [UIColor orangeColor].CGColor;
                ((CAShapeLayer*)self.grayDots[3]).strokeColor = [UIColor orangeColor].CGColor;
                break;
            case FSTParagonCookingStatePrecisionCookingReachingMaxTime:
            case FSTParagonCookingStatePrecisionCookingPastMaxTime:
                self.ring.path = ((CAShapeLayer*)self.grayDots[3]).path;//new_x = start_x + self.lineWidth;
                ((CAShapeLayer*)self.grayDots[0]).strokeColor = [UIColor grayColor].CGColor;
                ((CAShapeLayer*)self.grayDots[1]).strokeColor = [UIColor grayColor].CGColor;
                ((CAShapeLayer*)self.grayDots[2]).strokeColor = [UIColor grayColor].CGColor;
                ((CAShapeLayer*)self.grayDots[3]).strokeColor = [UIColor orangeColor].CGColor;
                break;
            default:
                NSLog(@"NO STATE FOR STAGE BAR\n");
                self.ring.path = ((CAShapeLayer*)self.grayDots[0]).path;//new_x = start_x + self.lineWidth/2; // we'll just hide this anyway
                break;
        } // need to integrate with new states, or commit animations at every transition
        //[self setNeedsDisplay]; // get it to redraw with new state this failed miserably because of the invalid context
        
    }
    /*CGFloat new_w = self.bounds.size.height; // the circle is always 1 to 1 and fills the height
    [self.circleMarker setFrame:CGRectMake(new_x - new_w/2, 0, new_w, new_w)]; // set new circle frame with width and x value.*/
}

- (void)setCircleState:(ParagonCookMode)circleState { // state changed externally
    _circleState = circleState;
    [self updateCircle];
}

- (void)drawRect:(CGRect)rect {
    // replaced self.frame with rect
    CGFloat point1, point2, point3, point4;
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
    
    point1 = x_start;
    point2 = x_start + width/3;
    point3 = x_start + 2*width/3;
    point4 = x_start + width;
    // drawing context has a serious problem
    CAShapeLayer* grayLayer1 = [CAShapeLayer layer];
    grayLayer1.strokeColor = [UIColor orangeColor].CGColor;
    
    CAShapeLayer* grayLayer2 = [CAShapeLayer layer];
    grayLayer2.strokeColor = [UIColor orangeColor].CGColor;
    
    CAShapeLayer* grayLayer3 = [CAShapeLayer layer];
    grayLayer3.strokeColor = [UIColor orangeColor].CGColor;
    
    CAShapeLayer* grayLayer4 = [CAShapeLayer layer];
    grayLayer4.strokeColor = [UIColor orangeColor].CGColor;
    
    grayLayer1.path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(point1, y) radius:dotRadius startAngle:0 endAngle:2*M_PI clockwise:false].CGPath;
    grayLayer2.path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(point2, y) radius:dotRadius startAngle:0 endAngle:2*M_PI clockwise:false].CGPath;
    grayLayer3.path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(point3, y) radius:dotRadius startAngle:0 endAngle:2*M_PI clockwise:false].CGPath;
    grayLayer4.path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(point4, y) radius:dotRadius startAngle:0 endAngle:2*M_PI clockwise:false].CGPath;
    // I would like some way to re draw this rather than instantiate a new one every time*/ // not good to redraw!
    
    /*[self.dotPaths addObject:dot1];
    [self.dotPaths addObject:dot2];
    [self.dotPaths addObject:dot3];
    [self.dotPaths addObject:dot4];*/
    
    grayLayer1.lineWidth = dotRadius*2;
    grayLayer2.lineWidth = dotRadius*2;
    grayLayer3.lineWidth = dotRadius*2;
    grayLayer4.lineWidth = dotRadius*2;
    //((UIBezierPath*)self.dotPaths[1]).lineWidth = dotRadius*2;

    /*[[UIColor orangeColor] setStroke];

    [(UIBezierPath*)self.dotPaths[0] stroke]; // might prefer fill
    [(UIBezierPath*)self.dotPaths[1] stroke];
    [(UIBezierPath*)self.dotPaths[2] stroke];
    [(UIBezierPath*)self.dotPaths[3] stroke];*/
    
    // basically make gray copies of all those dots (there is probably no need for the dotPaths array perhaps these dots can change colors dynamically?
    
    [self.layer insertSublayer:grayLayer1 above:self.layer];
    [self.layer insertSublayer:grayLayer2 above:self.layer];
    [self.layer insertSublayer:grayLayer3 above:self.layer];
    [self.layer insertSublayer:grayLayer4 above:self.layer];
    
    [self.grayDots addObject:grayLayer1];
    [self.grayDots addObject:grayLayer2];
    [self.grayDots addObject:grayLayer3];
    [self.grayDots addObject:grayLayer4]; // use the array to reference dots when updating the circle state
    
    
    //TODO:experimental
    self.ring = [CAShapeLayer layer];
    self.ring.path = grayLayer1.path;
    self.ring.fillColor = [UIColor clearColor].CGColor;
    self.ring.strokeColor = [[UIColor orangeColor] CGColor];
    self.ring.lineWidth = grayLayer1.lineWidth;
    [self.layer addSublayer:self.ring];
    CABasicAnimation *branchGrowAnimation = [CABasicAnimation animationWithKeyPath:@"lineWidth"];
    branchGrowAnimation.duration = 3.0;
    branchGrowAnimation.autoreverses = YES;
    branchGrowAnimation.repeatCount = HUGE_VAL;
    branchGrowAnimation.fromValue = [NSNumber numberWithFloat:dotRadius*4];
    branchGrowAnimation.toValue = [NSNumber numberWithFloat:dotRadius*8];
    [self.ring addAnimation:branchGrowAnimation forKey:@"lineWidth"];
    /////////////
    
    //[self updateCircle]; // set circle position after drawing. layoutSubviews might take care of this
}

- (void) drawRing
{
    
}

@end
