//
//  BeerBankViewController.m
//  FirstBuild
//
//  Created by Myles Caley on 5/4/15.
//  Copyright (c) 2015 FirstBuild. All rights reserved.
//

#import "BeerBankViewController.h"
#import <Firebase/Firebase.h>
#

@interface BeerBankViewController ()

@end

@implementation BeerBankViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.beerBank.firebaseRef removeAllObservers];
    [self.beerBank.firebaseRef observeEventType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
        id rawVal = snapshot.value;
        if (rawVal != [NSNull null])
        {
            NSDictionary* val = rawVal;
            uint32_t alarmSetValue = [(NSNumber *)[val objectForKey:@"alarm_set"] floatValue];
            
            if (alarmSetValue==1)
            {
                self.alarmSetButton.on = false;
            }
            else
            {
               self.alarmSetButton.on = true;
            }
        }
        NSLog(@"%@ -> %@", snapshot.key, snapshot.value);
    }];

    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)openSwitchClicked:(id)sender
{
    Firebase *ref = [self.beerBank.firebaseRef childByAppendingPath:@"alarm_set"];
    
    if(self.alarmSetButton.on)
    {
        [ref setValue:[NSNumber numberWithInt:0]];
        
    }
    else
    {
        [ref setValue:[NSNumber numberWithInt:1]];
        
    }
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
