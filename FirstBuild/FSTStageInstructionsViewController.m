//
//  FSTStageInstructionsViewController.m
//  FirstBuild
//
//  Created by Myles Caley on 12/4/15.
//  Copyright © 2015 FirstBuild. All rights reserved.
//

#import "FSTStageInstructionsViewController.h"

@interface FSTStageInstructionsViewController ()
@property (strong, nonatomic) IBOutlet UITextView *textView;

@end

@implementation FSTStageInstructionsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)updateLabels
{
    [super updateLabels];
    self.textView.text = self.stagePrep;

}
@end
