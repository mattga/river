//
//  Room.m
//  River
//
//  Created by Matthew Gardner on 2/23/14.
//  Copyright (c) 2014 mdg. All rights reserved.
//

#import "Room.h"

@implementation Room
@synthesize roomID, songs, members, host, currentSong, currentTokens;

- (id)initWithID:(NSString*)ID {
    roomID = ID;
    songs = [[NSMutableArray alloc] init];
    members = [[NSMutableArray alloc] init];
    currentSong = 0;
    return [self init];
}

@end
