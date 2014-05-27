//
//  RiverPlaybackManager.h
//  River
//
//  Created by Matthew Gardner on 3/8/14.
//  Copyright (c) 2014 mdg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RiverAuthAccount.h"
#import "CocoaLibSpotify.h"
#import "Track.h"
#import "Room.h"

@interface RiverPlaybackManager : SPPlaybackManager <SPSessionPlaybackDelegate> {
}

// Passed in data
@property (strong, nonatomic) Room *hostedRoom;

- (void)streamSong:(NSString *)songID withCallback:(void (^)(void))block;
- (void)skipSongWithCallback:(void (^)(void))block;

@end
