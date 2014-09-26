//
//  RiverAuth.h
//  River
//
//  Created by Matthew Gardner on 4/24/14.
//  Copyright (c) 2014 mdg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MGConnection.h"
#import "Constants.h"
#import "User.h"


@protocol RiverAuthDelegate <NSObject>

- (void)userAuthorized:(NSString*)action;
//- (void)facebookUserAuthorized:(FBSession*)session;
//- (void)facebookUserAuthFailed:(FBSession*)session;
- (void)spotifyAuthorizedForUser:(User*)user;

@end


@interface RiverAuthController : NSObject

@property (weak, nonatomic) id<RiverAuthDelegate> authDelegate;
@property (nonatomic, strong) User *currentUser;

+ (RiverAuthController*) sharedAuth;
+ (void)authorizedRESTCall:(NSString*)endpoint action:(NSString*)action verb:(NSString*)verb _id:(NSString*)_id withParams:(NSDictionary*)params callback:(void (^)(id object, NSError* err))block;
+ (void)authorizedSyncRESTCall:(NSString*)endpoint action:(NSString*)action verb:(NSString*)verb _id:(NSString*)_id withParams:(NSDictionary*)params callback:(void (^)(id object, NSError* err))block;

@end