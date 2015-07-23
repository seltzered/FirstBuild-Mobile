//
//  FSTCookingProgressView.m
//  FirstBuild
//
//  Created by Myles Caley on 5/22/15.
//  Copyright (c) 2015 FirstBuild. All rights reserved.
//

//
//  CircleProgressView.m
//  CircularProgressControl
//
//  Created by Carlos Eduardo Arantes Ferreira on 22/11/14.
//  Copyright (c) 2014 Mobistart. All rights reserved.
//

#import "FSTCookingProgressView.h"
#import "FSTCookingProgressLayer.h"

@interface FSTCookingProgressView()

@property (nonatomic, strong) FSTCookingProgressLayer *progressLayer;
//@property (strong, nonatomic) UILabel *progressLabel;

@end

@implementation FSTCookingProgressView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViews];
    }
    return self;
}

- (void)awakeFromNib {
    [self setupViews];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.progressLayer.frame = self.bounds;
    
//    [self.progressLabel sizeToFit];
//    self.progressLabel.center = CGPointMake(self.center.x - self.frame.origin.x, self.center.y- self.frame.origin.y);
}

- (void)updateConstraints {
    [super updateConstraints];
}

//- (UILabel *)progressLabel
//{
//    if (!_progressLabel) {
//        _progressLabel = [[UILabel alloc] initWithFrame:self.bounds];
//        _progressLabel.numberOfLines = 2;
//        _progressLabel.textAlignment = NSTextAlignmentCenter;
//        _progressLabel.backgroundColor = [UIColor clearColor];
//        _progressLabel.textColor = [UIColor whiteColor];
//        
//        [self addSubview:_progressLabel];
//    }
//    
//    return _progressLabel;
//}

- (double)percent {
    return self.progressLayer.percent;
}

- (NSTimeInterval)timeLimit {
    return self.progressLayer.timeLimit; // might prefer this getter in some cases
}

- (void)setTimeLimit:(NSTimeInterval)timeLimit {
    self.progressLayer.timeLimit = timeLimit;
}


- (void)setElapsedTime:(NSTimeInterval)elapsedTime {
    _elapsedTime = elapsedTime;
    self.progressLayer.elapsedTime = elapsedTime;
   // self.progressLabel.attributedText = [self formatProgressStringFromTimeInterval:elapsedTime];
}

-(void)setStartingTemp:(CGFloat)startingTemp { // convention would just name a property startingTemp, might be better
    _startingTemp = startingTemp;
    self.progressLayer.startingTemp = startingTemp;
}
- (void)setTargetTemp:(CGFloat)targetTemp {
    
    _targetTemp = targetTemp;
    self.progressLayer.targetTemp = targetTemp; // set target for reference in Layer drawing
}

-(void)setLayerState:(ProgressState)layerState {
    _layerState = layerState;
    self.progressLayer.layerState = layerState;
}
- (void)setCurrentTemp:(CGFloat)currentTemp {
    _currentTemp = currentTemp;
    self.progressLayer.currentTemp = currentTemp;
    
}
#pragma mark - Private Methods

- (void)setupViews {
    
    self.backgroundColor = [UIColor clearColor];
    self.clipsToBounds = false;
    
    //add Progress layer
    self.progressLayer = [[FSTCookingProgressLayer alloc] init];
    self.progressLayer.frame = self.bounds;
    self.progressLayer.backgroundColor = [UIColor clearColor].CGColor;
    [self.layer addSublayer:self.progressLayer];     
}

/*- (void)setTintColor:(UIColor *)tintColor {
    self.progressLayer.progressColor = tintColor;
   // self.progressLabel.textColor = [UIColor whiteColor];
}*/

//- (NSString *)stringFromTimeInterval:(NSTimeInterval)interval shortDate:(BOOL)shortDate {
//    NSInteger ti = (NSInteger)interval;
//    NSInteger seconds = ti % 60;
//    NSInteger minutes = (ti / 60) % 60;
//    NSInteger hours = (ti / 3600);
//    
//    if (shortDate) {
//        return [NSString stringWithFormat:@"%02ld:%02ld", (long)hours, (long)minutes];
//    }
//    else {
//        return [NSString stringWithFormat:@"%02ld:%02ld:%02ld", (long)hours, (long)minutes, (long)seconds];
//    }
//    
//}

//- (NSAttributedString *)formatProgressStringFromTimeInterval:(NSTimeInterval)interval {
//    
//    NSString *progressString = [self stringFromTimeInterval:interval shortDate:false];
//    
//    NSMutableAttributedString *attributedString;
//    
//    
//    if (_status.length > 0) {
//        
//        attributedString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@\n%@", progressString, _status]];
//        
//        [attributedString addAttributes:@{
//                                          NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue-Bold" size:40]}
//                                  range:NSMakeRange(0, progressString.length)];
//        
//        [attributedString addAttributes:@{
//                                          NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue-thin" size:18]}
//                                  range:NSMakeRange(progressString.length+1, _status.length)];
//        
//    }
//    else
//    {
//        attributedString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",progressString]];
//        
//        [attributedString addAttributes:@{
//                                          NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue-Bold" size:18]}
//                                  range:NSMakeRange(0, progressString.length)];
//    }
//    
//    return attributedString;
//}


@end

// Copyright belongs to original author
// http://code4app.net (en) http://code4app.com (cn)
// From the most professional code share website: Code4App.net

