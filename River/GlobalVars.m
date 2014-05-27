//
//  GlobalVars.m
//  River
//
//  Created by Matthew Gardner on 2/23/14.
//  Copyright (c) 2014 mdg. All rights reserved.
//

#import "GlobalVars.h"

@implementation GlobalVars
@synthesize memberedRoom;
static GlobalVars *instance = nil;

+ (GlobalVars*)getVar {
    @synchronized(self) {
        if(instance == nil) {
            instance = [GlobalVars alloc];
        }
    }
    return instance;
}

@end
