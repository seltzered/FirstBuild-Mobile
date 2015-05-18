//
//  FSTBeefSettingsViewController.m
//  FirstBuild
//
//  Created by Myles Caley on 5/12/15.
//  Copyright (c) 2015 FirstBuild. All rights reserved.
//

#import "FSTBeefSettingsViewController.h"

@interface FSTBeefSettingsViewController ()

@property (strong, nonatomic) IBOutlet UIView *thicknessSelectionView;

@end

@implementation FSTBeefSettingsViewController

CGFloat startingHeight;
CGFloat startingOrigin;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)thicknessPanGesture:(id)sender {
    UIPanGestureRecognizer* gesture = (UIPanGestureRecognizer*)sender;
    
    CGFloat yTranslation =[gesture translationInView:gesture.view.superview].y;
    CGFloat yGestureLocation = [gesture locationInView:gesture.view.superview].y;

    if (gesture.state == UIGestureRecognizerStateBegan)
    {
        startingHeight = self.thicknessSelectionView.frame.size.height;
        startingOrigin = self.thicknessSelectionView.frame.origin.y;
        
        NSLog(@"start (frame o:%f,s:%f) (bounds o:%f, s:%f)", self.thicknessSelectionView.frame.origin.y, self.thicknessSelectionView.frame.size.height, self.thicknessSelectionView.bounds.origin.y, self.thicknessSelectionView.bounds.size.height);
        
    }
    else
    {
        CGRect frame = self.thicknessSelectionView.frame;
        frame.origin.y = startingOrigin + yTranslation;
        frame.size.height = startingHeight - yTranslation;
        [self.thicknessSelectionView setFrame:frame];
        
         NSLog(@"translation: %f, gesture y %f, new y %f, new height %f", yTranslation, yGestureLocation,frame.origin.y, frame.size.height);
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
