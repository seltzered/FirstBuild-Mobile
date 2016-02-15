//
//  FSTBleNamingViewController.m
//  FirstBuild
//
//  Created by John Nolan on 6/25/15.
//  Copyright (c) 2015 FirstBuild. All rights reserved.
//

#import "FSTBleNamingViewController.h"
#import "FSTBleCentralManager.h"
#import "FSTParagon.h"

@interface FSTBleNamingViewController ()

@end

@implementation FSTBleNamingViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.paragonNameField setDelegate:self];

    self.navigationItem.hidesBackButton = YES;
    
}

-(void)viewDidAppear:(BOOL)animated {

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)continueTap:(id)sender {
    
    [[FSTBleCentralManager sharedInstance]savePeripheral:self.peripheral havingUUIDString:[self.peripheral.identifier UUIDString] withName:self.paragonNameField.text className:self.bleProductClass]; // get text from box and save peripheral

    // this is a little bit of a hack, but if its a paragon product we need to show
    // the food warning screen
    if (self.bleProductClass == [FSTParagon class])
    {
        [self performSegueWithIdentifier:@"segueWarning" sender:nil];

    }
    else
    {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

#pragma mark - TextFieldDelegate

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

}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder]; // will invoke end editing for return key
    return YES;
}

#pragma mark - Navigation
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // really not much to do.
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


@end
