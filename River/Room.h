//
//  Room.h
//  River
//
//  Created by Matthew Gardner on 2/23/14.
//  Copyright (c) 2014 mdg. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Room : NSObject

@property (strong, nonatomic) NSString *roomID;
@property (strong, nonatomic) NSString *host;
@property (strong, nonatomic) NSMutableArray *songs;
@property (strong, nonatomic) NSMutableArray *members;
@property (nonatomic) NSUInteger currentSong;
@property (nonatomic) NSUInteger currentTokens;

- (id)initWithID:(NSString*)ID;

@end
