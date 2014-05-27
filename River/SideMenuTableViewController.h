//
//  SideMenuTableViewController.h
//  CollabStream
//
//  Created by Matthew Gardner on 2/2/14.
//  Copyright (c) 2014 mdg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SideMenuTableViewController : UITableViewController {
	NSIndexPath *selectedRow;
}

@property (nonatomic, strong) NSArray *menuItems;

@end
