//
//  RiverConnection.h
//  River
//
//  Created by Matthew Gardner on 4/25/14.
//  Copyright (c) 2014 mdg. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RiverConnection : NSObject <NSURLConnectionDelegate> {
    NSURLConnection *internalConnection;
    NSMutableData *responseDATA;
}

- (id)initWithRequest:(NSURLRequest *)req;

@property (nonatomic, copy) NSURLRequest *request;
@property (nonatomic, copy) void (^completionBlock)(NSData *response, NSError *err);
@property (nonatomic, strong) NSOperationQueue *queue;

- (void)start;


@end
