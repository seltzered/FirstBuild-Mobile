//
//  FBTAuthenticationViewController.m
//  MobiUs
//
//  Created by Myles Caley on 10/15/14.
//  Copyright (c) 2014 FirstBuild. All rights reserved.
//

#import "FBTAuthenticationViewController.h"
#import <Firebase/Firebase.h>
#import <SSKeychain.h>
#import "FirebaseShared.h"
#import "FBTUser.h"
#import <GoogleOpenSource/GoogleOpenSource.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>

@interface FBTAuthenticationViewController ()

@end

@implementation FBTAuthenticationViewController

#pragma mark - GPPSignInDelegate

- (void)initGoogleAuth
{
    GPPSignIn *signIn = [GPPSignIn sharedInstance];
    signIn.shouldFetchGoogleUserEmail = YES;
    signIn.clientID = @"523108828656-nuardro4852mn2g66a8mg9ukj2ld4tf6.apps.googleusercontent.com";;
    signIn.scopes = @[ @"profile" ];
    signIn.delegate = self;
   
    [signIn trySilentAuthentication];
}

- (void)finishedWithAuth:(GTMOAuth2Authentication *)auth error:(NSError *)error
{
    
    Firebase *authRef = [[FirebaseShared sharedInstance] firebaseRootReference];

    if (!error)
    {
         NSLog(@"logged in with google? %@", [GPPSignIn sharedInstance].authentication);
        [authRef authWithOAuthProvider:@"google" token:auth.accessToken
               withCompletionBlock:^(NSError *error, FAuthData *authData) {
                   if (error) {
                       UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Login Failed" message:@"Google+ Login Failed." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
                       [alert show];
                   } else {
                       FBTUser* user = [FBTUser sharedInstance];
                       user.token = authData.token;
                       [self loadMainAppWithUidString:authData.uid];
                   }
               }];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Login Failed" message:@"Google+ Authentication Failed." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
    }
}

- (void)didDisconnectWithError:(NSError *)error
{
    
}

#pragma mark FBLoginViewDelegate


-(void)loginButton:(FBSDKLoginButton *)loginButton didCompleteWithResult:(FBSDKLoginManagerLoginResult *)result error:(NSError *)error
{
    NSLog(@"Facebook Logged in loginButton");
    if (!error)
    {
        [self firebaseLoginWithFacebookAccessToken];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Login Failed" message:@"Facebook Authentication Failed." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];

    }
}

-(void)loginButtonDidLogOut:(FBSDKLoginButton *)loginButton
{
    NSLog(@"Facebook logged out from main auth screen");
}

-(void)firebaseLoginWithFacebookAccessToken
{
    Firebase *authRef = [[FirebaseShared sharedInstance] firebaseRootReference];
    NSString *fbAccessToken = [[FBSDKAccessToken currentAccessToken] tokenString];
    [authRef authWithOAuthProvider:@"facebook" token:fbAccessToken
               withCompletionBlock:^(NSError *error, FAuthData *authData) {
                   if (error) {
                       UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Login Failed" message:@"Facebook Login Failed." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
                       [alert show];
                   } else {
                       FBTUser* user = [FBTUser sharedInstance];
                       user.token = authData.token;
                       [self loadMainAppWithUidString:authData.uid];
                   }
               }];
}
//-(void)loginViewFetchedUserInfo:(FBLoginView *)loginView user:(id<FBGraphUser>)user
//{
//}
//
//-(void)loginViewShowingLoggedInUser:(FBLoginView *)loginView
//{
//    Firebase *authRef = [[FirebaseShared sharedInstance] firebaseRootReference];
//    NSString *fbAccessToken = [FBSession activeSession].accessTokenData.accessToken;
//    [authRef authWithOAuthProvider:@"facebook" token:fbAccessToken
//               withCompletionBlock:^(NSError *error, FAuthData *authData) {
//                   if (error) {
//                       UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Login Failed" message:@"Facebook Login Failed." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
//                       [alert show];
//                   } else {
//                       FBTUser* user = [FBTUser sharedInstance];
//                       user.token = authData.token;
//                       [self loadMainAppWithUidString:authData.uid];
//                   }
//               }];
//}
//
//-(void)loginView:(FBLoginView *)loginView handleError:(NSError *)error
//{
//    // Handle possible errors that can occur during login
//    NSString *alertMessage, *alertTitle;
//    
//    // If the user should perform an action outside of you app to recover,
//    // the SDK will provide a message for the user, you just need to surface it.
//    // This conveniently handles cases like Facebook password change or unverified Facebook accounts.
//    if ([FBErrorUtility shouldNotifyUserForError:error]) {
//        alertTitle = @"Facebook error";
//        alertMessage = [FBErrorUtility userMessageForError:error];
//        
//        // This code will handle session closures that happen outside of the app
//        // You can take a look at our error handling guide to know more about it
//        // https://developers.facebook.com/docs/ios/errors
//    } else if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryAuthenticationReopenSession) {
//        alertTitle = @"Session Error";
//        alertMessage = @"Your current session is no longer valid. Please log in again.";
//        
//        // If the user has cancelled a login, we will do nothing.
//        // You can also choose to show the user a message if cancelling login will result in
//        // the user not being able to complete a task they had initiated in your app
//        // (like accessing FB-stored information or posting to Facebook)
//    } else if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryUserCancelled) {
//        NSLog(@"user cancelled login");
//        
//        // For simplicity, this sample handles other errors with a generic message
//        // You can checkout our error handling guide for more detailed information
//        // https://developers.facebook.com/docs/ios/errors
//    } else {
//        alertTitle  = @"Something went wrong";
//        alertMessage = @"Please try again later.";
//        NSLog(@"Unexpected error:%@", error);
//    }
//    
//    if (alertMessage) {
//        [[[UIAlertView alloc] initWithTitle:alertTitle
//                                    message:alertMessage
//                                   delegate:nil
//                          cancelButtonTitle:@"OK"
//                          otherButtonTitles:nil] show];
//    }
//}


