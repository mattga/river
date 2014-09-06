//
//  RiverStatus.m
//  River
//
//  Created by Matthew Gardner on 6/30/14.
//  Copyright (c) 2014 mdg. All rights reserved.
//

#import "RiverStatus.h"

@implementation RiverStatus
@synthesize stackTrace, statusCode, description;

- (void)readFromJSONObject:(NSDictionary*)dict {
    statusCode = [[dict objectForKey:@"Status"] objectForKey:@"Code"];
    stackTrace = [[dict objectForKey:@"Status"] objectForKey:@"StackTrace"];
    description = [[dict objectForKey:@"Status"] objectForKey:@"Description"];
}

-(NSDictionary*)setDictionary:(NSMutableDictionary*)d
{
    if(self.statusCode != NULL)
    {
        [d setObject:self.statusCode  forKey:@"Code"];
    }
    
    if(self.description != NULL)
    {
        [d setObject:self.description forKey:@"Description"];
    }
    
    if(self.stackTrace != NULL)
    {
        [d setObject:self.stackTrace forKey:@"StackTrace"];
    }
    
    return d;
}

@end
