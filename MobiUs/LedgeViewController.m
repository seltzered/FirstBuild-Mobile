//
//  LedgeViewController.m
//  FirstBuild
//
//  Created by Myles Caley on 4/22/15.
//  Copyright (c) 2015 FirstBuild. All rights reserved.
//

#import "FirebaseShared.h"

#import "LedgeViewController.h"


@interface LedgeViewController ()

@end

@implementation LedgeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //Firebase* rRef = [self.ledge.firebaseRef childByAppendingPath:@"R_actual"];
    [self.ledge.firebaseRef removeAllObservers];
    
    [self.ledge.firebaseRef observeEventType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
        id rawVal = snapshot.value;
        if (rawVal != [NSNull null])
        {
            NSDictionary* val = rawVal;
            float rValue = [(NSNumber *)[val objectForKey:@"R_actual"] doubleValue];
            float gValue = [(NSNumber *)[val objectForKey:@"G_actual"] doubleValue];
            float bValue = [(NSNumber *)[val objectForKey:@"B_actual"] doubleValue];
            
            self.sliderR.value = rValue;
            self.sliderG.value = gValue;
            self.sliderB.value = bValue;

        }
        NSLog(@"%@ -> %@", snapshot.key, snapshot.value);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)RValueChanged:(id)sender {
    Firebase *userConnectedRef = [self.ledge.firebaseRef childByAppendingPath:@"R"];
 
    UISlider* slider = (UISlider*)sender;
    NSNumber* value = [NSNumber numberWithInt:(int)slider.value];
    [userConnectedRef setValue:value];
}

- (IBAction)GValueChanged:(id)sender {
    Firebase *userConnectedRef = [self.ledge.firebaseRef childByAppendingPath:@"G"];
    
    UISlider* slider = (UISlider*)sender;
    NSNumber* value = [NSNumber numberWithInt:(int)slider.value];
    [userConnectedRef setValue:value];
}

- (IBAction)BValueChanged:(id)sender {
    Firebase *userConnectedRef = [self.ledge.firebaseRef childByAppendingPath:@"B"];
    
    UISlider* slider = (UISlider*)sender;
    NSNumber* value = [NSNumber numberWithInt:(int)slider.value];
    [userConnectedRef setValue:value];
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
