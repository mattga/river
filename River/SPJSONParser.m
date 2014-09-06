//
//  SPArtistsJSONParser.m
//  River
//
//  Created by Matthew Gardner on 7/6/14.
//  Copyright (c) 2014 mdg. All rights reserved.
//

#import "SPJSONParser.h"

@implementation SPJSONParser

+ (NSArray*)artistsFromSPJSON:(NSDictionary *)dict {
	
	if (dict) {
		NSDictionary *artists = [dict objectForKey:@"artists"];
		if (artists) {
			NSArray *items = [artists objectForKey:@"items"];
			return items;
		}
	}
	
	return nil;
}

+ (NSArray*)albumsFromSPJSON:(NSDictionary *)dict {
	
	if (dict) {
		NSDictionary *albums = [dict objectForKey:@"albums"];
		if (albums) {
			NSArray *items = [albums objectForKey:@"items"];
			return items;
		}
	}
	
	return nil;
}

+ (NSArray*)tracksFromSPJSON:(NSDictionary *)dict {
	
	if (dict) {
		NSDictionary *tracks = [dict objectForKey:@"tracks"];
		if (tracks) {
			NSArray *items = [tracks objectForKey:@"items"];
			return items;
		}
	}
	
	return nil;
}

+ (NSURL*)imageURLFromSPJSON:(NSDictionary *)dict withSize:(int)size {
	
	NSURL *url = nil;
	
	if (dict) {
		NSArray *images = [dict objectForKey:@"images"];
		if (images) {
			for (NSDictionary *image in images) {
				if (image) {
					int height = [[image objectForKey:@"height"] intValue];
					if (height > size*2) {
						url = [image objectForKey:@"url"];
					} else {
						break;
					}
				}
			}
		}
	}
	
	return url;
}

+ (NSString*)releaseYearFromSPJSON:(NSDictionary*)dict {

	NSString *year = nil;
	
	if (dict) {
		NSString *precision = [dict objectForKey:@"release_date_precision"];
		if ([precision isEqualToString:@"year"]) {
			year = [dict objectForKey:@"release_date"];
		} else {
			year = [[dict objectForKey:@"release_date"] substringToIndex:4];
		}
	}
	
	return year;
}


@end






