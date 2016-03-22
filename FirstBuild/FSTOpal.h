//
//  FSTOpal.h
//  FirstBuild
//
//  Created by Myles Caley on 3/22/16.
//  Copyright © 2016 FirstBuild. All rights reserved.
//

#import "FSTBleProduct.h"

@protocol FSTOpalDelegate <NSObject>
@optional - (void) iceMakerStatusChanged: (NSNumber*) status;

@end

@interface FSTOpal : FSTBleProduct

@property (nonatomic, weak) id<FSTOpalDelegate> delegate;

- setNightLightOn: (BOOL) on;
- setIceMakerOn: (BOOL) on;

@end