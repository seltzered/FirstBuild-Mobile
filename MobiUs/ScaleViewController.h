//
//  ScaleViewController.h
//  FirstBuild-Mobile
//
//  Created by Myles Caley on 10/17/14.
//  Copyright (c) 2014 FirstBuild. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FSTMilkyWeigh.h"
#import "MilkGallonClippingView.h"
#import "SCSiriWaveformView.h"

@interface ScaleViewController : UIViewController

@property (strong, nonatomic) FSTMilkyWeigh *milkyWeigh;
@property (strong, nonatomic) IBOutlet UIImageView *backgroundView;
@property (strong, nonatomic) IBOutlet UIView *whiteView; //view that lays in the white behind the jug
@property (strong, nonatomic) IBOutlet MilkGallonClippingView *clippingView; //view that draws and clips the white view
@property (strong, nonatomic) UIView *whiteFillView;
@property (strong, nonatomic) SCSiriWaveformView *waveView;
@end