#pragma mark UIViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.facebookLoginButton.delegate = self;
    [self initGoogleAuth];
    if ([FBSDKAccessToken currentAccessToken]) {
        NSLog(@"Facebook already logged in");
        [self firebaseLoginWithFacebookAccessToken];
    }
}

- (void) loadMainAppWithUidString: (NSString*) uid
{
    FBTUser *user = [FBTUser sharedInstance];
    Firebase *authRef = [[FirebaseShared sharedInstance] firebaseRootReference];
    NSString *dateString = [NSDateFormatter localizedStringFromDate:[NSDate date]
                                                          dateStyle:NSDateFormatterShortStyle
                                                          timeStyle:NSDateFormatterFullStyle];
    user.rootContainer = [@"/users/" stringByAppendingString:uid];
    [[FirebaseShared sharedInstance] setUserBaseReference:[authRef childByAppendingPath:user.rootContainer]];
    
    Firebase *userConnectedRef = [[[FirebaseShared sharedInstance] userBaseReference] childByAppendingPath:@"lastConnected"];
    Firebase *userDisconnectedRef = [[[FirebaseShared sharedInstance] userBaseReference] childByAppendingPath:@"disconnected"];
    [userConnectedRef setValue:dateString];
    [userDisconnectedRef setValue:@NO];
    [userDisconnectedRef onDisconnectSetValue:@YES];
    
    [self.presentingViewController dismissViewControllerAnimated:NO completion:nil];
    [self performSegueWithIdentifier:@"main" sender:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark FSTApplicationMenuDelegate
//TODO: implement - currently in MenuViewController
- (void)menuLogoutSelected
{
    
}


#pragma mark FirebaseSimpleLogin

//TODO: Firebase Simple Login authentication is currently disabled. e-mail is not validated and requires
//a secondary server to send verification e-mails. This code needs fixed as well.

//- (void)initFirebaseAuthentication
//{
//    NSArray *accounts;
//
//    [SSKeychain setAccessibilityType:kSecAttrAccessibleWhenUnlocked];
//    accounts = [SSKeychain accountsForService:@"firebase"];
//
//    if (accounts)
//    {
//        NSString* account = [accounts[0] objectForKey:@"acct"];
//        NSString* password = [SSKeychain passwordForService:@"firebase" account:account];
//
//        //if we have an account already stored in the keychain but this is the first launch
//        //then lets erase all
//        if (![[NSUserDefaults standardUserDefaults] objectForKey:@"isFirstLaunch"])
//        {
//            [accounts enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
//                [SSKeychain deletePasswordForService:@"firebase" account:obj];
//            }];
//
//            [[NSUserDefaults standardUserDefaults] setValue:@"true" forKey:@"isFirstLaunch"];
//            [[NSUserDefaults standardUserDefaults] synchronize];
//        }
//        else
//        {
//            self.usernameTextField.text = @"hi@hi.com";
//            self.passwordTextField.text = @"hi";
//        }
//    }
//}

//
//- (IBAction)registerButtonPressed:(id)sender;
//{
//    [self.usernameTextField resignFirstResponder];
//    [self.passwordTextField resignFirstResponder];
//    [self.loginActivityIndicator startAnimating];
//
//    Firebase *authRef = [[FirebaseShared sharedInstance] firebaseRootReference];
//
//    [authRef createUser:self.usernameTextField.text  password:self.passwordTextField.text withCompletionBlock:^(NSError *error) {
//        if (error != nil) {
//            // There was an error creating the account
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Registration Failed!" message:@"Please check your email and password, and try again." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
//            [alert show];
//            [self.loginActivityIndicator stopAnimating];
//        }
//        else
//        {
//            [self loginWithUsernameAndLoadMainApp:self.usernameTextField.text havingPassword:self.passwordTextField.text];
//        }
//    }];
//}

//- (void) loginWithUsernameAndLoadMainApp:(NSString*)username havingPassword:(NSString*)password
//{
//    
//    // TODO: use setValue with completion block for the creation of the new user
//    // TODO: better error checking
//    Firebase *authRef = [[FirebaseShared sharedInstance] firebaseRootReference];
//    FBTUser *user = [FBTUser sharedInstance];
//    
//    [authRef authUser:username  password:password withCompletionBlock:^(NSError *error,  FAuthData *authData) {
//        if (error == nil)
//        {
//            user.rootContainer = [@"/users/" stringByAppendingString:authData.uid];
//            [[FirebaseShared sharedInstance] setUserBaseReference:[authRef childByAppendingPath:user.rootContainer]];
//            
//            user.token = authData.token;
//            user.email = username;
//            
//            Firebase *userConnectedRef = [[[FirebaseShared sharedInstance] userBaseReference] childByAppendingPath:@"connected"];
//            [userConnectedRef setValue:@YES];
//            [userConnectedRef onDisconnectRemoveValue];
//            
//            [SSKeychain setPassword:password forService:@"firebase" account:username];
//            [self.presentingViewController dismissViewControllerAnimated:NO completion:nil];
//            [self performSegueWithIdentifier:@"main" sender:self];
//            
//        }
//        else
//        {
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Login Failed!" message:@"Please check your email and password, and try again." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
//            [alert show];
//        }
//        [self.loginActivityIndicator stopAnimating];
//    }];
//    
//}


@end
