//
//  RiverUtility.m
//  River
//
//  Created by Matthew Gardner on 9/8/14.
//  Copyright (c) 2014 mdg. All rights reserved.
//

#import "RiverUtility.h"

@implementation RiverUtility

+ (NSDate*)parseCSharpDateTime:(NSString*)rawData {
	
	//Strip the colon out of the time zone
	NSRange timezone = NSMakeRange([rawData length] - 3, 3);
	NSString *cleanData = [rawData stringByReplacingOccurrencesOfString:@":" withString:@"" options:NSCaseInsensitiveSearch range:timezone ];
	// Get rid of the T also
	cleanData = [cleanData stringByReplacingOccurrencesOfString:@"T" withString:@" "];
	
	//Setup a formatter and parse it into a NSDate object
	NSDateFormatter *df = [[NSDateFormatter alloc] init];
	[df setDateFormat:@"yyyy-MM-dd HH:mm:ssZZZ"];
	NSDate *result = [df dateFromString: cleanData];
	
	return result;
}

+ (BOOL)isJsonNull:(NSDictionary*)dict forKey:(NSString*)key {
	id value = [dict objectForKey:key];
	
	return value == nil || [value isKindOfClass:[NSNull class]];
}

@end
