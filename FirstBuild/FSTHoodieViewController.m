//
//  FSTHoodieViewController.m
//  FirstBuild
//
//  Created by Myles Caley on 10/5/15.
//  Copyright © 2015 FirstBuild. All rights reserved.
//

#import "FSTHoodieViewController.h"
#import <STTwitter.h>

@interface FSTHoodieViewController ()

@property (strong, nonatomic) IBOutlet UITextField *textOverride;
@property (strong, nonatomic) IBOutlet UISwitch *autoSwitch;

@end

@implementation FSTHoodieViewController
{
    STTwitterAPI *twitter;
    NSString *currentText;
}

//TODO: dealloc/memory stuff
- (void)viewDidLoad {
    [super viewDidLoad];
    [self startTwitterListener];
    self.autoSwitch.on = NO;
    // Do any additional setup after loading the view.
}

- (void)startTwitterListener
{
    twitter = [STTwitterAPI twitterAPIOSWithFirstAccount];
    
    __weak typeof(self) weakSelf = self;
    
    
    [twitter verifyCredentialsWithUserSuccessBlock:^(NSString *username, NSString *userID) {
        NSLog(@"-- Account: %@", username);
        
        [self tick];
        [NSTimer scheduledTimerWithTimeInterval:10.0
                                         target:weakSelf
                                       selector:@selector(tick)
                                       userInfo:nil
                                        repeats:YES];
    } errorBlock:^(NSError *error) {
        NSLog(@"-- %@", [error localizedDescription]);
    }];
}

- (void)tick
{
    [twitter getSearchTweetsWithQuery:@"#smarthoodie" successBlock:^(NSDictionary *searchMetadata, NSArray *statuses)
    {
        NSLog(@"Search data : %@",searchMetadata);
        NSString *text = ((NSArray*)([statuses valueForKeyPath:@"text"]))[0];
        
        NSLog(@"data : %@",[statuses valueForKeyPath:@"text"]);
        
        if (![currentText isEqualToString:text] && self.autoSwitch.on)
        {
            self.textOverride.text = text;
            currentText = text;
            [self.hoodie writeTextOnHoodie:text];
        }
    } errorBlock:^(NSError *error) {
        NSLog(@"Error : %@",error);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)sendClicked:(id)sender {
//    for (int i =0; i<100; i++) {
//        [self.hoodie writeTextOnHoodie:[NSString stringWithFormat:@"%d",i]];
//    }
    [self.hoodie writeTextOnHoodie:self.textOverride.text];
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
