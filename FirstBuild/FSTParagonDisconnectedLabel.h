//
//  FSTParagonDisconnectedLabel.h
//  FirstBuild
//
//  Created by John Nolan on 6/30/15.
//  Copyright (c) 2015 FirstBuild. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FSTParagonDisconnectedLabelDelegate

-(void)popFromWarning;

@end


//TODO make label generic for all devices
@interface FSTParagonDisconnectedLabel : UILabel

@property (nonatomic, weak) id<FSTParagonDisconnectedLabelDelegate> delegate;
@end
