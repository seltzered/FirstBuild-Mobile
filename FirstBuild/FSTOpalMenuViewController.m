//
//  FSTOpalMenuViewController.m
//  FirstBuild
//
//  Created by Myles Caley on 4/25/16.
//  Copyright © 2016 FirstBuild. All rights reserved.
//

#import "FSTOpalMenuViewController.h"
#import "FSTRevealViewController.h"
#import "FSTOpalDiagnosticsViewController.h"
#import "FSTOpalMenuAboutViewController.h"

@interface FSTOpalMenuViewController ()

@end

@implementation FSTOpalMenuViewController
{
  
}

typedef NS_ENUM(NSInteger, FSTMenuOptions) {
  kHome,
  kHelp,
  kFeedback,
  kAbout,
  kUpdates
};

-(void)viewDidLoad {
  [super viewDidLoad];
  self.navigationController.interactivePopGestureRecognizer.enabled = false;
}

#pragma mark - Table view data source


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  static NSString *CellIdentifier = @"Cell";
  switch (indexPath.row) {
    case kHome:
      CellIdentifier = @"home";
      break;
      //        case kSettings:
      //            CellIdentifier = @"settings";
      //            break;
    case kHelp:
      CellIdentifier = @"help";
      break;
    case kFeedback:
      CellIdentifier = @"feedback";
      break;
    case kAbout:
      CellIdentifier = @"about";
      break;
    case kUpdates:
      CellIdentifier = @"updates";
      break;
      //    case kDiagnostics:
      //        CellIdentifier = @"diagnostics";
      //      break;
    default:
      break;
  }
  
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: CellIdentifier forIndexPath: indexPath];
  
  return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  
  if (indexPath.row == kHome)
  {
    [self.revealViewController rightRevealToggle:self]; // should this happen every time?
    [[NSNotificationCenter defaultCenter] postNotificationName:FSTMenuItemSelectedNotification object:FSTMenuItemHome];
    //    } else if (indexPath.row == kSettings) {
    //        [self performSegueWithIdentifier:@"menuSettingsSegue" sender:self];
  } else if (indexPath.row == kHelp) {
    [self performSegueWithIdentifier:@"menuHelpSegue" sender:self];
  } else if (indexPath.row == kFeedback) {
    NSString *subject = [NSString stringWithFormat:@"Opal iOS App Feedback"];
    NSString *mail = [NSString stringWithFormat:@"support@firstbuild.com"];
    NSURL *url = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"mailto:?to=%@&subject=%@",
                                                [mail stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding],
                                                [subject stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding]]];
    [[UIApplication sharedApplication] openURL:url];
  } else if (indexPath.row == kAbout) {
    [self performSegueWithIdentifier:@"menuAboutSegue" sender:self];
  } else if (indexPath.row == kUpdates) {
    [self.currentOpal checkForAndUpdateFirmware];
  }
//  else if (indexPath.row == kDiagnostics) {
//      [self performSegueWithIdentifier:@"menuDiagnosticsSegue" sender:self];
//  }
  
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
  UIViewController* vc = segue.destinationViewController; // store vc to be cast in these statements
//  if ([segue.identifier isEqualToString:@"menuSettingsSegue"]) {
//    ((FSTParagonMenuSettingsViewController*)vc).currentParagon = self.currentParagon;
//  } else if([segue.identifier isEqualToString:@"menuAboutSegue"]) {
//    // set paragon (not yet a member)
//  }
  if([segue.identifier isEqualToString:@"menuDiagnosticsSegue"])
  {
    ((FSTOpalDiagnosticsViewController*)vc).currentOpal = self.currentOpal;
  }
  else if([segue.identifier isEqualToString:@"menuAboutSegue"])
  {
    ((FSTOpalMenuAboutViewController*)vc).opal = self.currentOpal;
  }
}
#pragma mark - BONEYARD

@end
