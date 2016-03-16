//
//  FSTPizzaOvenViewController.m
//  FirstBuild
//
//  Created by Myles Caley on 10/5/15.
//  Copyright © 2015 FirstBuild. All rights reserved.
//

#import "FSTPizzaOvenViewController.h"

@interface FSTPizzaOvenViewController ()
@property (strong, nonatomic) IBOutlet UILabel *labelDisplayTemperature;
@property (strong, nonatomic) IBOutlet UITextField *textBoxSetTemperature;

- (IBAction)buttonSetTempTapped:(id)sender;
@end

@implementation FSTPizzaOvenViewController
{
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"The view did load.");
    self.oven.delegate = self;
    self.labelDisplayTemperature.text = [[self.oven getCurrentDisplayTemperature] stringValue];
    self.textBoxSetTemperature.text = [[self.oven getCurrentSetTemperature] stringValue];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)displayTemperatureChanged:(NSNumber *)temperature
{
  self.labelDisplayTemperature.text = [temperature stringValue];
}

-(void)setTemperatureChanged:(NSNumber *)setTemp
{
    self.textBoxSetTemperature.text = [setTemp stringValue];
}

-(IBAction)buttonSetTempTapped:(id)sender {
    // do something when the button is pressed
    NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
    f.numberStyle = NSNumberFormatterDecimalStyle;
    NSNumber *myNumber = [f numberFromString:self.textBoxSetTemperature.text];
    NSLog(@"The set temp button was tapped: %@", myNumber);
    [self.oven setCurrentSetTemperature:myNumber];
}

@end

