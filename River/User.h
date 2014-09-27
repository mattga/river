//
//  User.h
//  River
//
//  Created by Matthew Gardner on 3/9/14.
//  Copyright (c) 2014 mdg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RiverStatus.h"
#import "JSONSerializable.h"

@interface User : RiverStatus <JSONSerializable>

@property (nonatomic) NSInteger UserId;
@property (strong, nonatomic) NSString *DisplayName;
@property (strong, nonatomic) NSString *Email;
@property (nonatomic) NSInteger Tokens;

- (id)initWithName:(NSString*)name;

@end
