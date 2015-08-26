//
//  FSTSavedRecipeIngredientsViewController
//  FirstBuild
//
//  Created by John Nolan on 8/24/15.
//  Copyright (c) 2015 FirstBuild. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FSTSavedRecipeIngredientsViewController : UIViewController <UITextViewDelegate>

@property (strong, nonatomic) NSMutableString* ingredients; //needs to be strong since there is a new string initialized upon entering text

@end
