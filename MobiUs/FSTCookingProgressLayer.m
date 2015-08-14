//
//  FSTCookingProgressLayer.m
//  FirstBuild
//
//  Created by Myles Caley on 5/22/15.
//  Copyright (c) 2015 FirstBuild. All rights reserved.
//

//
//  CircleShapeLayer.m
//  CircularProgressControl
//
//  Created by Carlos Eduardo Arantes Ferreira on 22/11/14.
//  Copyright (c) 2014 Mobistart. All rights reserved.
//

#import "FSTCookingProgressLayer.h"
@interface FSTCookingProgressLayer ()

@property (assign, nonatomic) double initialProgress; // point to start the animation

@end

@implementation FSTCookingProgressLayer

@synthesize percent = _percent;


#pragma mark - Setting Up Layer



- (instancetype)init {
    if ((self = [super init]))
    {
        //[self setupLayer];
    }
    
    return self;
}

- (void)layoutSublayers { // need to specify the paths here. Why happen twice?
    CGFloat progress_width = self.frame.size.height/16; // all other widths and lengths based on this
    CGFloat sitting_width = 2*progress_width/5;
    // only has actual size here
    
    self.path = [self drawPathWithArcCenter];
    self.progressLayer.path = [self drawPathWithArcCenter];
    self.sittingLayer.path = [self drawPathWithArcCenter];
    self.bottomLayer.path = self.path;
    
    self.progressLayer.lineWidth = progress_width;
    self.bottomLayer.lineWidth = progress_width/7;
    self.sittingLayer.lineWidth = sitting_width;
    //self.progressLayerEnd.path = [self drawPathWithArcCenter];
    CGFloat line_length = self.progressLayer.lineWidth/2; // for the short lines
   for (id key in self.markLayers) {
       UIBezierPath* ninetyMark = [UIBezierPath bezierPath]; // initialize new path
       CGFloat x_end = self.frame.size.width/2 + (self.frame.size.width/3)*cos([key doubleValue]); // midpoint
        CGFloat y_end = self.frame.size.width/2 + (self.frame.size.width/3)*sin([key doubleValue]); // move up by subtracting
        CGFloat x_start;
        CGFloat y_start;
        if (fmod([key doubleValue], M_PI/2) < M_PI/60 || fmod([key doubleValue], M_PI/2) > 29*M_PI/60) { // tweak this around
            x_start = x_end - cos([key doubleValue])*line_length*1.5; // inset by width of line
            y_start = y_end - sin([key doubleValue])*line_length*1.5;
        } else {
            x_start = x_end - cos([key doubleValue])*line_length;
            y_start = y_end - sin([key doubleValue])*line_length; // add to move down
        }
       
        [ninetyMark moveToPoint:CGPointMake(x_start, y_start)];
        [ninetyMark addLineToPoint:CGPointMake(x_end, y_end)];
        ((CAShapeLayer*)[self.markLayers objectForKey:key]).path = ninetyMark.CGPath;
        //CGPathAddPath(mutableTicks, nil, ninetyMark.CGPath);
    } // need a mutable copy
    
    UIBezierPath* startLinePath = [UIBezierPath bezierPath];
    CGFloat startLength = 25;
    
    [startLinePath moveToPoint:CGPointMake(self.frame.size.width/2, self.frame.size.width/2 - self.frame.size.width/3 + startLength/2)]; // size relative to width
    [startLinePath addLineToPoint:CGPointMake(self.frame.size.width/2, self.frame.size.width/2 - self.frame.size.width/3 - startLength/2)];
    self.startLineLayer.path = startLinePath.CGPath;
    self.startLineLayer.lineWidth = progress_width/7;
    NSArray* dashes = [NSArray arrayWithObjects:@(18),@(5), nil]; // for sitting dashed line
    self.sittingLayer.lineDashPattern = dashes; // 
   // self.temperatureTicks.path = mutableTicks; // change the current path to that mutable copy
    
    [super layoutSublayers];
}

