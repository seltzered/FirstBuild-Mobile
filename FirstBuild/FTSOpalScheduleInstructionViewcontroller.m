//
//  FTSOpalScheduleInstructionViewcontroller.m
//  FirstBuild
//
//  Created by Gina on 11/07/2016.
//  Copyright © 2016 FirstBuild. All rights reserved.
//

#import "FTSOpalScheduleInstructionViewcontroller.h"

@implementation FTSOpalScheduleInstructionLastViewController

- (IBAction)onCloseButtonPressed:(id)sender {
  
  NSLog(@"gina] close button pressed!");
  [self.parentViewController dismissViewControllerAnimated:YES completion:nil];  
}

@end

@implementation FTSOpalScheduleInstructionViewcontroller

@end
