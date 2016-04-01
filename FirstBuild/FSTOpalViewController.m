//
//  FSTOpalViewController.m
//  FirstBuild
//
//  Created by Myles Caley on 3/22/16.
//  Copyright © 2016 FirstBuild. All rights reserved.
//

#import "FSTOpalViewController.h"
#import "FSTOpalMainMenuTableViewController.h"

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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
  if ([segue.destinationViewController isKindOfClass:[FSTOpalMainMenuTableViewController class]])
  {
    FSTOpalMainMenuTableViewController* vc = (FSTOpalMainMenuTableViewController*)segue.destinationViewController;
    vc.opal = self.opal;
  }
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

@end
