//
//  RiverSyncUtility.m
//  River
//
//  Created by Matthew Gardner on 7/20/14.
//  Copyright (c) 2014 mdg. All rights reserved.
//

#import "RiverSyncUtility.h"
#import "RiverAppDelegate.h"
#import "RiverAuthController.h"

@implementation RiverSyncUtility
static RiverSyncUtility *instance;

+ (RiverSyncUtility*)sharedSyncing {
	if (instance == nil)
    {
        instance = [[RiverSyncUtility alloc] init];
    }
    
    return instance;
}

- (void)startRoomSync {
	appDelegate = (RiverAppDelegate*)[UIApplication sharedApplication].delegate;
	vars = [GlobalVars getVar];
	
	syncSemaphore = dispatch_semaphore_create(0);
	dispatch_queue_t syncQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(syncQueue, ^{
        while (true) {
            if(vars.memberedRoom != nil) {
                NSLog(@"    RoomSync: %08d", appDelegate.syncId);
                [self fetchMemberedRoom];
            }
            dispatch_semaphore_wait(syncSemaphore, dispatch_time(DISPATCH_TIME_NOW, 8e9));
        }
    });
}

- (void)preemptRoomSync {
	dispatch_semaphore_signal(syncSemaphore);
}

- (void)fetchMemberedRoom {
	[RiverAuthController authorizedSyncRESTCall:kRiverWebApiRoom
									  action:nil
										verb:kRiverGet
										 _id:vars.memberedRoom.roomName
								  withParams:nil
									callback:^(NSDictionary *object, NSError *err) {
										
										if (!err) {
											
											@synchronized(vars.memberedRoom) {
												Room *room = vars.memberedRoom;
												
												if (room.statusCode.intValue == kRiverStatusOK) {
													[room.songs removeAllObjects];
													[room.members removeAllObjects];
													[room readFromJSONObject:object];
													
													for (unsigned int i = 0; i < [room.songs count]; i++) {
														if([[room.songs objectAtIndex:i] isPlaying]) {
															vars.playingIndex = i;
															break;
														}
														vars.playingIndex = -1;
													}
													for (User *user in room.members) {
														if([user.DisplayName isEqualToString:[RiverAuthController sharedAuth].currentUser.DisplayName]) {
															[RiverAuthController sharedAuth].currentUser.Tokens = user.Tokens;
															break;
														}
													}
													appDelegate.syncId++;
												}
											}
										}
									}];
}

@end
