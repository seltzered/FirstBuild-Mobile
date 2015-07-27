//
//  FSTParagonMenuSettingsViewController.m
//  FirstBuild
//
//  Created by John Nolan on 7/27/15.
//  Copyright (c) 2015 FirstBuild. All rights reserved.
//

#import "FSTParagonMenuSettingsViewController.h"

@interface FSTParagonMenuSettingsViewController ()

@end

@implementation FSTParagonMenuSettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.paragonNameField.delegate = self;
    // perform actions when editing ends
}
//TODO: two switches with seperate actions (IBAactions might be best, rather than delegates)
- (void)viewWillAppear:(BOOL)animated {
    self.serialNumberLabel.text = self.currentParagon.serialNumber;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - IBActions
- (IBAction)tempSwitched:(id)sender {
    // perhaps sender will work rather thanhave switch properties
    if ([sender isKindOfClass:[UISwitch class]]) {
        NSLog(@"Switched Temp");
    }
}
         
- (IBAction)unitSwitched:(id)sender {
    
}
#pragma mark - textField delegate
- (void) textFieldDidEndEditing:(UITextField *)textField {
    self.currentParagon.friendlyName = textField.text;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
