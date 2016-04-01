//
//  FSTOpalScheduleTableViewController.m
//  FirstBuild
//
//  Created by Myles Caley on 3/31/16.
//  Copyright © 2016 FirstBuild. All rights reserved.
//

/*
 File: FSTOpalScheduleTableViewController
 Abstract: The main table view controller of this app.
 Version: 1.6
 
 Disclaimer: IMPORTANT:  This Apple software is supplied to you by Apple
 Inc. ("Apple") in consideration of your agreement to the following
 terms, and your use, installation, modification or redistribution of
 this Apple software constitutes acceptance of these terms.  If you do
 not agree with these terms, please do not use, install, modify or
 redistribute this Apple software.
 
 In consideration of your agreement to abide by the following terms, and
 subject to these terms, Apple grants you a personal, non-exclusive
 license, under Apple's copyrights in this original Apple software (the
 "Apple Software"), to use, reproduce, modify and redistribute the Apple
 Software, with or without modifications, in source and/or binary forms;
 provided that if you redistribute the Apple Software in its entirety and
 without modifications, you must retain this notice and the following
 text and disclaimers in all such redistributions of the Apple Software.
 Neither the name, trademarks, service marks or logos of Apple Inc. may
 be used to endorse or promote products derived from the Apple Software
 without specific prior written permission from Apple.  Except as
 expressly stated in this notice, no other rights or licenses, express or
 implied, are granted by Apple herein, including but not limited to any
 patent rights that may be infringed by your derivative works or by other
 works in which the Apple Software may be incorporated.
 
 The Apple Software is provided by Apple on an "AS IS" basis.  APPLE
 MAKES NO WARRANTIES, EXPRESS OR IMPLIED, INCLUDING WITHOUT LIMITATION
 THE IMPLIED WARRANTIES OF NON-INFRINGEMENT, MERCHANTABILITY AND FITNESS
 FOR A PARTICULAR PURPOSE, REGARDING THE APPLE SOFTWARE OR ITS USE AND
 OPERATION ALONE OR IN COMBINATION WITH YOUR PRODUCTS.
 
 IN NO EVENT SHALL APPLE BE LIABLE FOR ANY SPECIAL, INDIRECT, INCIDENTAL
 OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
 SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 INTERRUPTION) ARISING IN ANY WAY OUT OF THE USE, REPRODUCTION,
 MODIFICATION AND/OR DISTRIBUTION OF THE APPLE SOFTWARE, HOWEVER CAUSED
 AND WHETHER UNDER THEORY OF CONTRACT, TORT (INCLUDING NEGLIGENCE),
 STRICT LIABILITY OR OTHERWISE, EVEN IF APPLE HAS BEEN ADVISED OF THE
 POSSIBILITY OF SUCH DAMAGE.
 
 Copyright (C) 2014 Apple Inc. All Rights Reserved.
 
 */

#import "FSTOpalScheduleTableViewController.h"
#import "FSTOpalScheduleTableViewCell.h"

#define kPickerAnimationDuration    0.40   // duration for the animation to slide the date picker into view
#define kDatePickerTag              99     // view tag identifiying the date picker view

#define kTitleKey       @"title"   // key for obtaining the data source item's title
#define kDateKey        @"date"    // key for obtaining the data source item's date value

static NSString *kDateCellID = @"dateCell";     // the cells with the start or end date
static NSString *kDatePickerID = @"datePicker"; // the cell containing the date picker

#pragma mark -

@interface FSTOpalScheduleTableViewController ()

@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, strong) NSDateFormatter *dateFormatter;

// keep track which indexPath points to the cell with UIDatePicker
@property (nonatomic, strong) NSIndexPath *datePickerIndexPath;

@property (assign) NSInteger pickerCellRowHeight;

@property (nonatomic, strong) IBOutlet UIDatePicker *pickerView;

@end

#pragma mark -

@implementation FSTOpalScheduleTableViewController

/*! Primary view has been loaded for this view controller
 */