- (void)setupLayer { // drawPath probably does nothing here
    
    
    self.markLayers = [[NSMutableDictionary alloc] init];
    
    self.path = [self drawPathWithArcCenter];
    self.fillColor = [UIColor clearColor].CGColor;
    UIColor* strokeColor = [UIColor lightGrayColor];//UIColorFromRGB(0x443539);//0xEA461A);//0xD43326); // grayish
    self.strokeColor = [strokeColor colorWithAlphaComponent:1.0].CGColor; // played with alpha (from 0.5)
    //self.lineWidth = progress_width/5; // gray background
    
    self.bottomLayer = [CAShapeLayer layer];
    self.bottomLayer.path = self.path;
    self.bottomLayer.fillColor = self.fillColor;
    self.bottomLayer.strokeColor = self.strokeColor;
    self.bottomLayer.lineWidth = self.lineWidth;
    //need this below
    
    self.progressLayer = [CAShapeLayer layer];
    //self.progressLayer.path = [self drawPathWithArcCenter];
    self.progressLayer.fillColor = [UIColor clearColor].CGColor;
    self.progressLayer.strokeColor = [UIColorFromRGB(0xF0663A) colorWithAlphaComponent:1.0].CGColor; // firstbuild orange from continue button
   // self.progressLayer.lineWidth = progress_width;
    self.progressLayer.lineCap = kCALineJoinMiter;
    self.progressLayer.lineJoin = kCALineJoinRound;
    //self.progressLayer.shadowColor = [UIColor whiteColor].CGColor;
    
    self.sittingLayer = [CAShapeLayer layer];
    self.sittingLayer.fillColor = [UIColor clearColor].CGColor;
    self.sittingLayer.strokeColor = [[UIColor whiteColor] colorWithAlphaComponent:0.6].CGColor; // lightening white over the orange bar
    //self.sittingLayer.lineWidth = sitting_width; // smaller than background progress layer
    self.sittingLayer.lineCap = kCALineJoinMiter;
    self.sittingLayer.lineJoin = kCALineJoinRound;
    
    [self addSublayer:self.bottomLayer];
    CGFloat mark_angle = 2*M_PI/60; // denominator as number of marks
    for (CGFloat i = 0; i < 2*M_PI; i += mark_angle) { // might do this for the whole shebang
        CAShapeLayer* newMark = [CAShapeLayer layer];
        newMark.strokeColor = [[UIColor grayColor] colorWithAlphaComponent:0.6].CGColor;
        newMark.lineWidth = self.progressLayer.lineWidth/10; // overwritten in drawPaths
        [self insertSublayer:newMark below:self.bottomLayer];//below:self]; // not working
        [self.markLayers setObject:newMark forKey:@(i)];
    }
    self.startLineLayer = [CAShapeLayer layer];
    self.startLineLayer.strokeColor = [UIColor lightGrayColor].CGColor; // starting line at top of circle
    [self addSublayer:self.progressLayer];
    [self insertSublayer:self.sittingLayer above:self.progressLayer];
    [self insertSublayer:self.startLineLayer above:self.sittingLayer];
    //[self addSublayer:_progressLayerEnd];
    //[self insertSublayer:self.textBackground above:self];

}

- (CGPathRef)drawPathWithArcCenter {
    
    CGFloat position_y = self.frame.size.height/2;
    CGFloat position_x = self.frame.size.width/2; // Assuming that width == height
    return [UIBezierPath bezierPathWithArcCenter:CGPointMake(position_x, position_y)
                                          radius:position_x/1.5
                                      startAngle:(-M_PI/2)
                                        endAngle:(3*M_PI/2)
                                       clockwise:YES].CGPath;
}



/*- (void)setElapsedTime:(NSTimeInterval)elapsedTime {
    _initialProgress = [self calculatePercent:_elapsedTime toTime:_timeLimit];
    _elapsedTime = elapsedTime;
    
    [self drawPathsForPercent]; // draw with the new elapsed time
    //[self startAnimation];
}

-(void)setTargetTemp:(CGFloat)targetTemp {
    _targetTemp = targetTemp;
}

-(void)setStartingTemp:(CGFloat)startingTemp {
    _startingTemp = startingTemp;
}

-(void)setCurrentTemp:(CGFloat)currentTemp {
    _currentTemp = currentTemp;
    [self drawPathsForPercent]; // takes current temp to calculate percent
}*/

#pragma mark - Depicting Progress

-(void)setPercent:(CGFloat)percent { // a setter that updates the layer's progress
    _percent = percent; // need to set in this scope
    [self drawPathsForPercent];
}

-(void)drawPathsForPercent { // should override this for each subclass

}

-(void)drawCompleteTicks {
    for (id key in self.markLayers) {
        if ([key doubleValue] <= 2*M_PI) { // all orange
            ((CAShapeLayer*)[self.markLayers objectForKey:key]).strokeColor = UIColorFromRGB(0xF0663A).CGColor; // place holder, color tick marks firstbuild orange as a progress indicator
            ((CAShapeLayer*)[self.markLayers objectForKey:key]).lineWidth = 2*self.progressLayer.lineWidth/15; // same as full_line_width value
        }
    } // all orange for completeness // better put this in a function,
}
/*
- (void)setProgressColor:(UIColor *)progressColor { // perhaps get rid of this
    //self.progressLayer.strokeColor = progressColor.CGColor;
}
*/
- (void)startAnimation {
    
    CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    pathAnimation.duration = 1.0;
    pathAnimation.fromValue = @(self.initialProgress);
    pathAnimation.toValue = @(self.percent);
    pathAnimation.removedOnCompletion = YES;
    
    [self.progressLayer addAnimation:pathAnimation forKey:nil];
    
    /*CABasicAnimation *endPathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeStart"];
    endPathAnimation.duration = 1;
    endPathAnimation.fromValue = @(self.initialProgress);
    endPathAnimation.toValue = @(self.percent);
    endPathAnimation.removedOnCompletion = YES;
    
    [self.progressLayerEnd addAnimation:endPathAnimation forKey:nil];*/
    
}

@end

// Copyright belongs to original author
// http://code4app.net (en) http://code4app.com (cn)
// From the most professional code share website: Code4App.net

