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
@property (strong, nonatomic) IBOutlet HRColorMapView *colorMapView;
@property (strong, nonatomic) IBOutlet HRColorPickerView *colorPickerView;
@property (strong, nonatomic) IBOutlet UIButton *buttonRecord;

@end

@implementation LedgeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.ledge.firebaseRef removeAllObservers];
    [self.ledge.firebaseRef observeEventType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
        id rawVal = snapshot.value;
        if (rawVal != [NSNull null])
        {
            NSDictionary* val = rawVal;
            uint32_t rgbValue = [(NSNumber *)[val objectForKey:@"rgbActual"] floatValue];
            uint8_t pixelR = (((rgbValue) & 0xFF0000)>>16);
            uint8_t pixelG = (((rgbValue) & 0xFF00)>>8);
            uint8_t pixelB = (((rgbValue) & 0xFF));
            self.colorPickerView.backgroundColor = [UIColor colorWithRed:pixelR/255.0 green:pixelG/255.0 blue:pixelB/255.0 alpha:1.0];
            
            uint32_t rgbRecordingValue = [(NSNumber *)[val objectForKey:@"rgbRecordingActual"] floatValue];
            UIButton* button = self.buttonRecord;
            if(rgbRecordingValue==1)
            {
                [button setTitle:@"Recording..." forState:UIControlStateNormal];
                [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            }
            else
            {
                [button setTitle:@"Record" forState:UIControlStateNormal];
                [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            }

        }
        NSLog(@"%@ -> %@", snapshot.key, snapshot.value);
    }];
}

- (NSNumber*)colorToWeb:(UIColor*)color
{
    //TODO: re-evaluate the conversion to NSString then to NSNumber
    //seems like there should be a better way
    NSNumber *webColor = nil;
    
    // This method only works for RGB colors
    if (color &&
        CGColorGetNumberOfComponents(color.CGColor) == 4)
    {
        // Get the red, green and blue components
        const CGFloat *components = CGColorGetComponents(color.CGColor);
        
        // These components range from 0.0 till 1.0 and need to be converted to 0 till 255
        CGFloat red, green, blue;
        red = roundf(components[0] * 255.0);
        green = roundf(components[1] * 255.0);
        blue = roundf(components[2] * 255.0);

        NSString* rgbHexString = [[NSString alloc]initWithFormat:@"0x%02x%02x%02x", (int)red, (int)green, (int)blue];
        NSScanner* pScanner = [NSScanner scannerWithString:rgbHexString];
        double value = 0;
        [pScanner scanHexDouble:&value];
        webColor = [NSNumber numberWithDouble:value];
    }
    
    return webColor;
}
- (IBAction)recordButtonClicked:(id)sender
{
    Firebase *ref = [self.ledge.firebaseRef childByAppendingPath:@"rgbRecording"];
    UIButton* button = (UIButton*)sender;
    if([button.titleLabel.text isEqualToString:@"Record"])
    {
        [ref setValue:[NSNumber numberWithInt:1]];
        
    }
    else
    {
        [ref setValue:[NSNumber numberWithInt:0]];
        
    }
}

- (IBAction)colorChanged:(id)sender {
    Firebase *ref = [self.ledge.firebaseRef childByAppendingPath:@"rgb"];
    HRColorMapView* view = (HRColorMapView*) sender;

    [ref setValue:[self colorToWeb:view.color]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
