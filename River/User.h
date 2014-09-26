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

@property (nonatomic) NSInteger userId;
@property (strong, nonatomic) NSString *userName;
@property (strong, nonatomic) NSString *email;
@property (nonatomic) NSInteger tokens;

- (id)initWithName:(NSString*)name;

@end
