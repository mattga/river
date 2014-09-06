//
//  AddSongTableViewController.h
//  River
//
//  Created by Matthew Gardner on 5/8/14.
//  Copyright (c) 2014 mdg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "RiverTableViewController.h"
#import "ResultsAlbumTableViewCell.h"
#import "ResultsArtistTableViewCell.h"
#import "ResultsSongTableViewCell.h"

@interface AddSongTableViewController : RiverTableViewController {
	
}

@property (nonatomic) unsigned int selectedRow;

// Passed data
@property (nonatomic) NSInteger selectedTab;

@end
