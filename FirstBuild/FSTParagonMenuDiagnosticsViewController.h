//
//  FSTParagonMenuDiagnosticsViewController.h
//  FirstBuild
//
//  Created by Myles Caley on 11/9/15.
//  Copyright © 2015 FirstBuild. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FSTParagon.h"

@interface FSTParagonMenuDiagnosticsViewController : UIViewController<FSTParagonDelegate>

@property (weak, nonatomic) FSTParagon* currentParagon;

@property (strong, nonatomic) IBOutlet UILabel *temp;
@property (strong, nonatomic) IBOutlet UILabel *power;
@property (strong, nonatomic) IBOutlet UILabel *stage;
@property (strong, nonatomic) IBOutlet UILabel *state;

@end
