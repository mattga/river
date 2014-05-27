//
//  RiverPlaybackManager.m
//  River
//
//  Created by Matthew Gardner on 3/8/14.
//  Copyright (c) 2014 mdg. All rights reserved.
//

#import "RiverPlaybackManager.h"
#import "GlobalVars.h"

@implementation RiverPlaybackManager
@synthesize  hostedRoom;

- (id) initWithPlaybackSession:(SPSession *)aSession {
    self = [super initWithPlaybackSession:aSession];
    if (self) {
        // Custom initialization
		hostedRoom = [GlobalVars getVar].memberedRoom;
    }
    return self;
}

- (void)skipSongWithCallback:(void (^)(void))block {
    // Play next song in room
	Track *endingSong = [hostedRoom.songs objectAtIndex:[GlobalVars getVar].playingIndex];
    NSLog(@"Song with id %@ ended", endingSong.trackId);
    
    Track *nextSong = nil;
    if([hostedRoom.songs count] > 0) {
        nextSong = [hostedRoom.songs objectAtIndex:0];
		if (nextSong.isPlaying) {
			if ([hostedRoom.songs count] > 1) {
				nextSong = [hostedRoom.songs objectAtIndex:1];
			} else {
				nextSong = nil;
			}
		}
    }
	
	[RiverAuthAccount authorizedRESTCall:kRiverRESTDeleteSong withParams:@{@"groupId" : hostedRoom.roomID, @"songId" : endingSong.trackId} callback:^(NSData *response, NSError *err) {
		if (!err) {
			if (nextSong != nil) {
				[self streamSong:nextSong.trackId withCallback:block];
			} else {
				[self setIsPlaying:NO];
				block();
			}
		}
	}];
}

- (void)sessionDidEndPlayback:(id<SPSessionPlaybackProvider>)aSession {
    // Play next song in room
	Track *endingSong = [hostedRoom.songs objectAtIndex:[GlobalVars getVar].playingIndex];
    NSLog(@"Song with id %@ ended", endingSong.trackId);
    
    Track *nextSong = nil;
    if([hostedRoom.songs count] > 0) {
        nextSong = [hostedRoom.songs objectAtIndex:0];
		if (nextSong.isPlaying) {
			if ([hostedRoom.songs count] > 1) {
				nextSong = [hostedRoom.songs objectAtIndex:1];
			} else {
				nextSong = nil;
			}
		}
    }
	
	[RiverAuthAccount authorizedRESTCall:kRiverRESTDeleteSong withParams:@{@"groupId" : hostedRoom.roomID, @"songId" : endingSong.trackId} callback:^(NSData *response, NSError *err) {
		if (!err)
			if (nextSong != nil) {
				[self streamSong:nextSong.trackId withCallback:nil];
		}
	}];
}

- (void)streamSong:(NSString *)songID withCallback:(void (^)(void))block {
    NSURL *trackURL = [NSURL URLWithString:songID];
	
    [[SPSession sharedSession] trackForURL:trackURL callback:^(SPTrack *track) {
        if (track != nil) {
            [SPAsyncLoading waitUntilLoaded:track timeout:kSPAsyncLoadingDefaultTimeout then:^(NSArray *tracks, NSArray *notLoadedTracks) {
                [[GlobalVars getVar].playbackManager playTrack:track callback:^(NSError *error) {
                    if (!error) {
						[RiverAuthAccount authorizedRESTCall:kRiverRESTPlay withParams:@{@"groupId" : hostedRoom.roomID, @"songId" : trackURL} callback:^(NSData *response, NSError *err) {
							if (!err) {
								NSLog(@"Streaming song with id %@...", songID);
								
								if (block) {
									block();
								}
							}
						}];
                    } else {
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Cannot Play Track"
                                                                        message:[error localizedDescription]
                                                                       delegate:nil
                                                              cancelButtonTitle:@"OK"
                                                              otherButtonTitles:nil];
                        [alert show];
					}
                }];
            }];
        }
    }];
}

@end
