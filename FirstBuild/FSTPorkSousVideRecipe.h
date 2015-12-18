//
//  FSTPorkSousVideRecipe.h
//  FirstBuild
//
//  Created by Myles Caley on 12/18/15.
//  Copyright © 2015 FirstBuild. All rights reserved.
//

#import "FSTSousVideRecipe.h"

@interface FSTPorkSousVideRecipe : FSTSousVideRecipe
@property (nonatomic, retain) NSArray* thicknesses;
@property (nonatomic, retain) NSDictionary* thicknessLabels;
@property (nonatomic, retain) NSArray* donenesses;
@property (nonatomic, retain) NSDictionary* donenessLabels;

@property (nonatomic, retain) NSDictionary* cookingTimes;
@end
