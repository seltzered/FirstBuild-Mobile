//
//  FSTCookingProgressView.h
//  FirstBuild
//
//  Created by Myles Caley on 5/22/15.
//  Copyright (c) 2015 FirstBuild. All rights reserved.
//

//
//  CircleProgressView.h
//  CircularProgressControl
//
//  Created by Carlos Eduardo Arantes Ferreira on 22/11/14.
//  Copyright (c) 2014 Mobistart. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FSTCookingProgressLayer.h"

@interface FSTCookingProgressView : UIControl

@property (nonatomic, strong) FSTCookingProgressLayer *progressLayer;

- (void)setupViewsWithLayerClass: (Class) layerClass ;


@end

// Copyright belongs to original author
// http://code4app.net (en) http://code4app.com (cn)
// From the most professional code share website: Code4App.net

