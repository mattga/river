//
//  AppDelegate.m
//  CollabStream
//
//  Created by Matthew Gardner on 1/22/14.
//  Copyright (c) 2014 mdg. All rights reserved.
//

#import "RiverAppDelegate.h"
#import "CocoaLibSpotify.h"
#import "RiverFrontViewController.h"
#import "RiverAuthController.h"
#import "GlobalVars.h"
#import "Song.h"
#import "User.h"
#import "RiverSyncUtility.h"

#include "appkey.c"

@implementation RiverAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Register for push notifications
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
     (UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeNone)];
	
    // Initialize global variables
    GlobalVars *vars = [GlobalVars getVar];
    vars.memberedRoom = nil;
	vars.playingIndex = -1;
    
    // Get the bundle and saved settings
    NSString *dest = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *docPath = [dest stringByAppendingPathComponent:@"riversettings.plist"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *bundlePath = [[NSBundle mainBundle] pathForResource:@"settings" ofType: @"plist"];
    NSLog(@"Docpath: %@", docPath);
    [fileManager copyItemAtPath:bundlePath toPath:docPath error:nil];
    NSLog(@"Settings file copied!");
    vars.settingsPath = docPath;
    vars.settingsDict = [[NSMutableDictionary alloc] initWithContentsOfFile:docPath];
	
	NSString *groupId = [vars.settingsDict valueForKey:@"memberedRoom"];
	if (groupId != nil && ![groupId isEqualToString:@""]) {
		vars.memberedRoom = [[Room alloc] initWithName:groupId];
		vars.memberedRoom.songs = [[NSMutableArray alloc] init];
		vars.memberedRoom.members = [[NSMutableArray alloc] init];
	}
	
	// Get username
	NSString *username = [vars.settingsDict valueForKey:@"username"];
	if (username) {
	User *user = [[User alloc] initWithName:username];
		[[RiverAuthController sharedAuth] setCurrentUser:user];
	} else {
		UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"River_iPhone" bundle:[NSBundle mainBundle]];
		UIViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"AuthView"];
		UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:vc];
		self.window.rootViewController = nvc;
	}
	
    // Initialize spotify session
	NSString *userAgent = [[[NSBundle mainBundle] infoDictionary] valueForKey:(__bridge NSString *)kCFBundleIdentifierKey];
	NSData *appKey = [NSData dataWithBytes:&g_appkey length:g_appkey_size];
    
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

    // Run background thread to keep refreshing song list and user(s) if part of a room
	[[RiverSyncUtility sharedSyncing] startRoomSync];
    
	// Turn on remote control event delivery
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
	
    // Set itself as the first responder
    [self becomeFirstResponder];
	
    return YES;
}

- (void)remoteControlReceivedWithEvent:(UIEvent *)receivedEvent {
	
    if (receivedEvent.type == UIEventTypeRemoteControl) {
		GlobalVars *vars = [GlobalVars getVar];
		
        switch (receivedEvent.subtype) {
				
            case UIEventSubtypeRemoteControlPlay:
                if (!vars.playbackManager.isPlaying) {
					[vars.playbackManager setIsPlaying:YES];
				}
                break;
				
			case UIEventSubtypeRemoteControlPause:
				if (vars.playbackManager.isPlaying) {
					[vars.playbackManager setIsPlaying:NO];
				}
            case UIEventSubtypeRemoteControlPreviousTrack:
				
                break;
				
            case UIEventSubtypeRemoteControlNextTrack:
				if(vars.memberedRoom != nil && [vars.memberedRoom.songs count] > 0) {
					[vars.playbackManager skipSongWithCallback:nil];
				}
                break;
				
            default:
                break;
        }
    }
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
	
	[[GlobalVars getVar].settingsDict setValue:[GlobalVars getVar].memberedRoom.roomName forKey:@"memberedRoom"];
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
	
	// Turn off remote control event delivery
    [[UIApplication sharedApplication] endReceivingRemoteControlEvents];
	
    // Resign as first responder
    [self resignFirstResponder];
}

@end
