//
//  FSTOpalMenuHelpViewController.m
//  FirstBuild
//
//  Created by Myles Caley on 4/28/16.
//  Copyright © 2016 FirstBuild. All rights reserved.
//

#import "FSTOpalMenuHelpViewController.h"

@implementation FSTOpalMenuHelpViewController
- (IBAction)warrantyTap:(id)sender
{
  NSString *subject = [NSString stringWithFormat:@"Opal Warranty Contact"];
  NSString *mail = [NSString stringWithFormat:@"warranty@firstbuild.com"];
  NSURL *url = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"mailto:?to=%@&subject=%@",
                                              [mail stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding],
                                              [subject stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding]]];
  [[UIApplication sharedApplication] openURL:url];
}

- (IBAction)expertTap:(id)sender
{
  NSString *subject = [NSString stringWithFormat:@"Opal Expert Contact"];
  NSString *mail = [NSString stringWithFormat:@"support@firstbuild.com"];
  NSURL *url = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"mailto:?to=%@&subject=%@",
                                              [mail stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding],
                                              [subject stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding]]];
  [[UIApplication sharedApplication] openURL:url];
}

- (IBAction)faqTap:(id)sender
{
  [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://firstbuildhelp.zendesk.com/hc/en-us/categories/203029708-Opal-Nugget-Ice-Maker"]];
}
@end
