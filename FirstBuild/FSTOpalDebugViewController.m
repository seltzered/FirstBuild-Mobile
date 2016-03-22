//
//  FSTOpalDebugViewController.m
//  FirstBuild
//
//  Created by Myles Caley on 3/22/16.
//  Copyright © 2016 FirstBuild. All rights reserved.
//

#import "FSTOpalDebugViewController.h"

@interface FSTOpalDebugViewController ()

@property (strong, nonatomic) IBOutlet UILabel *stateOutlet;
@property (strong, nonatomic) IBOutlet UISwitch *modeOutlet;
@property (strong, nonatomic) IBOutlet UISwitch *lightOutlet;
@property (strong, nonatomic) IBOutlet UILabel *cleanCycleOutlet;

@end

@implementation FSTOpalDebugViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)modeAction:(id)sender {
}
- (IBAction)lightAction:(id)sender {
}

# pragma mark - delegate
- (void) iceMakerStatusChanged:(NSNumber *)status {
  NSLog(@"iceMakerStatusChanged: %d", status.intValue);
}

@end
