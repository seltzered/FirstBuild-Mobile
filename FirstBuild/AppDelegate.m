//
//  AppDelegate.m
//  FirstBuild-Mobile
//
//  Created by Myles Caley on 10/3/14.
//  Copyright (c) 2014 FirstBuild. All rights reserved.
//

#import "AppDelegate.h"
#import <Firebase/Firebase.h>
#import <RKMIMETypes.h>
#import <GooglePlus/GooglePlus.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    //setup restkit, by default the first object manager is the shared singleton accessible everywhere
    // initialize AFNetworking HTTPClient and setup shared object manager
    //move url to contstants
    NSURL *baseURL = [NSURL URLWithString:@"http://192.168.10.1:80"];
    //NSURL *baseURL = [NSURL URLWithString:@"http://127.0.0.1:3001"];
    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:baseURL];
    self.objectManager = [[RKObjectManager alloc] initWithHTTPClient:client];
    [[self.objectManager HTTPClient] setDefaultHeader:@"content-type" value:RKMIMETypeJSON];
    self.objectManager.requestSerializationMIMEType = RKMIMETypeJSON;
    
    DLog(@"%@", [UIFont fontNamesForFamilyName:@"PT Sans Narrow"]);
    
    if ([UIApplication instancesRespondToSelector:@selector(registerUserNotificationSettings:)]){
        [application registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound categories:nil]];
    }
    
   //[[NSUserDefaults standardUserDefaults]removeObjectForKey:@"ble-devices"];
    
    return [[FBSDKApplicationDelegate sharedInstance] application:application
                                    didFinishLaunchingWithOptions:launchOptions];
    
}


- (BOOL)application: (UIApplication *)application
            openURL: (NSURL *)url
  sourceApplication: (NSString *)sourceApplication
         annotation: (id)annotation {
    NSInteger facebookPrefixLocation =[[url absoluteString] rangeOfString:@"fb"].location;
    if (facebookPrefixLocation == NSNotFound)
    {
       return [GPPURLHandler handleURL:url sourceApplication:sourceApplication annotation:annotation];
    }
    else
    {
        return [[FBSDKApplicationDelegate sharedInstance] application:application
                                                              openURL:url
                                                    sourceApplication:sourceApplication
                                                           annotation:annotation];
    }

}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
     [FBSDKAppEvents activateApp];
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
