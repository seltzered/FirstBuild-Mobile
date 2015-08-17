//
//  FSTStagePickerManager.h
//  FirstBuild
//
//  Created by John Nolan on 8/14/15.
//  Copyright (c) 2015 FirstBuild. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol FSTStagePickerManagerDelegate <NSObject>

-(void)updateLabels;

@end

@interface FSTStagePickerManager : NSObject <UIPickerViewDataSource, UIPickerViewDelegate>

@property UIPickerView* minPicker;

@property UIPickerView* maxPicker;

@property UIPickerView* tempPicker;

@property id<FSTStagePickerManagerDelegate> delegate;

/*-(NSString*)titleForRow:(NSInteger)row inComponent:(NSInteger)component forPickerIndex:(StagePickerIndex)index;

-(NSInteger)numberOfRowsInComponent:(NSInteger)component forPickerIndex:(StagePickerIndex)index;
*/

-(NSNumber*)minMinutesChosen;

-(NSNumber*)maxMinutesChosen;

-(NSNumber*)temperatureChosen;

-(NSAttributedString*)minLabel;

-(NSAttributedString*)maxLabel;

-(NSAttributedString*)tempLabel;

-(void)selectAllIndices; // hard set the min max temp indices

@end
