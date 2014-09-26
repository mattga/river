//
//  RiverSessionsDelegate.h
//  River
//
//  Created by Matthew Gardner on 3/8/14.
//  Copyright (c) 2014 mdg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CocoaLibSpotify.h"
#import "RiverAuthController.h"

@interface RiverSessionDelegate : NSObject <SPSessionDelegate>

@property (nonatomic) id<RiverAuthDelegate> riverDelegate;

@end
