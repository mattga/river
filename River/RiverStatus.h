//
//  RiverStatus.h
//  River
//
//  Created by Matthew Gardner on 6/30/14.
//  Copyright (c) 2014 mdg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONSerializable.h"

@interface RiverStatus : NSObject <JSONSerializable>

@property(nonatomic, strong) NSNumber *statusCode;
@property(nonatomic, strong) NSString *stackTrace;
@property(nonatomic, strong) NSString *description;

- (NSDictionary*)setDictionary:(NSMutableDictionary*)d;

@end
