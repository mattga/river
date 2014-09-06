//
//  Song.m
//  River
//
//  Created by Matthew Gardner on 3/9/14.
//  Copyright (c) 2014 mdg. All rights reserved.
//

#import "Song.h"

@implementation Song
@synthesize trackId, title, artist, contributers, tokens;
@synthesize year, length, isPlaying;

- (id)initWithId:(NSString*)ID {
    trackId = ID;
    return [self init];
}

- (void)readFromJSONObject:(NSDictionary *)dict {
	
	if (dict != nil && ![dict isEqual:[NSNull null]] && dict.count > 0) {
		
		self.trackId = [dict objectForKey:@"ProviderId"];
		self.title = [dict objectForKey:@"SongName"];
		self.artist = [dict objectForKey:@"SongArtist"];
		self.album = [dict objectForKey:@"SongAlbum"];
		self.albumArtURL = [dict objectForKey:@"AlbumArtURL"];
		self.length = [dict objectForKey:@"SongLength"];
		self.year = [dict objectForKey:@"SongYear"];
		self.tokens = [dict objectForKey:@"Tokens"];
		self.isPlaying = [[dict objectForKey:@"IsPlaying"] boolValue];
	}
	
}

- (id)JSONObjectFromObject {
	
	NSMutableDictionary *dict = [@{} mutableCopy];
	
	if (self.trackId != nil) {
		[dict setObject:self.trackId forKey:@"ProviderId"];
	}
	if (self.title != nil) {
		[dict setObject:self.title forKey:@"SongName"];
	}
	if (self.artist != nil) {
		[dict setObject:self.artist forKey:@"SongArist"];
	}
	if (self.album != nil) {
		[dict setObject:self.album forKey:@"SongAlbum"];
	}
	if (self.albumArtURL != nil) {
		[dict setObject:self.album forKey:@"AlbumArtURL"];
	}
	if (self.length != nil) {
		[dict setObject:self.length forKey:@"SongLength"];
	}
	if (self.year != nil) {
		[dict setObject:self.year forKey:@"SongYear"];
	}
	if (self.tokens != nil) {
		[dict setObject:self.tokens forKey:@"Tokens"];
	}
	[dict setObject:@((int)self.isPlaying) forKey:@"IsPlaying"];
	
	return dict;
}


@end
