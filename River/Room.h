//
//  Room.h
//  River
//
//  Created by Matthew Gardner on 2/23/14.
//  Copyright (c) 2014 mdg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RiverStatus.h"
#import "JSONSerializable.h"

@interface Room : RiverStatus <JSONSerializable>

@property (nonatomic) NSInteger roomId;
@property (strong, nonatomic) NSString *roomName;
@property (strong, nonatomic) NSString *hostId;
@property (strong, nonatomic) NSMutableArray *songs;
@property (strong, nonatomic) NSMutableArray *members;
@property (nonatomic) NSUInteger currentSong;
@property (nonatomic) NSUInteger currentTokens;

- (id)initWithName:(NSString*)ID;

@end
