//
//  RiverPlaybackManager.m
//  River
//
//  Created by Matthew Gardner on 3/8/14.
//  Copyright (c) 2014 mdg. All rights reserved.
//

#import "RiverPlaybackManager.h"
#import "RiverAlertUtility.h"
#import "GlobalVars.h"

@implementation RiverPlaybackManager
@synthesize  memberedRoom;

- (id) initWithPlaybackSession:(SPSession *)aSession {
    self = [super initWithPlaybackSession:aSession];
    if (self) {
        // Custom initialization
		memberedRoom = [GlobalVars getVar].memberedRoom;
    }
    return self;
}

- (void)skipSongWithCallback:(void (^)(void))block {
    // Play next song in room
	Song *endingSong;
	if ([GlobalVars getVar].playingIndex < memberedRoom.songs.count) {
		endingSong = [memberedRoom.songs objectAtIndex:[GlobalVars getVar].playingIndex];
		NSLog(@"Song with id %@ ended", endingSong.trackId);
		[memberedRoom.songs removeObjectAtIndex:[GlobalVars getVar].playingIndex];
    }
	
    Song *nextSong = nil;
    if([memberedRoom.songs count] > 0) {
        nextSong = [memberedRoom.songs objectAtIndex:0];
    }
	
	if (endingSong != nil) {
		[RiverAuthAccount authorizedRESTCall:kRiverRESTSong
									  action:nil
										verb:kRiverDelete
										 _id:[endingSong.trackId substringFromIndex:14]
								  withParams:@{@"RoomName" : memberedRoom.roomName}
									callback:^(NSDictionary *object, NSError *err) {
										
										if (!err) {
											RiverStatus *status = [[RiverStatus alloc] init];
											[status readFromJSONObject:object];
											
											if (status.statusCode.intValue == kRiverStatusOK) {
												if (nextSong != nil) {
													[RiverAuthAccount authorizedRESTCall:kRiverRESTSong
																				  action:kRiverActionPlaySong
																					verb:kRiverPost
																					 _id:[nextSong.trackId substringFromIndex:14]
																			  withParams:@{@"RoomName" : memberedRoom.roomName}
																				callback:^(id object, NSError *err) {
																					if (!err) {
																						RiverStatus *status = [[RiverStatus alloc] init];
																						[status readFromJSONObject:object];
																						
																						if (status.statusCode.intValue == kRiverStatusOK) {
																							[self streamSong:nextSong.trackId withCallback:block];
																						} else {
																							[RiverAlertUtility showOKAlertWithMessage:@"Error"
																															   onView:[[[UIApplication sharedApplication] keyWindow] subviews].lastObject];
																						}
																					}
																				}];
												} else { // No more songs
													[self setIsPlaying:NO];
													[GlobalVars getVar].playingIndex = -1;
												}
												if (block) {
													block();
												}
											}
										}
									}];
	}
}

- (void)sessionDidEndPlayback:(id<SPSessionPlaybackProvider>)aSession {
    // Play next song in room
	Song *endingSong;
	if ([GlobalVars getVar].playingIndex < memberedRoom.songs.count) {
		endingSong = [memberedRoom.songs objectAtIndex:[GlobalVars getVar].playingIndex];
		NSLog(@"Song with id %@ ended", endingSong.trackId);
		[memberedRoom.songs removeObjectAtIndex:[GlobalVars getVar].playingIndex];
	}
	
    Song *nextSong = nil;
    if([memberedRoom.songs count] > 0) {
        nextSong = [memberedRoom.songs objectAtIndex:0];
    }
	
	if (endingSong != nil) {
		[RiverAuthAccount authorizedRESTCall:kRiverRESTSong
									  action:nil
										verb:kRiverDelete
										 _id:[endingSong.trackId substringFromIndex:14]
								  withParams:@{@"RoomName" : memberedRoom.roomName}
									callback:^(NSDictionary *object, NSError *err) {
										
										if (!err) {
											RiverStatus *status = [[RiverStatus alloc] init];
											[status readFromJSONObject:object];
											
											if (status.statusCode.intValue == kRiverStatusOK) {
												if (nextSong != nil) {
													[RiverAuthAccount authorizedRESTCall:kRiverRESTSong
																				  action:kRiverActionPlaySong
																					verb:kRiverPost
																					 _id:[nextSong.trackId substringFromIndex:14]
																			  withParams:@{@"RoomName" : memberedRoom.roomName}
																				callback:^(id object, NSError *err) {
																					if (!err) {
																						RiverStatus *status = [[RiverStatus alloc] init];
																						[status readFromJSONObject:object];
																						
																						if (status.statusCode.intValue == kRiverStatusOK) {
																							[self streamSong:nextSong.trackId withCallback:nil];
																						} else {
																							[RiverAlertUtility showOKAlertWithMessage:@"Error"
																															   onView:[[[UIApplication sharedApplication] keyWindow] subviews].lastObject];
																						}
																					}
																				}];
												} else { // No more songs
													[self setIsPlaying:NO];
													[GlobalVars getVar].playingIndex = -1;
												}
											}
										}
									}];
	}
}

- (void)streamSong:(NSString *)songID withCallback:(void (^)(void))block {
    NSURL *trackURL = [NSURL URLWithString:songID];
	
    [[SPSession sharedSession] trackForURL:trackURL callback:^(SPTrack *track) {
        if (track != nil) {
            [SPAsyncLoading waitUntilLoaded:track timeout:kSPAsyncLoadingDefaultTimeout then:^(NSArray *tracks, NSArray *notLoadedTracks) {
                [[GlobalVars getVar].playbackManager playTrack:track callback:^(NSError *error) {
                    if (!error) {
						[RiverAuthAccount authorizedRESTCall:kRiverRESTSong
													  action:kRiverActionPlaySong
														verb:kRiverPost
														 _id:[[trackURL description] substringFromIndex:14]
												  withParams:@{@"RoomName" : memberedRoom.roomName}
													callback:^(id object, NSError *err) {
														
														if (!err) {
															RiverStatus *status = [[RiverStatus alloc] init];
															[status readFromJSONObject:object];
															
															if (status.statusCode.intValue == kRiverStatusOK) {
																NSLog(@"RiverPlaybackManager :: streamSong() - Streaming %@...", songID);
																
																for (int i = 0; i < memberedRoom.songs.count; i++) {
																	if ([[[memberedRoom.songs objectAtIndex:i] trackId] isEqualToString:songID]) {
																		[GlobalVars getVar].playingIndex = i;
																	}
																}
															} else {
																[RiverAlertUtility showOKAlertWithMessage:@"Error"
																								   onView:[[[UIApplication sharedApplication] keyWindow] subviews].lastObject];
															}
															if (block) {
																block();
															}
														}
													}];
                    } else {
						[RiverAlertUtility showOKAlertWithMessage:[NSString stringWithFormat:@"%@. %@", [error localizedDescription], @"It is most likely not available in your region. Skipping to next song..."]
														   onView:[[[UIApplication sharedApplication] keyWindow] subviews].lastObject];
						[self skipSongWithCallback:nil];
					}
                }];
            }];
        }
    }];
}

@end
