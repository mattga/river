//
//  ResultsAlbumTableViewCell.m
//  River
//
//  Created by Matthew Gardner on 5/8/14.
//  Copyright (c) 2014 mdg. All rights reserved.
//

#import "ResultsAlbumTableViewCell.h"

@implementation ResultsAlbumTableViewCell
@synthesize albumLabel, artistLabel, albumArtImage;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
