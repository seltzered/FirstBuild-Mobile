//
//  FSTParagonMenuHelpViewController.m
//  FirstBuild
//
//  Created by Myles Caley on 1/11/16.
//  Copyright © 2016 FirstBuild. All rights reserved.
//

#import "FSTParagonMenuHelpViewController.h"

@implementation FSTParagonMenuHelpViewController
{
    
}

- (IBAction)warrantyTap:(id)sender
{
    NSString *subject = [NSString stringWithFormat:@"Paragon Warranty Contact"];
    NSString *mail = [NSString stringWithFormat:@"warranty@firstbuild.com"];
    NSURL *url = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"mailto:?to=%@&subject=%@",
                                                [mail stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding],
                                                [subject stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding]]];
    [[UIApplication sharedApplication] openURL:url];
}

- (IBAction)expertTap:(id)sender
{
    NSString *subject = [NSString stringWithFormat:@"Paragon Expert Contact"];
    NSString *mail = [NSString stringWithFormat:@"paragon@firstbuild.com"];
    NSURL *url = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"mailto:?to=%@&subject=%@",
                                                [mail stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding],
                                                [subject stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding]]];
    [[UIApplication sharedApplication] openURL:url];
}

- (IBAction)faqTap:(id)sender
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://paragoninductioncooktop.com"]];
}
@end
