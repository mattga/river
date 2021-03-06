//
//  RoomViewPlaylistTableViewCell.h
//  River
//
//  Created by Safeer Mohiuddin on 3/11/14.
//  Copyright (c) 2014 mdg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Song.h"
#import "GlobalVars.h"

@interface RoomSongTableViewCell : UITableViewCell {

}

@property (strong, nonatomic) NSMutableData *responseData;
@property (strong, nonatomic) Song *song;

@property (weak, nonatomic) IBOutlet UILabel *tokensLabel;
@property (weak, nonatomic) IBOutlet UILabel *songLabel;
@property (weak, nonatomic) IBOutlet UILabel *artistLabel;
@property (weak, nonatomic) IBOutlet UIImageView *albumArtImageView;

- (void)setSong:(Song*)song;


@end
