//
//  FSTCircleProgressLayer.m
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

#import "FSTCircleProgressLayer.h"
@interface FSTCircleProgressLayer ()

@property (assign, nonatomic) double initialProgress;
@property (nonatomic, strong) CAShapeLayer *bottomLayer;
@property (nonatomic, strong) CAShapeLayer *progressLayer;
@property (nonatomic, strong) CAShapeLayer *sittingLayer;
//@property (nonatomic, strong) CAShapeLayer *progressLayerEnd;
@property (nonatomic, strong) CAShapeLayer *textBackground;
@property (nonatomic, strong) CAShapeLayer *temperatureTicks;
@property (nonatomic, strong) CAShapeLayer *temperatureBack; // gray lines behind the ticks
@property (nonatomic, strong) NSMutableDictionary* markLayers; // holds all the tick marks // layers with angles as keys

@end

@implementation FSTCircleProgressLayer

@synthesize percent = _percent;



- (instancetype)init {
    if ((self = [super init]))
    {
        [self setupLayer];
    }
    
    return self;
}

- (void)layoutSublayers { // need to specify the paths here. Why happen twice?
    
    self.path = [self drawPathWithArcCenter];
    self.progressLayer.path = [self drawPathWithArcCenter];
    self.sittingLayer.path = [self drawPathWithArcCenter];
    self.bottomLayer.path = self.path;
    //self.progressLayerEnd.path = [self drawPathWithArcCenter];
    CGFloat line_length = 15.0; // for the short lines
       for (id key in self.markLayers) {
           UIBezierPath* ninetyMark = [UIBezierPath bezierPath]; // initialize new path
           CGFloat x_end = self.frame.size.width/2 + (self.frame.size.width/3)*cos([key doubleValue]); // midpoint
            CGFloat y_end = self.frame.size.width/2 + (self.frame.size.width/3)*sin([key doubleValue]); // move up by subtracting
            CGFloat x_start;
            CGFloat y_start;
            if (fmod([key doubleValue], M_PI/2) < M_PI/60 || fmod([key doubleValue], M_PI/2) > 29*M_PI/60) { // tweak this around
                x_start = x_end - cos([key doubleValue])*line_length*1.5; // inset by width of line
                y_start = y_end - sin([key doubleValue])*line_length*1.5; // add to move down
            } else {
                x_start = x_end - cos([key doubleValue])*line_length;
                y_start = y_end - sin([key doubleValue])*line_length; // add to move down
            }
           
            [ninetyMark moveToPoint:CGPointMake(x_start, y_start)];
            [ninetyMark addLineToPoint:CGPointMake(x_end, y_end)];
            ((CAShapeLayer*)[self.markLayers objectForKey:key]).path = ninetyMark.CGPath;
        //CGPathAddPath(mutableTicks, nil, ninetyMark.CGPath);
    } // need a mutable copy
    NSArray* dashes = [NSArray arrayWithObjects:@(25),@(7), nil]; // for sitting dashed line
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
    /*self.shadowColor = [UIColor whiteColor].CGColor; // changed from white
    self.shadowOpacity = .8;
    //self.shadowPath = self.path; // i think this is needed to keep it out of the inner circle
    self.shadowRadius = 2.0; // down from 3
    self.shadowOffset = CGSizeMake(0, 0);*/
    self.lineWidth = 8;
    
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
    self.progressLayer.lineWidth = 30;
    self.progressLayer.lineCap = kCALineJoinMiter;
    self.progressLayer.lineJoin = kCALineJoinRound;
    //self.progressLayer.shadowColor = [UIColor whiteColor].CGColor;
    
    self.sittingLayer = [CAShapeLayer layer];
    self.sittingLayer.fillColor = [UIColor clearColor].CGColor;
    self.sittingLayer.strokeColor = [[UIColor whiteColor] colorWithAlphaComponent:0.6].CGColor; // lightening white over the orange bar
    self.sittingLayer.lineWidth = 12; // smaller than background progress layer
    self.sittingLayer.lineCap = kCALineJoinMiter;
    self.sittingLayer.lineJoin = kCALineJoinRound;
    
    [self addSublayer:self.bottomLayer];
    CGFloat mark_angle = 2*M_PI/60; // denominator as number of marks
    for (CGFloat i = 0; i < 2*M_PI; i += mark_angle) { // might do this for the whole shebang
        // adding the layers here is a major problem!!! // why was int working
        CAShapeLayer* newMark = [CAShapeLayer layer];
        newMark.strokeColor = [[UIColor grayColor] colorWithAlphaComponent:0.6].CGColor;
        newMark.lineWidth = 5.0;
        [self insertSublayer:newMark below:self.bottomLayer];//below:self]; // not working
        [self.markLayers setObject:newMark forKey:@(i)];
    }
    
    /*self.progressLayerEnd = [CAShapeLayer layer];
    self.progressLayerEnd.path = [self drawPathWithArcCenter];
    self.progressLayerEnd.lineWidth = self.lineWidth;
    self.progressLayerEnd.strokeColor = [UIColor whiteColor].CGColor;
    self.progressLayerEnd.fillColor = [UIColor clearColor].CGColor;
    self.progressLayerEnd.lineCap = kCALineJoinMiter;
    self.progressLayerEnd.lineJoin = kCALineJoinRound;
    */ // no longer in new skin
    
    /*self.textBackground = [CAShapeLayer layer];
    self.textBackground.path = [self drawTextBackground];
    UIColor *backColor = [UIColor grayColor]; // stroke fills whole circle in
    self.textBackground.strokeColor = [backColor colorWithAlphaComponent:0.7].CGColor; //background translucent
    self.textBackground.fillColor = [UIColor clearColor].CGColor;
    self.textBackground.lineCap = kCALineJoinMiter;
    self.textBackground.lineJoin = kCALineJoinMiter;
     */

    [self addSublayer:self.progressLayer];
    [self insertSublayer:self.sittingLayer above:self.progressLayer];
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


/*- (CGPathRef)drawTextBackground {
    return [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.frame.size.width/2, self.frame.size.height/2)
                                          radius:(self.frame.size.width/3 - (self.lineWidth/2))/2
                                      startAngle:(-M_PI/2)
                                        endAngle:3*M_PI/2
                                       clockwise:YES].CGPath;
}*/

- (void)setElapsedTime:(NSTimeInterval)elapsedTime {
    _initialProgress = [self calculatePercent:_elapsedTime toTime:_timeLimit];
    _elapsedTime = elapsedTime;
    
    [self drawPathsForPercent]; // draw with the new elapsed time
    //self.progressLayer.strokeEnd = _initialProgress;//self.percent; // TEMPORARY, drawPathsForPercent should handle this, depending on the state
    //self.progressLayerEnd.strokeStart = self.percent;
    //self.progressLayerEnd.strokeEnd = self.percent + .005; // change width of end line
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
}

-(void)setLayerState:(ProgressState)layerState {
    _layerState = layerState; // called when state changes
    [self drawPathsForPercent];
}

-(void)drawPathsForPercent { // also takes state into account
    switch (_layerState) {
        case kPreheating:
            self.progressLayer.strokeEnd = 0.0f; // not even started yet
            for (id key in self.markLayers) {
                if (fmod(([key doubleValue] + M_PI/2), 2*M_PI) <= self.percent*2*M_PI) { // 0 to 1 needs to go on a 3 PI/2 to 7pi/2 range, add pi/2 and clamp it to 0 through 2pi
                    // might increase line width as well
                    ((CAShapeLayer*)[self.markLayers objectForKey:key]).strokeColor = [UIColor orangeColor].CGColor; // place holder, color tick marks firstbuild orange as a progress indicator
                    ((CAShapeLayer*)[self.markLayers objectForKey:key]).lineWidth = 5.0;
                } else {
                    ((CAShapeLayer*)[self.markLayers objectForKey:key]).strokeColor = [UIColor grayColor].CGColor;
                    ((CAShapeLayer*)[self.markLayers objectForKey:key]).lineWidth = 2.0;
                }
            }
            self.sittingLayer.strokeEnd = 0.0F;
            break;
        case kReady:
            [self drawCompleteTicks];// preheating complete
            self.progressLayer.strokeEnd = 0.0F;
            self.sittingLayer.strokeEnd = 0.0F;
            break;
        case kCooking:
            [self drawCompleteTicks];
            self.progressLayer.strokeEnd = self.percent;
            self.sittingLayer.strokeEnd = 0.0F;
            break;
        case kSitting: // later
            [self drawCompleteTicks];
            self.progressLayer.strokeEnd = 1.0F; // complete
            self.sittingLayer.strokeEnd = self.percent; // based on time range
            break;
    }
}

-(void)drawCompleteTicks {
    for (id key in self.markLayers) {
        if ([key doubleValue] <= 2*M_PI) { // all orange
            ((CAShapeLayer*)[self.markLayers objectForKey:key]).strokeColor = [UIColor orangeColor].CGColor; // place holder, color tick marks firstbuild orange as a progress indicator
            ((CAShapeLayer*)[self.markLayers objectForKey:key]).lineWidth = 5.0;
        }
    } // all orange for completeness // better put this in a function,
}

- (double)percent {
    // change the way it calculates percent for different progress bars, and perhaps add layers that derive from CricleProgressLayer
    switch (_layerState) {
        case kPreheating:
            _percent = [self calculatePercentWithTemp:_currentTemp];
            break;
        case kReady: // precent not really used here, could be taken as complete, 100%, after preheating
        case kCooking:
        case kSitting:
            _percent = [self calculatePercent:_elapsedTime toTime:_timeLimit];
            // time Limit and elapsed time need to be reset when transitioning to sitting
            break;
    }
    return _percent;
}

- (void)setProgressColor:(UIColor *)progressColor { // perhaps get rid of this
    //self.progressLayer.strokeColor = progressColor.CGColor;
}

- (double)calculatePercent:(NSTimeInterval)fromTime toTime:(NSTimeInterval)toTime {
    
    if ((toTime > 0) && (fromTime > 0)) {
        
        CGFloat progress = 0;
        
        progress = fromTime / toTime;
        
        if ((progress * 100) > 100) {
            progress = 1.0f;
        }
                
        return progress;
    }
    else
        return 0.0f;
}

-(double)calculatePercentWithTemp:(CGFloat)temp {
    CGFloat progress = 0; // defaults to this
    if (temp > _startingTemp) {
        progress = (temp - _startingTemp)/(_targetTemp - _startingTemp);
        if ((progress * 100) > 100) {
            progress = 1.0f; // complete
        }
    }
    return progress;
}

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

