//
//  RiverConnection.m
//  River
//
//  Created by Matthew Gardner on 4/25/14.
//  Copyright (c) 2014 mdg. All rights reserved.
//

#import "RiverConnection.h"

static NSMutableArray *sharedConnectionList = nil;

@implementation RiverConnection
@synthesize request, completionBlock;

- (id)initWithRequest:(NSURLRequest *)req
{
    self = [super init];
    if(self) {
        [self setRequest:req];
    }
    return self;
}


- (void)start
{
    NSLog(@"RiverConnection::start(), request: %@ %@", request.HTTPMethod, request.URL.absoluteString);
    NSLog(@"RiverConnection::start(), requestData: %@", [[NSString alloc] initWithData:request.HTTPBody encoding:NSUTF8StringEncoding]);
    
    responseDATA = [[NSMutableData alloc] init];
    
    internalConnection = [[NSURLConnection alloc] initWithRequest:[self request]
                                                         delegate:self
                                                 startImmediately:YES];
    
    if(!sharedConnectionList)
        sharedConnectionList = [[NSMutableArray alloc] init];
    [sharedConnectionList addObject:self];
}

- (void)startSynchronously {
//    NSLog(@"RiverConnection::startSynchronously(), request: %@ %@", request.HTTPMethod, request.URL.absoluteString);
//    NSLog(@"RiverConnection::startSynchronously(), requestData: %@", [[NSString alloc] initWithData:request.HTTPBody encoding:NSUTF8StringEncoding]);
	
	NSError *error = nil;
	syncResponseData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&error];
	NSDictionary *d = nil;
	
	if (syncResponseData) {
		
		d = [NSJSONSerialization JSONObjectWithData:syncResponseData
														  options:0
															error:nil];
	}
	
	if([self completionBlock])
	{
		[self completionBlock](d, error);
	}
	
//	NSString *responseString = [[NSString alloc] initWithData:syncResponseData encoding:NSUTF8StringEncoding];
//    NSLog(@"RiverConnection::startSynchronously(), response \n%@", responseString);
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [responseDATA appendData:data];
}


- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
	NSString *responseString = [[NSString alloc] initWithData:responseDATA encoding:NSUTF8StringEncoding];
    NSLog(@"RiverConnection::finishedLoading(), response \n%@", responseString);
	id jsonObject = nil;
	
    if (responseDATA) {
		jsonObject = [NSJSONSerialization JSONObjectWithData:responseDATA
													 options:0
													   error:nil];
	}
	
    if([self completionBlock])
	{
		[self completionBlock](jsonObject, nil);
	}
	
    [sharedConnectionList removeObject:self];
}


- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    if([self completionBlock])
        [self completionBlock](nil, error);
    
    [sharedConnectionList removeObject:self];
}

@end
