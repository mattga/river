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

+ (void)authorizedRESTCall:(NSString*)endpoint action:(NSString*)action verb:(NSString*)verb _id:(NSString*)_id withParams:(NSDictionary*)params callback:(void (^)(id object, NSError* err))block {
	
	[self sharedAuth].authToken = @"0";
	
	NSData *requestData = nil;
    NSString *url = nil;
	if ([endpoint isEqualToString:kSPRESTSearch] ||
		[endpoint isEqualToString:kSPRESTAlbums] ||
		[endpoint isEqualToString:kSPRESTArtists]) {
		url = [NSString stringWithFormat:@"%@://%@/%@/%@", kSPWebProtocol, kSPWebHost, kSPWebVersion, endpoint];
		
		if (_id != nil) {
			url = [NSString stringWithFormat:@"%@/%@", url, _id];
		}
		
		if (action != nil) {
			url = [NSString stringWithFormat:@"%@/%@", url, action];
		}
		
		bool first = YES;
		for (NSString *key in params.allKeys) {
			if (first) {
				url = [NSString stringWithFormat:@"%@?%@=%@", url, key, [params objectForKey:key]];
				first = NO;
			} else {
				url = [NSString stringWithFormat:@"%@&%@=%@", url, key, [params objectForKey:key]];
			}
		}
	} else {
		url = [NSString stringWithFormat:@"%@://%@/%@/%@/%@", kRiverWebProtocol, kRiverWebHost, kRiverWebPath, kRiverWebVersion, endpoint];
		
		if (action != nil) {
			url = [NSString stringWithFormat:@"%@/%@", url, action];
		}
		
		if (_id != nil) {
			url = [NSString stringWithFormat:@"%@/%@", url, _id];
		}
		
		if (params != nil) {
			NSError* error = nil;
			id result = [NSJSONSerialization dataWithJSONObject:params
														options:kNilOptions error:&error];
			
			NSString* jsonString = @"";
			if (!error)
			{
				jsonString = [[NSString alloc] initWithData:result
												   encoding:NSUTF8StringEncoding];
				
				requestData = [NSData dataWithBytes:[jsonString UTF8String] length:[jsonString length]];
			}
		}
	}
    
	url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
	[request setHTTPMethod:verb];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
	
	if (requestData != nil) {
		request.HTTPBody = requestData;
	}
    
    RiverConnection *connection = [[RiverConnection alloc] initWithRequest:request];
	[connection setCompletionBlock:block];
	
	[connection start];
}

+ (void)authorizedSyncRESTCall:(NSString*)endpoint action:(NSString*)action verb:(NSString*)verb _id:(NSString*)_id withParams:(NSDictionary*)params callback:(void (^)(id object, NSError* err))block {

	[self sharedAuth].authToken = @"0";
	
	NSData *requestData = nil;
    NSString *url = nil;
	if ([endpoint isEqualToString:kSPRESTSearch] ||
		[endpoint isEqualToString:kSPRESTAlbums] ||
		[endpoint isEqualToString:kSPRESTArtists]) {
		url = [NSString stringWithFormat:@"%@://%@/%@/%@", kSPWebProtocol, kSPWebHost, kSPWebVersion, endpoint];
		
		if (_id != nil) {
			url = [NSString stringWithFormat:@"%@/%@", url, _id];
		}
		
		if (action != nil) {
			url = [NSString stringWithFormat:@"%@/%@", url, action];
		}
		
		bool first = YES;
		for (NSString *key in params.allKeys) {
			if (first) {
				url = [NSString stringWithFormat:@"%@?%@=%@", url, key, [params objectForKey:key]];
				first = NO;
			} else {
				url = [NSString stringWithFormat:@"%@&%@=%@", url, key, [params objectForKey:key]];
			}
		}
	} else {
		url = [NSString stringWithFormat:@"%@://%@/%@/%@/%@", kRiverWebProtocol, kRiverWebHost, kRiverWebPath, kRiverWebVersion, endpoint];
		
		if (action != nil) {
			url = [NSString stringWithFormat:@"%@/%@", url, action];
		}
		
		if (_id != nil) {
			url = [NSString stringWithFormat:@"%@/%@", url, _id];
		}
		
		if (params != nil) {
			NSError* error = nil;
			id result = [NSJSONSerialization dataWithJSONObject:params
														options:kNilOptions error:&error];
			
			NSString* jsonString = @"";
			if (!error)
			{
				jsonString = [[NSString alloc] initWithData:result
												   encoding:NSUTF8StringEncoding];
				
				requestData = [NSData dataWithBytes:[jsonString UTF8String] length:[jsonString length]];
			}
		}
	}
    
	url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
	[request setHTTPMethod:verb];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
	
	if (requestData != nil) {
		request.HTTPBody = requestData;
	}
    
    RiverConnection *connection = [[RiverConnection alloc] initWithRequest:request];
	[connection setCompletionBlock:block];
	
	[connection startSynchronously];
}


@end
