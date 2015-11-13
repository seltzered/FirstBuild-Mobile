//
//  FBTAuthenticationViewController.h
//  FirstBuild-Mobile
//
//  Created by Myles Caley on 10/15/14.
//  Copyright (c) 2014 FirstBuild. All rights reserved.
//

#ifdef CHILLHUB

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import <GooglePlus/GooglePlus.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>

@class GPPSignInButton;


@interface FBTAuthenticationViewController : UIViewController <GPPSignInDelegate,FBSDKLoginButtonDelegate>

@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *loginActivityIndicator;
@property (strong, nonatomic) MPMoviePlayerController *backgroundMovie;
@property (strong, nonatomic) IBOutlet UIControl *controlView;
@property (strong, nonatomic) IBOutlet GPPSignInButton *googleLoginView;
@property (strong, nonatomic) IBOutlet FBSDKLoginButton *facebookLoginButton;

#endif

@end
