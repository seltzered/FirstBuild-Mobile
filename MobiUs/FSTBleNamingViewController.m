//
//  FSTBleNamingViewController.m
//  FirstBuild
//
//  Created by John Nolan on 6/25/15.
//  Copyright (c) 2015 FirstBuild. All rights reserved.
//

#import "FSTBleNamingViewController.h"
#import "FSTBleCentralManager.h"

@interface FSTBleNamingViewController ()

@end

@implementation FSTBleNamingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.paragonNameField addTarget:self action:@selector(beganEditingText) forControlEvents:UIControlEventEditingDidBegin];
    [self.paragonNameField addTarget:self action:@selector(didEnterText) forControlEvents:UIControlEventEditingDidEndOnExit]; // editing does tnot seem to be changing though.
    [self.bottomView.layer setBorderColor:[UIColor lightGrayColor].CGColor];
    [self.bottomView.layer setBorderWidth:2.5F];
    
    self.navigationItem.hidesBackButton = YES;
    
    //[self.paragonNameField becomeFirstResponder]; // focus on it? (should happen during editor might call resignFirstResponder on self later.
}

-(void)viewDidAppear:(BOOL)animated {

}
//-(void)viewDidAppear:(BOOL)animated
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)continueTap:(id)sender {
    
    [[FSTBleCentralManager sharedInstance]savePeripheral:self.peripheral havingUUIDString:[self.peripheral.identifier UUIDString] withName:self.paragonNameField.text]; // get text from box and save peripheral
    [self.navigationController popToRootViewControllerAnimated:NO];
}

-(void)beganEditingText {
    
    //set view above keyboard
    
    [UIView animateWithDuration:0.2
                          delay:0.0
                        options: UIViewAnimationOptionCurveEaseInOut
                     animations:^(void){
                         self.view.frame = CGRectOffset(self.view.frame, 0, -4*self.view.frame.size.height/9);
                         self.view.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.5, 1.5); // yes this is hard-coded
                     }
                     completion:nil];
        
    
}
-(void)didEnterText {
    [self.paragonNameField resignFirstResponder]; // endEditing
    
    [UIView animateWithDuration:0.2
                          delay:0.0
                        options: UIViewAnimationOptionCurveEaseInOut
                     animations:^(void){
                        self.view.transform = CGAffineTransformIdentity;
                        self.view.frame = CGRectOffset(self.view.frame, 0, 4*self.view.frame.size.height/9);
                     }
                     completion:nil];
    // set view back down
}

#pragma mark - Navigation
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // really not much to do.
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


@end
