//
//  RiverUtility.h
//  River
//
//  Created by Matthew Gardner on 9/8/14.
//  Copyright (c) 2014 mdg. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RiverUtility : NSObject

+ (NSDate*)parseCSharpDateTime:(NSString*)rawData;
+ (BOOL)isJsonNull:(NSDictionary*)dict forKey:(NSString*)key;

@end
