//
//  FSTOpalDiagnosticsViewController.m
//  FirstBuild
//
//  Created by Myles Caley on 4/27/16.
//  Copyright © 2016 FirstBuild. All rights reserved.
//

#import "FSTOpalDiagnosticsViewController.h"

@implementation FSTOpalDiagnosticsViewController
{
  IBOutlet UILabel *bucketStatusOutlet;
  
}

-(void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  self.currentOpal.delegate = self;
  [self setBucketLabel];

  
}

-(void)setBucketLabel
{
  if (self.currentOpal.opalErrorCode == 0) {
    bucketStatusOutlet.text = @"Closed";
  } else if (self.currentOpal.opalErrorCode == 1) {
    bucketStatusOutlet.text = @"Open";
  } else {
    bucketStatusOutlet.text = @"Unknown";
  }
}

-(void) iceMakerErrorChanged
{
  [self setBucketLabel];
}

@end
