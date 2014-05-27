//
//  RiverAuth.h
//  River
//
//  Created by Matthew Gardner on 4/24/14.
//  Copyright (c) 2014 mdg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RiverConnection.h"
#import "Constants.h"
#import "User.h"

@interface RiverAuthAccount : NSObject

@property (nonatomic, strong) NSString *deviceToken;
@property (nonatomic, strong) NSString *userId;
// TODO: Authentication with REST calls
@property (nonatomic, strong) NSString *authToken;
@property (nonatomic, strong) User *currentUser;

+ (RiverAuthAccount*) sharedAuth;
+ (void)authorizedRESTCall:(NSString*)endpoint withParams:(NSDictionary*)params callback:(void (^)(NSData *response, NSError* err))block;
+ (NSString *)fetchAlbumArtForURL:(NSString *)url;

// TODO: Auth delegate for callback

@end


@protocol RiverAuthDelegate <NSObject>

- (void)spotifyAuthorizedForUser:(User*)user;

@end