 //
//  RiverAuth.m
//  River
//
//  Created by Matthew Gardner on 4/24/14.
//  Copyright (c) 2014 mdg. All rights reserved.
//

#import "RiverAuthController.h"

@implementation RiverAuthController
static RiverAuthController *instance = nil;

+ (RiverAuthController*) sharedAuth {
    @synchronized(self) {
        if (instance == nil) {
            instance = [RiverAuthController alloc];
        }
        return instance;
    }
}

+ (void)authorizedRESTCall:(NSString*)endpoint action:(NSString*)action verb:(NSString*)verb _id:(NSString*)_id withParams:(NSDictionary*)params callback:(void (^)(id object, NSError* err))block {
	
	NSData *requestData = nil;
    NSString *url = nil;
	
	url = [NSString stringWithFormat:@"%@://%@/%@/%@", kRiverWebProtocol, kRiverWebHost, kRiverWebPath, endpoint];
	
	if (_id != nil) {
		url = [NSString stringWithFormat:@"%@/%@", url, _id];
	}
	
	if (action != nil) {
		url = [NSString stringWithFormat:@"%@/%@", url, action];
	}
	
	if (params != nil && params.count > 0) {
		if ([verb isEqualToString:kRiverWebApiVerbGet]) {
			bool firstDone = NO;
			
			for (NSString *key in [params keyEnumerator]) {
				if (!firstDone) {
					url = [NSString stringWithFormat:@"%@?%@=%@", url, key, [params objectForKey:key]];
					firstDone = YES;
				} else {
					url = [NSString stringWithFormat:@"%@&%@=%@", url, key, [params objectForKey:key]];
				}
			}
		} else {
			NSError* error = nil;
			id result = [NSJSONSerialization dataWithJSONObject:params
														options:kNilOptions
														  error:&error];
			
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
	if (requestData) {
		request.HTTPBody = requestData;
	}
    
    MGConnection *connection = [[MGConnection alloc] initWithRequest:request];
	[connection setCompletionBlock:block];
	
	[connection start];
}

+ (void)authorizedSyncRESTCall:(NSString*)endpoint action:(NSString*)action verb:(NSString*)verb _id:(NSString*)_id withParams:(NSDictionary*)params callback:(void (^)(id object, NSError* err))block {
	
	NSData *requestData = nil;
    NSString *url = nil;
	
	url = [NSString stringWithFormat:@"%@://%@/%@/%@", kRiverWebProtocol, kRiverWebHost, kRiverWebPath, endpoint];
	
	if (_id != nil) {
		url = [NSString stringWithFormat:@"%@/%@", url, _id];
	}
	
	if (action != nil) {
		url = [NSString stringWithFormat:@"%@/%@", url, action];
	}
	
	if (params != nil && params.count > 0) {
		if ([verb isEqualToString:kRiverWebApiVerbGet]) {
			bool firstDone = NO;
			
			for (NSString *key in [params keyEnumerator]) {
				if (!firstDone) {
					url = [NSString stringWithFormat:@"%@?%@=%@", url, key, [params objectForKey:key]];
					firstDone = YES;
				} else {
					url = [NSString stringWithFormat:@"%@&%@=%@", url, key, [params objectForKey:key]];
				}
			}
		} else {
			NSError* error = nil;
			id result = [NSJSONSerialization dataWithJSONObject:params
														options:kNilOptions
														  error:&error];
			
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
	if (requestData) {
		request.HTTPBody = requestData;
	}
    
    MGConnection *connection = [[MGConnection alloc] initWithRequest:request];
	[connection setCompletionBlock:block];
	
	[connection startSynchronously];
}

+ (void)authorizedSPQuery:(NSString *)endpoint action:(NSString *)action _id:(NSString *)_id verb:(NSString *)verb withParams:(NSDictionary *)params callback:(void (^)(id, NSError *))block {
	
	NSData *requestData = nil;
	NSString *url = nil;
	
	url = [NSString stringWithFormat:@"%@://%@/%@/%@", kSPWebProtocol, kSPWebHost, kSPWebVersion, endpoint];
	
	if (_id != nil) {
		url = [NSString stringWithFormat:@"%@/%@", url, _id];
	}
	
	if (action != nil) {
		url = [NSString stringWithFormat:@"%@/%@", url, action];
	}
	
	if (params != nil && params.count > 0) {
		if ([verb isEqualToString:kRiverWebApiVerbGet]) {
			bool firstDone = NO;
			
			for (NSString *key in [params keyEnumerator]) {
				if (!firstDone) {
					url = [NSString stringWithFormat:@"%@?%@=%@", url, key, [params objectForKey:key]];
					firstDone = YES;
				} else {
					url = [NSString stringWithFormat:@"%@&%@=%@", url, key, [params objectForKey:key]];
				}
			}
		} else {
			NSError* error = nil;
			id result = [NSJSONSerialization dataWithJSONObject:params
														options:kNilOptions
														  error:&error];
			
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
	if (requestData) {
		request.HTTPBody = requestData;
	}
	
	MGConnection *connection = [[MGConnection alloc] initWithRequest:request];
	[connection setCompletionBlock:block];
	
	[connection start];
}


@end
