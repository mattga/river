//
//  User.m
//  River
//
//  Created by Matthew Gardner on 3/9/14.
//  Copyright (c) 2014 mdg. All rights reserved.
//

#import "User.h"

@implementation User
@synthesize userId, tokens, isHost;

- (id)initWithID:(NSString*)ID {
    userId = ID;
    return [self init];
}

+ (User*)userWithJSONObject:(NSDictionary*)dict {
    User *u = [[User alloc] init];
    
    u.userId = [dict objectForKey:@"id"];
    u.tokens = [[dict objectForKey:@"points"] integerValue];
    u.isHost = [[dict objectForKey:@"host"] boolValue];
    
    return u;
}

@end
