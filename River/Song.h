//
//  Song.h
//  River
//
//  Created by Matthew Gardner on 3/9/14.
//  Copyright (c) 2014 mdg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONSerializable.h"

@interface Song : NSObject <JSONSerializable>

@property (strong, nonatomic) NSString *trackId;
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *artist;
@property (strong, nonatomic) NSString *album;
@property (strong, nonatomic) NSString *albumArtURL;
@property (strong, nonatomic) NSMutableArray *contributers;
@property (nonatomic) NSNumber *year;
@property (nonatomic) NSNumber *length;
@property (nonatomic) NSNumber *tokens;
@property (nonatomic) BOOL isPlaying;

- (id)initWithId:(NSString*)ID;

@end
