//
//  FSTPrecisionCookingStateReachingMaxTimeViewController.m
//  
//
//  Created by John Nolan on 8/6/15.
//
//

#import "FSTPrecisionCookingStateReachingMaxTimeViewController.h"
#import "FSTPrecisionCookingStateReachingMaxTimeLayer.h"

@interface FSTPrecisionCookingStateReachingMaxTimeViewController ()

@end

@implementation FSTPrecisionCookingStateReachingMaxTimeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.progressView.progressLayer = [[FSTPrecisionCookingStateReachingMaxTimeLayer alloc] init];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)updatePercent {
    [super updatePercent];
    self.progressView.progressLayer.percent = [self calculatePercent:self.elapsedTime toTime:self.targetTime];
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
