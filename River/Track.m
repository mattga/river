//
//  Song.m
//  River
//
//  Created by Matthew Gardner on 3/9/14.
//  Copyright (c) 2014 mdg. All rights reserved.
//

#import "Track.h"

@implementation Track
@synthesize trackId, title, artist, contributers, currentTokens;
@synthesize isPlaying;

- (id)initWithId:(NSString*)ID {
    trackId = ID;
    return [self init];
}

+ (Track *)trackWithJSONObject:(NSDictionary *)dict {
    Track *s = [[Track alloc] init];
    
    s.trackId = [dict objectForKey:@"id"];
    s.title = [dict objectForKey:@"title"];
    s.artist = [dict objectForKey:@"artist"];
    s.isPlaying = [[dict objectForKey:@"playing"] boolValue];
    s.currentTokens = [[dict objectForKey:@"points"] integerValue];

    return s;
}

+ (Track *)trackWithXMLObject:(NSDictionary *)dict {
    Track *s = [[Track alloc] init];
    
    s.trackId = [dict objectForKey:@"track_href"];
    s.title = [dict objectForKey:@"track_name"];
    s.artist = [dict objectForKey:@"artist_name"];
	s.album = [dict objectForKey:@"album_name"];
	s.released = [dict objectForKey:@"album_released"];
	s.length = [[dict objectForKey:@"length"] doubleValue];
	
    return s;
}


@end
