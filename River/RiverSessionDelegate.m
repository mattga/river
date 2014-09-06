//
//  RiverSessionsDelegate.m
//  River
//
//  Created by Matthew Gardner on 3/8/14.
//  Copyright (c) 2014 mdg. All rights reserved.
//

#import "RiverSessionDelegate.h"
#import "RiverLoadingUtility.h"
#import "RiverAlertUtility.h"

#define SP_LIBSPOTIFY_DEBUG_LOGGING 1

@implementation RiverSessionDelegate
@synthesize riverDelegate;

-(void)sessionDidLoginSuccessfully:(SPSession *)aSession {
    // Called after a successful login.
    
    [SPAsyncLoading waitUntilLoaded:aSession timeout:kSPAsyncLoadingDefaultTimeout then:^(NSArray *loadedItems, NSArray *notLoadedItems) {
        [SPAsyncLoading waitUntilLoaded:aSession.user timeout:kSPAsyncLoadingDefaultTimeout then:^(NSArray *loadedItems, NSArray *notLoadedItems) {
            
			id<UIApplicationDelegate> appDelegate = [UIApplication sharedApplication].delegate;
			UINavigationController* navVC = (UINavigationController*)appDelegate.window.rootViewController.childViewControllers.lastObject;
			[navVC popViewControllerAnimated:YES];
			
			if (self.riverDelegate != nil) {
				[self.riverDelegate spotifyAuthorizedForUser:[RiverAuthAccount sharedAuth].currentUser];
			}
			[[RiverLoadingUtility sharedLoader] stopLoading];
			
			[RiverAlertUtility showOKAlertWithMessage:@"Success! You can now stream music." onView:appDelegate.window.rootViewController.view];
        }];
    }];
}

-(void)session:(SPSession *)aSession didFailToLoginWithError:(NSError *)error {
    // Called after a failed login. SPLoginViewController will deal with this for us.
	
	[[RiverLoadingUtility sharedLoader] stopLoading];
	
	[RiverAlertUtility showOKAlertWithMessage:[error localizedDescription] onView:[[UIApplication sharedApplication] keyWindow].rootViewController.view];
}

-(void)sessionDidLogOut:(SPSession *)aSession; {
    // Called after a logout has been completed.
}

-(void)session:(SPSession *)aSession didGenerateLoginCredentials:(NSString *)credential forUserName:(NSString *)userName {
    
    // Called when login credentials are created. If you want to save user logins, uncomment the code below.
    
    /*
     NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
     NSMutableDictionary *storedCredentials = [[defaults valueForKey:@"SpotifyUsers"] mutableCopy];
     
     if (storedCredentials == nil)
     storedCredentials = [NSMutableDictionary dictionary];
     
     [storedCredentials setValue:credential forKey:userName];
     [defaults setValue:storedCredentials forKey:@"SpotifyUsers"];
     */
}

-(void)session:(SPSession *)aSession didEncounterNetworkError:(NSError *)error; {
    if (SP_LIBSPOTIFY_DEBUG_LOGGING != 0)
        NSLog(@"CocoaLS NETWORK ERROR: %@", error);
}

-(void)session:(SPSession *)aSession didLogMessage:(NSString *)aMessage; {
    if (SP_LIBSPOTIFY_DEBUG_LOGGING != 0)
        NSLog(@"CocoaLS DEBUG: %@", aMessage);
}

-(void)sessionDidChangeMetadata:(SPSession *)aSession; {
    // Called when metadata has been updated somewhere in the
    // CocoaLibSpotify object model. You don't normally need to do
    // anything here. KVO on the metadata you're interested in instead.
}

-(void)session:(SPSession *)aSession recievedMessageForUser:(NSString *)aMessage; {
    // Called when the Spotify service wants to relay a piece of information to the user.
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:aMessage
                                                    message:@"This message was sent to you from the Spotify service."
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}

@end
