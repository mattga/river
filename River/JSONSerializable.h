//
//  JSONSerializable.h
//  River
//
//  Created by Matthew Gardner on 7/1/14.
//  Copyright (c) 2014 mdg. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol JSONSerializable

- (void)readFromJSONObject:(NSDictionary*)dict;

@optional

- (id)JSONObjectFromObject;

@end
