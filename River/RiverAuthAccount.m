//
//  RiverAuth.m
//  River
//
//  Created by Matthew Gardner on 4/24/14.
//  Copyright (c) 2014 mdg. All rights reserved.
//

#import "RiverAuthAccount.h"

@implementation RiverAuthAccount
static RiverAuthAccount *instance = nil;

+ (RiverAuthAccount*) sharedAuth {
    @synchronized(self) {
        if (instance == nil) {
            instance = [RiverAuthAccount alloc];
        }
        return instance;
    }
}

+ (void)authorizedRESTCall:(NSString*)endpoint withParams:(NSDictionary*)params callback:(void (^)(NSData *response, NSError* err))block {
	[self sharedAuth];
	
	// TEMPORARY AUTHORIZATION
	[self sharedAuth].authToken = @"0";
	
    NSString *url = nil;
	if ([endpoint isEqualToString:kSPLookup]) {
		url = [NSString stringWithFormat:@"%@://%@/%@/%@/?uri=%@", kSPWebProtocol, kSPWebHost, kSPLookup, kSPWebVersion, [params objectForKey:@"uri"]];
		NSString *extras = [params objectForKey:@"extras"];
		if (extras != nil)
			url = [url stringByAppendingString:[NSString stringWithFormat:@"&extras=%@", extras]];
	} else if ([endpoint isEqualToString:kSPSearchTracks]) {
		url = [NSString stringWithFormat:@"%@://%@/%@?q=%@", kSPWebProtocol, kSPWebHost, kSPSearchTracks, [params objectForKey:@"query"]];
	} else if ([endpoint isEqualToString:kSPSearchArtists]) {
		url = [NSString stringWithFormat:@"%@://%@/%@?q=%@", kSPWebProtocol, kSPWebHost, kSPSearchArtists, [params objectForKey:@"query"]];
	} else if ([endpoint isEqualToString:kSPSearchAlbums]) {
		url = [NSString stringWithFormat:@"%@://%@/%@?q=%@", kSPWebProtocol, kSPWebHost, kSPSearchAlbums, [params objectForKey:@"query"]];
	} else {
		url = [NSString stringWithFormat:@"%@://%@/%@?authToken=%@", kRiverWebProtocol, kRiverWebHost, endpoint, [self sharedAuth].authToken];
		for (NSString *key in params) {
			url = [url stringByAppendingString:[NSString stringWithFormat:@"&%@=%@", key, [params objectForKey:key]]];
		}
	}
    
	url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    if ([endpoint isEqualToString:kRiverRESTGetGroupMates] ||
        [endpoint isEqualToString:kRiverRESTGetGroupSongs] ||
        [endpoint isEqualToString:kRiverRESTGetUserPoints] ||
		[endpoint isEqualToString:kSPLookup] ||
		[endpoint isEqualToString:kSPSearchTracks] ||
		[endpoint isEqualToString:kSPSearchArtists] ||
		[endpoint isEqualToString:kSPSearchAlbums])
        [request setHTTPMethod:@"GET"];
    else
        [request setHTTPMethod:@"POST"];
    
    RiverConnection *connection = [[RiverConnection alloc] initWithRequest:request];
	[connection setCompletionBlock:block];
	
	[connection start];
}

+ (NSString *)fetchAlbumArtForURL:(NSString *)url {
	[self sharedAuth];
	
    NSString *post = @"https://embed.spotify.com/oembed/?url=";
    post = [post stringByAppendingString:url];
    
    //    NSLog(@"Posting query: %@", post);
    
    // Create the request.
    NSURLRequest *theRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:post]
                                                cachePolicy:NSURLRequestUseProtocolCachePolicy
                                            timeoutInterval:60.0];
    
    // Create the connection with the request and start loading the data.
    NSURLResponse* response = nil;
    NSData* data = [NSURLConnection sendSynchronousRequest:theRequest returningResponse:&response error:nil];
    
    NSString* dataAsString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    NSRange endRange = [dataAsString rangeOfString:@"\",\"provider_name"];
    NSInteger end = endRange.location;
    NSString *artURL = [dataAsString substringToIndex:end];
    
    NSRange startRange = [artURL rangeOfString:@"\"thumbnail_url\":\""];
    NSInteger start = startRange.location + startRange.length;
    artURL = [[artURL substringFromIndex:start] stringByReplacingOccurrencesOfString:@"\\/" withString:@"/"];
    
    return artURL;
}

@end
