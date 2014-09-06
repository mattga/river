//
//  User.m
//  River
//
//  Created by Matthew Gardner on 3/9/14.
//  Copyright (c) 2014 mdg. All rights reserved.
//

#import "User.h"

@implementation User
@synthesize userId, userName;

- (id)initWithName:(NSString*)name {
    userName = name;
    return [self init];
}

- (void)readFromJSONObject:(NSDictionary*)dict {
	
	if (dict != nil && ![dict isEqual:[NSNull null]] && dict.count > 0) {
		
		self.userId = [[dict objectForKey:@"UserId"] integerValue];
		self.userName = [dict objectForKey:@"Username"];
		
		[super readFromJSONObject:dict];
	}
}

@end
