//
//  GlobalVars.h
//  River
//
//  Created by Matthew Gardner on 2/23/14.
//  Copyright (c) 2014 mdg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Room.h"
#import "RiverSessionDelegate.h"
#import "RiverPlaybackManager.h"
#import "User.h"
#import "Track.h"

@interface GlobalVars : NSObject

// User's rooms
@property (strong, nonatomic) Room *hostedRoom;
@property (strong, nonatomic) Room *memberedRoom;
@property (nonatomic) int playingIndex;

// User's settings
@property (strong, nonatomic) NSDictionary *settingsDict;
@property (strong, nonatomic) NSString *settingsPath;
@property (strong, nonatomic) NSString *username;
@property (strong, nonatomic) User *user;

// Streaming globals
@property (strong, nonatomic) NSDictionary *trackDetail;
@property (strong, nonatomic) NSDictionary *artistDetail;
@property (strong, nonatomic) NSDictionary *albumDetail;
@property (strong, nonatomic) RiverSessionDelegate *sessionDelegate;
@property (strong, nonatomic) RiverPlaybackManager *playbackManager;

// #import "GlobalVars.h" and use this in any source file to access the above global variables
+(GlobalVars*) getVar;

@end
