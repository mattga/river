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
    NSLog(@"RiverConnection::start(), request: %@", request.URL.absoluteString);
    
    responseDATA = [[NSMutableData alloc] init];
    
    internalConnection = [[NSURLConnection alloc] initWithRequest:[self request]
                                                         delegate:self
                                                 startImmediately:YES];
    
    if(!sharedConnectionList)
        sharedConnectionList = [[NSMutableArray alloc] init];
    [sharedConnectionList addObject:self];
}


- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [responseDATA appendData:data];
}


- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
	NSString *responseString = [[NSString alloc] initWithData:responseDATA encoding:NSUTF8StringEncoding];
    NSLog(@"RiverConnection::finishedLoading(), response \n%@", responseString);
	
    if([self completionBlock])
    {
        [self completionBlock](responseDATA, nil);
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
