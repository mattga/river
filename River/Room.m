//
//  Room.m
//  River
//
//  Created by Matthew Gardner on 2/23/14.
//  Copyright (c) 2014 mdg. All rights reserved.
//

#import "Room.h"
#import "Song.h"
#import "User.h"

@implementation Room
@synthesize roomId, roomName, songs, members, hostId, currentSong, currentTokens;

- (id)initWithName:(NSString*)ID {
    roomName = ID;
    currentSong = 0;
    return [self init];
}

- (id)init {
	
	self = [super init];
	
	if (self) {
		songs = [[NSMutableArray alloc] init];
		members = [[NSMutableArray alloc] init];
	}
	
	return self;
}

- (void)readFromJSONObject:(NSDictionary*)dict {
	
	if (dict != nil && ![dict isEqual:[NSNull null]] && dict.count > 0) {
		
		self.roomId = [[dict objectForKey:@"RoomId"] integerValue];
		self.roomName= [dict objectForKey:@"RoomName"];
		self.hostId = [dict objectForKey:@"HostId"];
		
		NSArray *_songs = [dict objectForKey:@"Songs"];
		if (![_songs isEqual:[NSNull null]] && _songs != nil) {
			for (NSDictionary *song in _songs) {
				Song *s = [[Song alloc] init];
				[s readFromJSONObject:song];
				[songs addObject:s];
			}
		}
		
		NSArray *_users = [dict objectForKey:@"Users"];
		if (![_users isEqual:[NSNull null]] && _users != nil) {
			for (NSDictionary *user in _users) {
				User *u = [[User alloc] init];
				[u readFromJSONObject:[user objectForKey:@"User"]];
				u.Tokens = [[user objectForKey:@"Tokens"] integerValue];
				[members addObject:u];
			}
		}
		
		[super readFromJSONObject:dict];
	}
}

@end
