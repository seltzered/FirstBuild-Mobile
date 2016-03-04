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

@end

@implementation FSTPizzaOvenViewController
{
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.oven.delegate = self;
    self.labelDisplayTemperature.text = @"-";
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)displayTemperatureChanged:(NSNumber *)temperature
{
  self.labelDisplayTemperature.text = [temperature stringValue];
}

@end

