//
//  DiagnosticsStageTableViewCell.h
//  FirstBuild
//
//  Created by Myles Caley on 11/9/15.
//  Copyright © 2015 FirstBuild. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DiagnosticsStageTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *stage;
@property (strong, nonatomic) IBOutlet UILabel *minTime;
@property (strong, nonatomic) IBOutlet UILabel *power;
@property (strong, nonatomic) IBOutlet UILabel *maxTime;
@property (strong, nonatomic) IBOutlet UILabel *temp;
@property (strong, nonatomic) IBOutlet UILabel *transition;
@end
