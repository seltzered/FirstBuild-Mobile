//
//  FSTOpalViewController.m
//  FirstBuild
//
//  Created by Myles Caley on 3/22/16.
//  Copyright © 2016 FirstBuild. All rights reserved.
//

#import "FSTOpalViewController.h"

@interface FSTOpalViewController ()

@end

@implementation FSTOpalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

# pragma mark - delegate
- (void) iceMakerStatusChanged:(NSNumber *)status {
  NSLog(@"iceMakerStatusChanged: %d", status.intValue);
//  
//  switch (status.intValue) {
//    case 0:
//      self.stateOutlet.text = @"idle";
//      break;
//      
//    case 1:
//      self.stateOutlet.text = @"ice making";
//      break;
//      
//    case 2:
//      self.stateOutlet.text = @"add water";
//      break;
//      
//    case 3:
//      self.stateOutlet.text = @"ice full";
//      break;
//      
//    case 4:
//      self.stateOutlet.text = @"cleaning";
//      break;
//      
//    default:
//      break;
//  }
  
}

- (void)iceMakerLightChanged:(BOOL)on {
  NSLog(@"iceMakerLightChanged: %d", on);
//  [self.lightOutlet setOn:on];
}

- (void)iceMakerModeChanged:(BOOL)on {
  NSLog(@"iceMakerModeChanged: %d", on);
//  [self.modeOutlet setOn:on];
  
}

- (void)iceMakerCleanCycleChanged:(NSNumber *)cycle {
  NSLog(@"iceMakerCleanCycleChanged: %d", cycle.intValue);
//  self.cleanCycleOutlet.text = cycle.stringValue;
}


@end
