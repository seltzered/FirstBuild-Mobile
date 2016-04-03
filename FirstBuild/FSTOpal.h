//
//  FSTOpal.h
//  FirstBuild
//
//  Created by Myles Caley on 3/22/16.
//  Copyright © 2016 FirstBuild. All rights reserved.
//

#import "FSTBleProduct.h"

#define kTitleKey       @"title"   // key for obtaining the data source item's title
#define kDateKey        @"date"    // key for obtaining the data source item's date value

@protocol FSTOpalDelegate <NSObject>
@optional - (void) iceMakerStatusChanged: (NSNumber*) status withLabel: (NSString*)label;
@optional - (void) iceMakerModeChanged: (BOOL) on;
@optional - (void) iceMakerLightChanged: (BOOL) on;
@optional - (void) iceMakerCleanCycleChanged: (NSNumber*) cycle;
@optional - (void) iceMakerScheduleChanged: (NSArray*) schedule;
@optional - (void) iceMakerScheduleEnabledChanged: (BOOL) on;

@optional - (void) iceMakerModeWritten:(NSError *)error;
@optional - (void) iceMakerNightLightWritten:(NSError *)error;
@optional - (void) iceMakerScheduleWritten:(NSError *)error;
@optional - (void) iceMakerScheduleEnabledWritten:(NSError *)error;

@end

@interface FSTOpal : FSTBleProduct

@property (strong, nonatomic) NSNumber* status;
@property (strong, nonatomic) NSString* statusLabel;
@property (strong, nonatomic) NSNumber* cleanCycle;
@property (strong, nonatomic) NSDate* time;
@property BOOL iceMakerOn;
@property BOOL nightLightOn;
@property BOOL scheduleEnabled;
@property (strong, nonatomic) NSArray* schedule;

@property (nonatomic, weak) id<FSTOpalDelegate> delegate;

- (void) turnNightLightOn: (BOOL) on;
- (void) turnIceMakerOn: (BOOL) on;
- (void) turnIceMakerScheduleOn: (BOOL) on;
- (void) configureSchedule: (NSArray*) schedule ;

@end