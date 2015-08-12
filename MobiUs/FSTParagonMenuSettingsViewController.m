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
    [self.paragonNameField setDelegate:self];
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
    // perhaps sender will work rather than have switch properties in .h
    if ([sender isKindOfClass:[UISwitch class]]) {
        NSLog(@"Switched Temp");
    }
}
         
- (IBAction)unitSwitched:(id)sender {
    if ([sender isKindOfClass:[UISwitch class]]) {
        NSLog(@"Switched Units");
    }
}

#pragma mark - textField delegate
 // copied from bluetooth commissioning
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    //set view above keyboard
    
    [UIView animateWithDuration:0.2
                          delay:0.0
                        options: UIViewAnimationOptionCurveEaseInOut
                     animations:^(void){
                         self.view.frame = CGRectOffset(self.view.superview.frame, 0, -4*self.view.frame.size.height/9);
                         self.view.transform = CGAffineTransformScale(CGAffineTransformIdentity, (self.view.frame.size.width/self.paragonNameField.frame.size.width)*.9, (self.view.frame.size.width/self.paragonNameField.frame.size.width)*.9);
                     }
                     completion:nil];
    
    
    return YES;
}

-(void)textFieldDidEndEditing:(UITextField*)textField {
    
    [UIView animateWithDuration:0.2
                          delay:0.0
                        options: UIViewAnimationOptionCurveEaseInOut
                     animations:^(void){
                         self.view.transform = CGAffineTransformIdentity;
                         self.view.frame = [self.view superview].frame; // sets back to outside frame
                     }
                     completion:nil];
    // set view back down // problem with the rotation
    self.currentParagon.friendlyName = textField.text;
    
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder]; // will invoke end editing for return key
    return YES;
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
