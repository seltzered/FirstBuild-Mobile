//
//  FSTRecipeTableViewCell.h
//  FirstBuild
//
//  Created by John Nolan on 8/17/15.
//  Copyright (c) 2015 FirstBuild. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FSTRecipeTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *recipePhoto;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *noteLabel;

@end
