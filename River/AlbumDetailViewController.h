//
//  AlbumDetailViewController.h
//  River
//
//  Created by Matthew Gardner on 3/10/14.
//  Copyright (c) 2014 mdg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RiverViewController.h"
#import "RiverAuthController.h"
#import "AlbumTracksTableViewController.h"

@interface AlbumDetailViewController : RiverViewController {
	AlbumTracksTableViewController *tracksTVC;
}

// Passed data
@property (strong, nonatomic) NSString *albumId;
@property (strong, nonatomic) NSDictionary *album;
@property (strong, nonatomic) NSArray *tracks;

@property (weak, nonatomic) IBOutlet UILabel *albumLabel;
@property (weak, nonatomic) IBOutlet UILabel *artistLabel;
@property (weak, nonatomic) IBOutlet UILabel *releasedLabel;
@property (weak, nonatomic) IBOutlet UIImageView *albumArtImage;

@property (weak, nonatomic) IBOutlet UILabel *roomLabel;
@property (weak, nonatomic) IBOutlet UILabel *userLabel;
@property (weak, nonatomic) IBOutlet UILabel *tokenLabel;

@property (weak, nonatomic) IBOutlet UIView *cardView;

@end
