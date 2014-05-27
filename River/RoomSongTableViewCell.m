//
//  RoomViewPlaylistTableViewCell.m
//  River
//
//  Created by Safeer Mohiuddin on 3/11/14.
//  Copyright (c) 2014 mdg. All rights reserved.
//

#import "RoomSongTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

@implementation RoomSongTableViewCell

#pragma mark -
#pragma mark Self - Public

- (void)setSong:(Track*)song {
    
    if ( _song != song ) {
        _song = song;
    }
    
    _songLabel.text = _song.title;
    _artistLabel.text = _song.artist;
    _tokensLabel.text = [NSString stringWithFormat:@"%d", _song.currentTokens];
    NSString *albumURL = [self fetchAlbumArtForURL:_song.trackId];
    [_albumArtImageView setImageWithURL:[NSURL URLWithString:albumURL]];
}

- (NSString *)fetchAlbumArtForURL:(NSString *)url {
    NSString *post = @"https://embed.spotify.com/oembed/?url=";
    post = [post stringByAppendingString:url];
    
//    NSLog(@"Fetching album art: %@", post);
    
    // Create the request.
    NSURLRequest *theRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:post]
                                                cachePolicy:NSURLRequestUseProtocolCachePolicy
                                            timeoutInterval:60.0];
    
    // Create the connection with the request and start loading the data.
    NSURLResponse* response = nil;
    NSData* data = [NSURLConnection sendSynchronousRequest:theRequest returningResponse:&response error:nil];
    
    NSString* dataAsString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    NSRange endRange = [dataAsString rangeOfString:@"\",\"provider_name"];
    
	if (endRange.location < dataAsString.length) {
		NSInteger end = endRange.location;
		NSString *artURL = [dataAsString substringToIndex:end];
		
		NSRange startRange = [artURL rangeOfString:@"\"thumbnail_url\":\""];
		if (startRange.location < dataAsString.length) {
			NSInteger start = startRange.location + startRange.length;
			artURL = [[artURL substringFromIndex:start] stringByReplacingOccurrencesOfString:@"\\/" withString:@"/"];
			
			return artURL;
		}
	}
	
	return nil;
}


@end