- (void)viewDidLoad
{
  [super viewDidLoad];
  
  self.opal.delegate = self;
  
  NSMutableDictionary *_1 = [@{ kTitleKey : @"Sunday",
                                     kDateKey : [NSDate date] } mutableCopy];
  NSMutableDictionary *_2 = [@{ kTitleKey : @"Monday",
                              kDateKey : [NSDate date] } mutableCopy];
  NSMutableDictionary *_3 = [@{ kTitleKey : @"Tuesday",
                              kDateKey : [NSDate date] } mutableCopy];
  NSMutableDictionary *_4 = [@{ kTitleKey : @"Wednesday",
                                kDateKey : [NSDate date] } mutableCopy];
  NSMutableDictionary *_5 = [@{ kTitleKey : @"Thursday",
                                kDateKey : [NSDate date] } mutableCopy];
  NSMutableDictionary *_6 = [@{ kTitleKey : @"Friday",
                                kDateKey : [NSDate date] } mutableCopy];
  NSMutableDictionary *_7 = [@{ kTitleKey : @"Saturday",
                                kDateKey : [NSDate date] } mutableCopy];
  
  self.dataArray = @[_1, _2, _3, _4, _5, _6, _7];
  
  self.dateFormatter = [[NSDateFormatter alloc] init];
  [self.dateFormatter setDateStyle:NSDateFormatterNoStyle];    // show short-style date format
  [self.dateFormatter setTimeStyle:NSDateFormatterShortStyle];
  
  // obtain the picker view cell's height, works because the cell was pre-defined in our storyboard
  UITableViewCell *pickerViewCellToCheck = [self.tableView dequeueReusableCellWithIdentifier:kDatePickerID];
  self.pickerCellRowHeight = CGRectGetHeight(pickerViewCellToCheck.frame);
  
}

#pragma mark - Locale

/*! Determines if the given indexPath has a cell below it with a UIDatePicker.
 
 @param indexPath The indexPath to check if its cell has a UIDatePicker below it.
 */
- (BOOL)hasPickerForIndexPath:(NSIndexPath *)indexPath
{
  BOOL hasDatePicker = NO;
  
  NSInteger targetedRow = indexPath.row;
  targetedRow++;
  
  UITableViewCell *checkDatePickerCell =
  [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:targetedRow inSection:0]];
  UIDatePicker *checkDatePicker = (UIDatePicker *)[checkDatePickerCell viewWithTag:kDatePickerTag];
  
  hasDatePicker = (checkDatePicker != nil);
  return hasDatePicker;
}

/*! Updates the UIDatePicker's value to match with the date of the cell above it.
 */
- (void)updateDatePicker
{
  if (self.datePickerIndexPath != nil)
  {
    UITableViewCell *associatedDatePickerCell = [self.tableView cellForRowAtIndexPath:self.datePickerIndexPath];
    
    UIDatePicker *targetedDatePicker = (UIDatePicker *)[associatedDatePickerCell viewWithTag:kDatePickerTag];
    if (targetedDatePicker != nil)
    {
      // we found a UIDatePicker in this cell, so update it's date value
      //
      NSDictionary *itemData = self.dataArray[self.datePickerIndexPath.row - 1];
      [targetedDatePicker setDate:[itemData valueForKey:kDateKey] animated:NO];
    }
  }
}

/*! Determines if the UITableViewController has a UIDatePicker in any of its cells.
 */
- (BOOL)hasInlineDatePicker
{
  return (self.datePickerIndexPath != nil);
}

/*! Determines if the given indexPath points to a cell that contains the UIDatePicker.
 
 @param indexPath The indexPath to check if it represents a cell with the UIDatePicker.
 */
- (BOOL)indexPathHasPicker:(NSIndexPath *)indexPath
{
  return ([self hasInlineDatePicker] && self.datePickerIndexPath.row == indexPath.row);
}

#pragma mark - UITableViewDataSource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  return ([self indexPathHasPicker:indexPath] ? self.pickerCellRowHeight : self.tableView.rowHeight);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  if ([self hasInlineDatePicker])
  {
    // we have a date picker, so allow for it in the number of rows in this section
    NSInteger numRows = self.dataArray.count;
    return ++numRows;
  }
  
  return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  FSTOpalScheduleTableViewCell *cell = nil;
  
  NSString *cellID;// = kOtherCell;
  
  if ([self indexPathHasPicker:indexPath])
  {
    // the indexPath is the one containing the inline date picker
    cellID = kDatePickerID;     // the current/opened date picker cell
  }
  else
  {
    // the indexPath is one that contains the date information
    cellID = kDateCellID;       // the start/end date cells
  }
  
  cell = (FSTOpalScheduleTableViewCell*) [tableView dequeueReusableCellWithIdentifier:cellID];

  // if we have a date picker open whose cell is above the cell we want to update,
  // then we have one more cell than the model allows
  //
  NSInteger modelRow = indexPath.row;
  if (self.datePickerIndexPath != nil && self.datePickerIndexPath.row <= indexPath.row)
  {
    modelRow--;
  }
  
  NSDictionary *itemData = self.dataArray[modelRow];
  
  // proceed to configure our cell
  if ([cellID isEqualToString:kDateCellID])
  {
    // we have either start or end date cells, populate their date field
    //
    cell.labelDayOutlet.text = [itemData valueForKey:kTitleKey];
    cell.labelTimeOutlet.text = [self.dateFormatter stringFromDate:[itemData valueForKey:kDateKey]];
  }

  return cell;
}

