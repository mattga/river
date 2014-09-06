//
//  SPArtistsJSONParser.h
//  River
//
//  Created by Matthew Gardner on 7/6/14.
//  Copyright (c) 2014 mdg. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SPJSONParser : NSObject

+ (NSArray*)artistsFromSPJSON:(NSDictionary *)dict;
+ (NSArray*)albumsFromSPJSON:(NSDictionary *)dict;
+ (NSArray*)tracksFromSPJSON:(NSDictionary *)dict;
+ (NSURL*)imageURLFromSPJSON:(NSDictionary *)dict withSize:(int)size;
+ (NSString*)releaseYearFromSPJSON:(NSDictionary*)dict;

@end
