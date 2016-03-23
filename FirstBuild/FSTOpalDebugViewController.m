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
  
  self.opal.delegate = self;
  switch ( self.opal.status.intValue) {
    case 0:
      self.stateOutlet.text = @"idle";
      break;
      
    case 1:
      self.stateOutlet.text = @"ice making";
      break;
      
    case 2:
      self.stateOutlet.text = @"add water";
      break;
      
    case 3:
      self.stateOutlet.text = @"ice full";
      break;
      
    case 4:
      self.stateOutlet.text = @"cleaning";
      break;
      
    default:
      break;
  }
  
  self.lightOutlet.on = self.opal.nightLightOn;
  self.modeOutlet.on = self.opal.iceMakerOn;
  self.cleanCycleOutlet.text = self.opal.cleanCycle.stringValue;
  
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)modeAction:(id)sender {
  
  [self.opal turnIceMakerOn:((UISwitch*)sender).on];
  
}

- (IBAction)lightAction:(id)sender {
  
  [self.opal turnNightLightOn:((UISwitch*)sender).on];
  
}


# pragma mark - delegate
- (void) iceMakerStatusChanged:(NSNumber *)status {
  NSLog(@"iceMakerStatusChanged: %d", status.intValue);
  
  switch (status.intValue) {
    case 0:
      self.stateOutlet.text = @"idle";
      break;
      
    case 1:
      self.stateOutlet.text = @"ice making";
      break;
      
    case 2:
      self.stateOutlet.text = @"add water";
      break;
    
    case 3:
      self.stateOutlet.text = @"ice full";
      break;
    
    case 4:
      self.stateOutlet.text = @"cleaning";
      break;
      
    default:
      break;
  }
  
}

- (void)iceMakerLightChanged:(BOOL)on {
  NSLog(@"iceMakerLightChanged: %d", on);
  [self.lightOutlet setOn:on];
}

- (void)iceMakerModeChanged:(BOOL)on {
  NSLog(@"iceMakerModeChanged: %d", on);
  [self.modeOutlet setOn:on];
  
}

- (void)iceMakerCleanCycleChanged:(NSNumber *)cycle {
  NSLog(@"iceMakerCleanCycleChanged: %d", cycle.intValue);
  self.cleanCycleOutlet.text = cycle.stringValue;
}

@end
