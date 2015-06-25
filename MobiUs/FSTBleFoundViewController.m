//
//  FSTBleFoundViewController.m
//  FirstBuild
//
//  Created by John Nolan on 6/24/15.
//  Copyright (c) 2015 FirstBuild. All rights reserved.
//

#import "FSTBleFoundViewController.h"
#import "FSTBleNamingViewController.h"

@interface FSTBleFoundViewController ()

@end

@implementation FSTBleFoundViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

/*- (void)viewDidAppear:(BOOL)animated {
    [self performSegueWithIdentifier:@"segueNaming" sender:self];
 // this is bad, it performs too many segues and doesn't dealloc view controllers safely
}
*/
- (IBAction)paragonTap:(id)sender {
    
    [self performSegueWithIdentifier:@"segueNaming" sender:self];
    // Press the icon. just to test segues until I figure out when the segue actually happens. 
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"segueNaming"]) {
        FSTBleNamingViewController* vc = segue.destinationViewController;
        vc.peripheral = self.peripheral; // set the peripheral
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    }
}


@end
