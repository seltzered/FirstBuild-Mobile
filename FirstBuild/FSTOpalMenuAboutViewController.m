//
//  FSTOpalMenuAboutViewController.m
//  FirstBuild
//
//  Created by Myles Caley on 4/28/16.
//  Copyright © 2016 FirstBuild. All rights reserved.
//

#import "FSTOpalMenuAboutViewController.h"

@implementation FSTOpalMenuAboutViewController
{
  IBOutlet UILabel *labelVersion;
  IBOutlet UILabel *labelFirmwareVersion;
  IBOutlet UILabel *labelBluetoothVersion;
  
}
- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
  NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
  labelVersion.text = version;
  
  labelFirmwareVersion.text = [NSString stringWithFormat:@"0%04x", self.opal.currentAppVersion];
  labelBluetoothVersion.text = [NSString stringWithFormat:@"0%04x", self.opal.currentBleVersion];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (IBAction)sourceTap:(id)sender {
  [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://www.github.com/FirstBuild/FirstBuild-Mobile"]];
}

- (IBAction)learnMoreTap:(id)sender {
  
  [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://cocreate.firstbuild.com/JBerg/opal-nugget-ice-maker/activity/"]];
  
}

@end
