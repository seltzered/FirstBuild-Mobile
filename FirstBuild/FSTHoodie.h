//
//  FSTHoodie.h
//  FirstBuild
//
//  Created by Myles Caley on 10/5/15.
//  Copyright © 2015 FirstBuild. All rights reserved.
//

#import "FSTBleProduct.h"

@protocol FSTHoodieDelegate <NSObject>

@end

@interface FSTHoodie : FSTBleProduct

@property (nonatomic, weak) id<FSTHoodieDelegate> delegate;

- (void) writeTextOnHoodie: (NSString*)text;

@end
