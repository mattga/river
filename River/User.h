//
//  User.h
//  River
//
//  Created by Matthew Gardner on 3/9/14.
//  Copyright (c) 2014 mdg. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject

@property (strong, nonatomic) NSString *userId;
@property (nonatomic) NSInteger tokens;
@property (nonatomic) BOOL isHost;

- (id)initWithID:(NSString*)ID;

+ (User*)userWithJSONObject:(NSDictionary*)dict;

@end
