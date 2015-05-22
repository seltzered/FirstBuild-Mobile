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
@property (nonatomic, strong) CAShapeLayer *progressLayer;
@property (nonatomic, strong) CAShapeLayer *progressLayerEnd;

@property (nonatomic, assign) CGRect frame;

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

- (void)layoutSublayers {
    
    self.path = [self drawPathWithArcCenter];
    self.progressLayer.path = [self drawPathWithArcCenter];
    self.progressLayerEnd.path = [self drawPathWithArcCenter];
    
    [super layoutSublayers];
}

- (void)setupLayer {
    
    self.path = [self drawPathWithArcCenter];
    self.fillColor = [UIColor clearColor].CGColor;
    self.strokeColor = [UIColor colorWithRed:0.86f green:0.86f blue:0.86f alpha:0.4f].CGColor;
    self.lineWidth = 20;
    
    self.progressLayer = [CAShapeLayer layer];
    self.progressLayer.path = [self drawPathWithArcCenter];
    self.progressLayer.fillColor = [UIColor clearColor].CGColor;
    self.progressLayer.strokeColor = [UIColor whiteColor].CGColor;
    self.progressLayer.lineWidth = 12;
    self.progressLayer.lineCap = kCALineJoinMiter;
    self.progressLayer.lineJoin = kCALineJoinRound;
    
    self.progressLayerEnd = [CAShapeLayer layer];
    self.progressLayerEnd.path = [self drawPathWithArcCenter];
    self.progressLayerEnd.lineWidth = self.lineWidth;
    self.progressLayerEnd.strokeColor = [UIColor whiteColor].CGColor   ;
    self.progressLayerEnd.fillColor = [UIColor clearColor].CGColor;
    self.progressLayerEnd.lineCap = kCALineJoinMiter;
    self.progressLayerEnd.lineJoin = kCALineJoinRound;
    
    [self addSublayer:self.progressLayer];
    [self addSublayer:_progressLayerEnd];
    
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


- (void)setElapsedTime:(NSTimeInterval)elapsedTime {
    _initialProgress = [self calculatePercent:_elapsedTime toTime:_timeLimit];
    _elapsedTime = elapsedTime;
    
    self.progressLayer.strokeEnd = self.percent;
    self.progressLayer.strokeColor = [UIColor whiteColor].CGColor;
    self.progressLayerEnd.strokeColor = [UIColor whiteColor].CGColor;
    self.progressLayerEnd.strokeStart = self.percent;
    self.progressLayerEnd.strokeEnd = self.percent + .005;
    //[self startAnimation];
}

- (double)percent {
    
    _percent = [self calculatePercent:_elapsedTime toTime:_timeLimit];
    return _percent;
}

- (void)setProgressColor:(UIColor *)progressColor {
    self.progressLayer.strokeColor = progressColor.CGColor;
}

- (double)calculatePercent:(NSTimeInterval)fromTime toTime:(NSTimeInterval)toTime {
    
    if ((toTime > 0) && (fromTime > 0)) {
        
        CGFloat progress = 0;
        
        progress = fromTime / toTime;
        
        if ((progress * 100) > 100) {
            progress = 1.0f;
        }
        
        NSLog(@"Percent = %f", progress);
        
        return progress;
    }
    else
        return 0.0f;
}

- (void)startAnimation {
    
    CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    pathAnimation.duration = 1.0;
    pathAnimation.fromValue = @(self.initialProgress);
    pathAnimation.toValue = @(self.percent);
    pathAnimation.removedOnCompletion = YES;
    
    [self.progressLayer addAnimation:pathAnimation forKey:nil];
    
    CABasicAnimation *endPathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeStart"];
    endPathAnimation.duration = 1;
    endPathAnimation.fromValue = @(self.initialProgress);
    endPathAnimation.toValue = @(self.percent);
    endPathAnimation.removedOnCompletion = YES;
    
    [self.progressLayerEnd addAnimation:endPathAnimation forKey:nil];
    
}

@end

// Copyright belongs to original author
// http://code4app.net (en) http://code4app.com (cn)
// From the most professional code share website: Code4App.net

