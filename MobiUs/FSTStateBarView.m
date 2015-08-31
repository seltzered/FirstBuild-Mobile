//
//  FSTStateBarView.m
//  FirstBuild
//
//  Created by John Nolan on 7/14/15.
//  Copyright (c) 2015 FirstBuild. All rights reserved.
//

#import "FSTStateBarView.h"
#import "FSTStateCircleView.h"

@interface FSTStateBarView()

//@property (nonatomic, strong) FSTStageCircleView* circleMarker;

@property (nonatomic, strong) CAShapeLayer* ring; // animated shape that replaces the static circleMarker

//@property (nonatomic, strong) NSMutableArray* dotPaths;

@property (nonatomic, strong) NSMutableArray* grayDots;

@property (nonatomic, strong) NSMutableArray* dotTransforms;

@property (nonatomic) CGFloat lineWidth; // this was public before, could just be a global variable


@end

@implementation FSTStateBarView

@synthesize numberOfStates = _numberOfStates;

-(void)setNumberOfStates:(NSNumber *)numberOfStates
{
    [self setupDots];
    _numberOfStates = numberOfStates;
}

- (NSNumber*) numberOfStates
{
    return _numberOfStates;
}

-(id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupDots];
    }
    return self;
}

-(void) awakeFromNib {
    [super awakeFromNib];
    [self setupDots];
}

-(void)setupDots { // could happen after init or awake from nib. Initialize subviews
    self.grayDots = [[NSMutableArray alloc] init]; // an array to hold all the dot subviews
    self.dotTransforms = [[NSMutableArray alloc] init];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    //update scaled linewidth so subviews can match (same proportion set in drawRect, but with scaled up
    // this is too early to arrange the transforms. all the dots need to be drawn
    self.lineWidth = 4*self.bounds.size.width/5;
    [self updateCircle];
}

- (void) arrangeTransforms {
    
    if (self.dotTransforms.count > 0) {
        [self.dotTransforms removeAllObjects];
    }
    CGFloat ringScale = 0.3; // how much the line widht shrinks down (for some reason scaling down the path makes our stroke thinner
    //baseline scale transform that every dot undergoes
    CGAffineTransform sizeTransform = CGAffineTransformMakeScale(ringScale, ringScale);
    // use these bounds to calculate the size for offsets and scales (never mind, it scales relative to the layer bounds
    CGAffineTransform ringTransform;
    CGRect circleBounds;
    CGSize ringSize;
    CGFloat offsetWidth, offsetHeight;
    CGSize ringOffset;
    
    for (int itr = 0; itr < self.grayDots.count; itr++) {
        circleBounds = CGPathGetBoundingBox(((CAShapeLayer*)self.grayDots[itr]).path);
         // calculate what size the ring will be after this transform for the offset
        ringSize = CGSizeApplyAffineTransform(CGSizeMake(circleBounds.origin.x + circleBounds.size.width/2, circleBounds.origin.y + circleBounds.size.height/2), sizeTransform);
        // get the rectangle of its position in which it scales down
        // establish the offset to place the ring in the center
        offsetWidth = circleBounds.origin.x + circleBounds.size.width/2 - ringSize.width;
        offsetHeight = circleBounds.origin.y + circleBounds.size.height/2 - ringSize.height;
        ringOffset = CGSizeMake(offsetWidth/(ringScale), offsetHeight/(ringScale));
        // mix that transform with the offset
        ringTransform = CGAffineTransformTranslate(sizeTransform, ringOffset.width, ringOffset.height);
        [self.dotTransforms addObject:[NSValue valueWithCGAffineTransform:ringTransform]];//ringOffset.width, ringOffset.height);
        // something goes really wrong
    }
    
}

- (void) colorDotsForActiveStateNumber: (int)activeStateNumber
{
    CGAffineTransform transform;
    transform = [(NSValue*)self.dotTransforms[activeStateNumber] CGAffineTransformValue];
    self.ring.path = CGPathCreateCopyByTransformingPath(((CAShapeLayer*)self.grayDots[activeStateNumber]).path, &transform);

    for (int i=0; i < self.grayDots.count;i++)
    {
        if (i < activeStateNumber)
        {
            ((CAShapeLayer*)self.grayDots[i]).strokeColor = [UIColor grayColor].CGColor;
        }
        else
        {
            ((CAShapeLayer*)self.grayDots[i]).strokeColor = [UIColor orangeColor].CGColor;
        }
    }
}

