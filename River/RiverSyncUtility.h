//
//  RiverSyncUtility.h
//  River
//
//  Created by Matthew Gardner on 7/20/14.
//  Copyright (c) 2014 mdg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GlobalVars.h"
#import "RiverAppDelegate.h"


@interface RiverSyncUtility : NSObject {
	dispatch_semaphore_t syncSemaphore;
	GlobalVars *vars;
	RiverAppDelegate *appDelegate;
}

+ (RiverSyncUtility*)sharedSyncing;

- (void)startRoomSync;
- (void)preemptRoomSync;

@end
