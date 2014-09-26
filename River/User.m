//
//  User.m
//  River
//
//  Created by Matthew Gardner on 3/9/14.
//  Copyright (c) 2014 mdg. All rights reserved.
//

#import "User.h"
#import "RiverUtility.h"

@implementation User
@synthesize userId, userName;

- (id)initWithName:(NSString*)name {
    userName = name;
    return [self init];
}

- (void)readFromJSONObject:(NSDictionary*)dict {
	
	if (dict != nil && ![dict isEqual:[NSNull null]] && dict.count > 0) {
		
		if (![RiverUtility isJsonNull:dict forKey:@"UserId"]) {
			self.userId = [[dict objectForKey:@"UserId"] integerValue];
		}
		if (![RiverUtility isJsonNull:dict forKey:@"Username"]) {
			self.userName = [dict objectForKey:@"Username"];
		}
		if (![RiverUtility isJsonNull:dict forKey:@"Email"]) {
			self.email = [dict objectForKey:@"Email"];
		}
		
		[super readFromJSONObject:dict];
	}
}

@end