- (void) updateCircle { // problem on ipad, all layers need to update their position
    
     // ring is about a third the width of those gray dots
    if (self.grayDots.count >= 1) { // sometimes can enter updateCircle before drawing the rect, so grayDots need to be set first.
        // transforms should have already been set up
        switch (self.circleState) {
            case FSTParagonCookingStatePrecisionCookingReachingTemperature:
                [self colorDotsForActiveStateNumber:0];
                break;
            case FSTParagonCookingStatePrecisionCookingTemperatureReached:
                [self colorDotsForActiveStateNumber:1];
                break;
            case FSTParagonCookingStatePrecisionCookingReachingMinTime:
                [self colorDotsForActiveStateNumber:2];
                break;
            case FSTParagonCookingStatePrecisionCookingReachingMaxTime:
            case FSTParagonCookingStatePrecisionCookingPastMaxTime:
                [self colorDotsForActiveStateNumber:3];
                break;
            default:
                NSLog(@"NO STATE FOR STAGE BAR\n");
//                transform = [(NSValue*)self.dotTransforms[0] CGAffineTransformValue];
//                self.ring.path = CGPathCreateCopyByTransformingPath(((CAShapeLayer*)self.grayDots[0]).path, &transform);
                //self.ring.path = ((CAShapeLayer*)self.grayDots[0]).path;//new_x = start_x + self.lineWidth/2; // we'll just hide this anyway
                break;
        }
    }
}

- (void)setCircleState:(ParagonCookMode)circleState { // state changed externally
    _circleState = circleState;
    [self updateCircle];
}

-(void)addState:(CGRect)rect
{
    CGFloat y = rect.size.height/2;
    CGFloat dotRadius = rect.size.height/8;
    
    //distance between the dots
    CGFloat barXSpacing = .2 * rect.size.width;
    
    //the width of the entire state bar
    CGFloat barWidth = .2 * ([self.numberOfStates intValue]-1);
    
    //the beginning of the state bar
    CGFloat barXOrigin = (rect.size.width - barWidth) / 2;
    
    //the current point's position
    CGFloat point = barXOrigin + (barXSpacing * self.grayDots.count);
    
    CAShapeLayer* grayLayer = [CAShapeLayer layer];
    grayLayer.strokeColor = [UIColor orangeColor].CGColor;
    
    grayLayer.path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(point, y) radius:dotRadius startAngle:0 endAngle:2*M_PI clockwise:false].CGPath;
    grayLayer.lineWidth = dotRadius*2;
    
    [self.layer insertSublayer:grayLayer above:self.layer];
    [self.grayDots addObject:grayLayer];
    
}

