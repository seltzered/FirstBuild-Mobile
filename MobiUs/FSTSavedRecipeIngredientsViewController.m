//
//  FSTSavedRecipeIngredientsViewController.m
//  FirstBuild
//
//  Created by John Nolan on 8/24/15.
//  Copyright (c) 2015 FirstBuild. All rights reserved.
//

#import "FSTSavedRecipeIngredientsViewController.h"
#import "FSTColorImage.h"
#import "FSTSavedRecipeUnderLineView.h"

@interface FSTSavedRecipeIngredientsViewController ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *underLineSpacing;

@property (weak, nonatomic) IBOutlet FSTSavedRecipeUnderLineView *underLineView;


@end

@implementation FSTSavedRecipeIngredientsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.textView.delegate = self;
    //UIImage* selectedImage = [UIImage imageNamed:@"Paragon_Mark_Red"];//[FSTColorImage imageWithColor:[UIColor orangeColor] inRect:CGRectMake(0, 0, 30, 24)];
    //[self.tabBarItem setSelectedImage:selectedImage];
    //self.tabBarItem.imageInsets = UIEdgeInsetsMake(12, 0, -12, 0); // trying to shift the whole thing down.
    //title should be set in storyboard
}

-(void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    self.underLineSpacing.constant = self.tabBarController.tabBar.frame.size.height; // make room for the tab bar (maybe it starts under the tab bar? we shall see
    [self.underLineView setHorizontalPosition:self.view.frame.size.width/6]; // this is the first entry
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Text View delegate

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    } else {
        return YES;
    }
}


-(BOOL)textViewShouldEndEditing:(UITextView *)textView {
    // must set active recipe when parent segues
    return YES;
}



@end
