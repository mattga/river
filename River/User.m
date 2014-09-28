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
@synthesize UserId, DisplayName;

- (id)initWithName:(NSString*)name {
    DisplayName = name;
    return [self init];
}

- (void)readFromJSONObject:(NSDictionary*)dict {
	
	if (dict != nil && ![dict isEqual:[NSNull null]] && dict.count > 0) {
		
		if (![RiverUtility isJsonNull:dict forKey:@"UserId"]) {
			self.UserId = [[dict objectForKey:@"UserId"] integerValue];
		}
		if (![RiverUtility isJsonNull:dict forKey:@"Username"]) {
			self.DisplayName = [dict objectForKey:@"Username"];
		}
		if (![RiverUtility isJsonNull:dict forKey:@"Email"]) {
			self.Email = [dict objectForKey:@"Email"];
		}
		
		[super readFromJSONObject:dict];
	}
}

@end