- (void)drawRect:(CGRect)rect {
    // replaced self.frame with rect
//    CGFloat point1, point2, point3, point4;
    CGFloat x_start = rect.size.width/10; // the starting x coordinate (starts at beginning
    CGFloat x_end = rect.size.width - x_start;
    CGFloat width = x_end - x_start; // width of the whole line
    CGFloat y = rect.size.height/2; // mid point as every y coordinate
    UIBezierPath* underPath = [UIBezierPath bezierPath];
    CGFloat dotRadius = rect.size.height/8;
    
    
    for (int i=0; i<= [self.numberOfStates intValue]; i++)
    {
        [self addState:rect];
    }
    
    self.lineWidth = width; // let the viewContoller access that for position calculations
    [underPath moveToPoint:CGPointMake(x_start, y)];
    [underPath addLineToPoint:CGPointMake(x_end, y)];
    [[UIColor lightGrayColor] setStroke];
    [underPath stroke]; // paint it light gray
    
//    point1 = x_start;
//    point2 = x_start + width/3;
//    point3 = x_start + 2*width/3;
//    point4 = x_start + width;
    // drawing context has a serious problem
//    CAShapeLayer* grayLayer1 = [CAShapeLayer layer];
//    grayLayer1.strokeColor = [UIColor orangeColor].CGColor;
//    
//    CAShapeLayer* grayLayer2 = [CAShapeLayer layer];
//    grayLayer2.strokeColor = [UIColor orangeColor].CGColor;
//    
//    CAShapeLayer* grayLayer3 = [CAShapeLayer layer];
//    grayLayer3.strokeColor = [UIColor orangeColor].CGColor;
//    
//    CAShapeLayer* grayLayer4 = [CAShapeLayer layer];
//    grayLayer4.strokeColor = [UIColor orangeColor].CGColor;
    
//    grayLayer1.path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(point1, y) radius:dotRadius startAngle:0 endAngle:2*M_PI clockwise:false].CGPath;
//    grayLayer2.path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(point2, y) radius:dotRadius startAngle:0 endAngle:2*M_PI clockwise:false].CGPath;
//    grayLayer3.path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(point3, y) radius:dotRadius startAngle:0 endAngle:2*M_PI clockwise:false].CGPath;
//    grayLayer4.path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(point4, y) radius:dotRadius startAngle:0 endAngle:2*M_PI clockwise:false].CGPath;
    // I would like some way to re draw this rather than instantiate a new one every time*/ // not good to redraw!
    
    /*[self.dotPaths addObject:dot1];
    [self.dotPaths addObject:dot2];
    [self.dotPaths addObject:dot3];
    [self.dotPaths addObject:dot4];*/
    
//    grayLayer1.lineWidth = dotRadius*2;
//    grayLayer2.lineWidth = dotRadius*2;
//    grayLayer3.lineWidth = dotRadius*2;
//    grayLayer4.lineWidth = dotRadius*2;
    //((UIBezierPath*)self.dotPaths[1]).lineWidth = dotRadius*2;

    /*[[UIColor orangeColor] setStroke];

    [(UIBezierPath*)self.dotPaths[0] stroke]; // might prefer fill
    [(UIBezierPath*)self.dotPaths[1] stroke];
    [(UIBezierPath*)self.dotPaths[2] stroke];
    [(UIBezierPath*)self.dotPaths[3] stroke];*/
    
    // basically make gray copies of all those dots (there is probably no need for the dotPaths array perhaps these dots can change colors dynamically?
    
//    [self.layer insertSublayer:grayLayer1 above:self.layer];
//    [self.layer insertSublayer:grayLayer2 above:self.layer];
//    [self.layer insertSublayer:grayLayer3 above:self.layer];
//    [self.layer insertSublayer:grayLayer4 above:self.layer];
//    
//    [self.grayDots addObject:grayLayer1];
//    [self.grayDots addObject:grayLayer2];
//    [self.grayDots addObject:grayLayer3];
//    [self.grayDots addObject:grayLayer4]; // use the array to reference dots when updating the circle state
    
    
    //TODO:experimental
    self.ring = [CAShapeLayer layer];
    //self.ring.path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(point1, y) radius:dotRadius*4 startAngle:0 endAngle:2*M_PI clockwise:false].CGPath;//grayLayer1.path;
    self.ring.fillColor = [UIColor clearColor].CGColor;
    self.ring.strokeColor = [[UIColor orangeColor] CGColor];
    //self.ring.lineWidth = grayLayer1.lineWidth/3;
    [self.layer addSublayer:self.ring];
    CABasicAnimation *branchGrowAnimation = [CABasicAnimation animationWithKeyPath:@"lineWidth"];
    branchGrowAnimation.duration = 3.0;
    branchGrowAnimation.autoreverses = YES;
    branchGrowAnimation.repeatCount = HUGE_VAL;
    branchGrowAnimation.fromValue = [NSNumber numberWithFloat:dotRadius*8];//*4];
    branchGrowAnimation.toValue = [NSNumber numberWithFloat:dotRadius*4];
    [self.ring addAnimation:branchGrowAnimation forKey:@"lineWidth"];
    /////////////
    [self arrangeTransforms]; // create the affine transformations for the ring at every gray dot
    //[self updateCircle]; // set circle position after drawing. layoutSubviews might take care of this
}

- (void) drawRing
{
    
}

@end
