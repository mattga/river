//
//  Song.h
//  River
//
//  Created by Matthew Gardner on 3/9/14.
//  Copyright (c) 2014 mdg. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Track : NSObject

@property (strong, nonatomic) NSString *trackId;
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *artist;
@property (strong, nonatomic) NSString *album;
@property (strong, nonatomic) NSString *released;
@property (strong, nonatomic) NSMutableArray *contributers;
@property (nonatomic) double length;
@property (nonatomic) NSUInteger currentTokens;
@property (nonatomic) BOOL isPlaying;

- (id)initWithId:(NSString*)ID;

+ (Track*)trackWithJSONObject:(NSDictionary*)dict;
+ (Track*)trackWithXMLObject:(NSDictionary*)dict;

@end