/*! Adds or removes a UIDatePicker cell below the given indexPath.
 
 @param indexPath The indexPath to reveal the UIDatePicker.
 */
- (void)toggleDatePickerForSelectedIndexPath:(NSIndexPath *)indexPath
{
  [self.tableView beginUpdates];
  
  NSArray *indexPaths = @[[NSIndexPath indexPathForRow:indexPath.row + 1 inSection:0]];
  
  // check if 'indexPath' has an attached date picker below it
  if ([self hasPickerForIndexPath:indexPath])
  {
    // found a picker below it, so remove it
    [self.tableView deleteRowsAtIndexPaths:indexPaths
                          withRowAnimation:UITableViewRowAnimationFade];
  }
  else
  {
    // didn't find a picker below it, so we should insert it
    [self.tableView insertRowsAtIndexPaths:indexPaths
                          withRowAnimation:UITableViewRowAnimationFade];
  }
  
  [self.tableView endUpdates];
}

/*! Reveals the date picker inline for the given indexPath, called by "didSelectRowAtIndexPath".
 
 @param indexPath The indexPath to reveal the UIDatePicker.
 */
- (void)displayInlineDatePickerForRowAtIndexPath:(NSIndexPath *)indexPath
{
  // display the date picker inline with the table content
  [self.tableView beginUpdates];
  
  BOOL before = NO;   // indicates if the date picker is below "indexPath", help us determine which row to reveal
  if ([self hasInlineDatePicker])
  {
    before = self.datePickerIndexPath.row < indexPath.row;
  }
  
  BOOL sameCellClicked = (self.datePickerIndexPath.row - 1 == indexPath.row);
  
  // remove any date picker cell if it exists
  if ([self hasInlineDatePicker])
  {
    [self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:self.datePickerIndexPath.row inSection:0]]
                          withRowAnimation:UITableViewRowAnimationFade];
    self.datePickerIndexPath = nil;
  }
  
  if (!sameCellClicked)
  {
    // hide the old date picker and display the new one
    NSInteger rowToReveal = (before ? indexPath.row - 1 : indexPath.row);
    NSIndexPath *indexPathToReveal = [NSIndexPath indexPathForRow:rowToReveal inSection:0];
    
    [self toggleDatePickerForSelectedIndexPath:indexPathToReveal];
    self.datePickerIndexPath = [NSIndexPath indexPathForRow:indexPathToReveal.row + 1 inSection:0];
  }
  
  // always deselect the row containing the start or end date
  [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
  
  [self.tableView endUpdates];
  
  // inform our date picker of the current date to match the current cell
  [self updateDatePicker];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
  if (cell.reuseIdentifier == kDateCellID)
  {
      [self displayInlineDatePickerForRowAtIndexPath:indexPath];
  }
  else
  {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
  }
}

#pragma mark - Actions

/*! User chose to change the date by changing the values inside the UIDatePicker.
 
 @param sender The sender for this action: UIDatePicker.
 */
- (IBAction)dateAction:(id)sender
{
  NSIndexPath *targetedCellIndexPath = nil;
  
  if ([self hasInlineDatePicker])
  {
    // inline date picker: update the cell's date "above" the date picker cell
    //
    targetedCellIndexPath = [NSIndexPath indexPathForRow:self.datePickerIndexPath.row - 1 inSection:0];
  }
  else
  {
    // external date picker: update the current "selected" cell's date
    targetedCellIndexPath = [self.tableView indexPathForSelectedRow];
  }
  
  FSTOpalScheduleTableViewCell *cell = [self.tableView cellForRowAtIndexPath:targetedCellIndexPath];
  UIDatePicker *targetedDatePicker = sender;
  
  // update our data model
  NSMutableDictionary *itemData = self.dataArray[targetedCellIndexPath.row];
  [itemData setValue:targetedDatePicker.date forKey:kDateKey];
  
  // update the cell's date string
  cell.labelTimeOutlet.text = [self.dateFormatter stringFromDate:targetedDatePicker.date];
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
  
  if ([tableView respondsToSelector:@selector(setSeparatorInset:)]) {
    [tableView setSeparatorInset:UIEdgeInsetsZero];
  }
  
  if ([tableView respondsToSelector:@selector(setLayoutMargins:)]) {
    [tableView setLayoutMargins:UIEdgeInsetsZero];
  }
  
  if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
    [cell setLayoutMargins:UIEdgeInsetsZero];
  }
}

#pragma mark - opal delegate
- (void)iceMakerCleanCycleChanged:(NSNumber *)cycle {
  NSLog(@"iceMakerCleanCycleChanged: %d", cycle.intValue);
  //  self.cleanCycleOutlet.text = cycle.stringValue;
}

@end

