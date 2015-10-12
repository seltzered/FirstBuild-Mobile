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

@end

@implementation FSTHoodieViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    [self startTwitterListener];
    // Do any additional setup after loading the view.
}

- (void)startTwitterListener
{
    STTwitterAPI *twitter = [STTwitterAPI twitterAPIOSWithFirstAccount];
    
    __weak typeof(self) weakSelf = self;
    
    [twitter verifyCredentialsWithUserSuccessBlock:^(NSString *username, NSString *userID) {
        NSLog(@"-- Account: %@", username);
        
        [twitter postStatusesFilterUserIDs:nil
                           keywordsToTrack:@[@"syria"]
                     locationBoundingBoxes:nil
                             stallWarnings:nil
                             progressBlock:^(NSDictionary *json, STTwitterStreamJSONType type) {
                                 
                                 weakSelf.textOverride.text = [json objectForKey:@"text"] ;
                                 if (type != STTwitterStreamJSONTypeTweet) {
                                     NSLog(@"Invalid tweet (class %@): %@", [json class], json);
                                     exit(1);
                                     return;
                                 }
                                 
                                 printf("-----------------------------------------------------------------\n");
                                 printf("-- user: @%s\n", [[json valueForKeyPath:@"user.screen_name"] cStringUsingEncoding:NSUTF8StringEncoding]);
                                 printf("-- text: %s\n", [[json objectForKey:@"text"] cStringUsingEncoding:NSUTF8StringEncoding]);
                                 
                             } errorBlock:^(NSError *error) {
                                 NSLog(@"Stream error: %@", error);
                                 exit(1);
                             }];
        
    } errorBlock:^(NSError *error) {
        NSLog(@"-- %@", [error localizedDescription]);
        exit(1);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)sendClicked:(id)sender {
    
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
