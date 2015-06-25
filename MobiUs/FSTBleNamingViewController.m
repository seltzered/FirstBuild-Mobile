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
    [self.paragonNameField addTarget:self action:@selector(didEnterText) forControlEvents:UIControlEventEditingDidEndOnExit]; // editing does tnot seem to be changing though.
    [self.bottomView.layer setBorderColor:[UIColor lightGrayColor].CGColor];
    [self.bottomView.layer setBorderWidth:2.5F];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)continueTap:(id)sender {
    
    [[FSTBleCentralManager sharedInstance]savePeripheralHavingUUIDString:[self.peripheral.identifier UUIDString] withName:self.paragonNameField.text]; // get text from box and save peripheral
    [self performSegueWithIdentifier:@"segueConnected" sender:self];
}

#pragma mark - Navigation
-(void)didEnterText {
    [self.paragonNameField resignFirstResponder]; // endEditing
}
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // really not much to do.
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


@end
