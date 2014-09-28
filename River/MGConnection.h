//
//  MGConnection.h
//  ArtConsultant
//
//  Created by Matthew Gardner on 7/29/14.
//  Copyright (c) 2014 mgkb. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MGConnection : NSObject {
    NSURLConnection *internalConnection;
	NSData *syncResponseData;
    NSMutableData *responseDATA;
}

- (id)initWithRequest:(NSURLRequest *)req;

@property (nonatomic) BOOL notJson;
@property (nonatomic, copy) NSURLRequest *request;
@property (nonatomic, copy) void (^completionBlock)(id object, NSError *err);
@property (nonatomic, strong) NSOperationQueue *queue;

- (void)start;
- (void)startSynchronously;


@end
