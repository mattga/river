//
//  AppDelegate.m
//  CollabStream
//
//  Created by Matthew Gardner on 1/22/14.
//  Copyright (c) 2014 mdg. All rights reserved.
//

#import "RiverAppDelegate.h"
#import "CocoaLibSpotify.h"
#import "RiverSetupViewController.h"
#import "RiverFrontViewController.h"
#import "RiverAuthAccount.h"
#import "GlobalVars.h"
#import "Track.h"
#import "User.h"

#include "appkey.c"

@implementation RiverAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
	[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
	
    // Register for push notifications
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
     (UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeNone)];
    
	for (NSString* family in [UIFont familyNames])
    {
        NSLog(@"%@", family);
        
        for (NSString* name in [UIFont fontNamesForFamilyName: family])
        {
            NSLog(@"  %@", name);
        }
    }
	
    // Initialize global variables
    GlobalVars *vars = [GlobalVars getVar];
    vars.hostedRoom = nil;
    vars.memberedRoom = nil;
	vars.playingIndex = -1;
    
    // Gets the bundle and saves the settings
    NSString *dest = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *docPath = [dest stringByAppendingPathComponent:@"riversettings.plist"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *bundlePath = [[NSBundle mainBundle] pathForResource:@"settings" ofType: @"plist"];
    NSLog(@"Docpath: %@", docPath);
    [fileManager copyItemAtPath:bundlePath toPath:docPath error:nil];
    NSLog(@"Settings file copied!");
    vars.settingsPath = docPath;
    vars.settingsDict = [[NSMutableDictionary alloc] initWithContentsOfFile:docPath];
    vars.username = [vars.settingsDict valueForKey:@"username"];
	User *user = [[User alloc] initWithID:vars.username];
	
	NSString *groupId = [vars.settingsDict valueForKey:@"memberedRoom"];
	if (groupId != nil && ![groupId isEqualToString:@""]) {
		vars.memberedRoom = [[Room alloc] initWithID:groupId];
		vars.memberedRoom.songs = [[NSMutableArray alloc] init];
		vars.memberedRoom.members = [[NSMutableArray alloc] init];
	}
	
	[[RiverAuthAccount sharedAuth] setCurrentUser:user];
	[[RiverAuthAccount sharedAuth] setUserId:vars.username];
    if(vars.username == nil || [vars.username isEqualToString:@""]) {
        NSLog(@"No username set...presenting username configuration view...");
        // Present River setup view if no username is set
        if([GlobalVars getVar].username == nil || [[GlobalVars getVar].username isEqualToString:@""]) {
            UIStoryboard *sb = [UIStoryboard storyboardWithName:@"RiverStoryboard_iPhone" bundle:nil];
            UIViewController *vc = [sb instantiateViewControllerWithIdentifier:@"RiverSetupViewController"];
            self.window.rootViewController = vc;
        }
    } else
        NSLog(@"Username: '%@'", vars.username);
    
	NSString *userAgent = [[[NSBundle mainBundle] infoDictionary] valueForKey:(__bridge NSString *)kCFBundleIdentifierKey];
	NSData *appKey = [NSData dataWithBytes:&g_appkey length:g_appkey_size];
    
    // Initialize spotify session
	NSError *error = nil;
	[SPSession initializeSharedSessionWithApplicationKey:appKey userAgent:userAgent loadingPolicy:SPAsyncLoadingManual error:&error];
	if (error != nil) {
		NSLog(@"CocoaLibSpotify init failed: %@", error);
		abort();
	} else {
        vars.playbackManager = [[RiverPlaybackManager alloc] initWithPlaybackSession:[SPSession sharedSession]];
        vars.sessionDelegate = [[RiverSessionDelegate alloc] init];
        [[SPSession sharedSession] setDelegate:vars.sessionDelegate];
        [[SPSession sharedSession] setPlaybackDelegate:vars.playbackManager];
    }

    // If push notifications not allowed, run background thread to keep refreshing song list and user(s) if part of a room
    dispatch_queue_t backgroundQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(backgroundQueue, ^{
        while (true) {
            if(vars.memberedRoom != nil) {
                NSLog(@"%04d Room sync:", self.syncId);
                
                NSString *url = [NSString stringWithFormat:@"http://partymix.herokuapp.com/getGroupSongs?groupId=%@", vars.memberedRoom.roomID];
                _request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
                [_request setHTTPMethod:@"GET"];
                
                _response = [NSURLConnection sendSynchronousRequest:_request returningResponse:nil error:nil];
                
                NSString *responseString = [[NSString alloc] initWithData:_response encoding:NSUTF8StringEncoding];
                NSLog(@"RiverConnection::connectionDidFinishLoading(), response:\n%@", responseString);
                
                NSError *error;
				_songs = [NSJSONSerialization JSONObjectWithData:_response options:kNilOptions error:&error];
				if(!error) {
					[vars.memberedRoom.songs removeAllObjects];
					vars.playingIndex = -1;
					for (unsigned int i = 0; i < [_songs count]; i++) {
						Track *s = [Track trackWithJSONObject:[_songs objectAtIndex:i]];
						if(s.isPlaying)
							vars.playingIndex = i;
						
						[vars.memberedRoom.songs addObject:s];
					}
				}
                
                url = [NSString stringWithFormat:@"http://partymix.herokuapp.com/getGroupMates?groupId=%@", vars.memberedRoom.roomID];
                _request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
                [_request setHTTPMethod:@"GET"];
                _response = [NSURLConnection sendSynchronousRequest:_request returningResponse:nil error:nil];
				
                responseString = [[NSString alloc] initWithData:_response encoding:NSUTF8StringEncoding];
                NSLog(@"RiverConnection::connectionDidFinishLoading(), response:\n%@", responseString);
				
                _members = [NSJSONSerialization JSONObjectWithData:_response options:kNilOptions error:&error];
//				if ([NSJSONSerialization isValidJSONObject:_response]) {
					if (!error) {
						[vars.memberedRoom.members removeAllObjects];
						for (NSDictionary *user in _members) {
							User *u = [User userWithJSONObject:user];
							if([vars.username isEqualToString:u.userId]) {
								vars.user = u;
								[[RiverAuthAccount sharedAuth] setCurrentUser:u];
							}
							NSLog(@"User name:%@ tokens:%d", u.userId, u.tokens);
							[vars.memberedRoom.members addObject:u];
						}
					} else
						NSLog(@"%@", error);
//				}
                
                self.syncId++;
            }
            usleep(10e6);
        }
    });
    
    return YES;
}

- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken
{
	NSLog(@"My token is: %@", deviceToken);
}

- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error
{
	NSLog(@"Failed to get token, error: %@", error);
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    __block UIBackgroundTaskIdentifier identifier = [application beginBackgroundTaskWithExpirationHandler:^{
        [[UIApplication sharedApplication] endBackgroundTask:identifier];
    }];
    
    [[SPSession sharedSession] flushCaches:^{
        if (identifier != UIBackgroundTaskInvalid)
            [[UIApplication sharedApplication] endBackgroundTask:identifier];
    }];
	
	[[GlobalVars getVar].settingsDict setValue:[GlobalVars getVar].memberedRoom.roomID forKey:@"memberedRoom"];
	[[GlobalVars getVar].settingsDict writeToFile:[GlobalVars getVar].settingsPath atomically:YES];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - SW Reveal Delegate

- (void)revealController:(SWRevealViewController *)revealController willMoveToPosition:(FrontViewPosition)position {
	if (position == 4) {
		[revealController.view endEditing:YES];
	} else if (position == 3) {
		if ([revealController.frontViewController isKindOfClass:[UINavigationController class]] &&
			[[(UINavigationController*)revealController.frontViewController topViewController] isKindOfClass:[RiverFrontViewController class]]) {
			[(RiverFrontViewController*)[(UINavigationController*)revealController.frontViewController topViewController] regainFirstResponder];
		}
	}
}

@end
