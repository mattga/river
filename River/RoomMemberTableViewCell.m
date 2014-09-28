//
//  RoomMemberTableViewCell.m
//  River
//
//  Created by Matthew Gardner on 5/5/14.
//  Copyright (c) 2014 mdg. All rights reserved.
//

#import "RoomMemberTableViewCell.h"

@implementation RoomMemberTableViewCell
@synthesize userImageVIew, usernameLabel;
@synthesize tokenLabel;

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

- (void)setMember:(User*)user {
    
    if ( _user != user ) {
        _user = user;
    }
    
    usernameLabel.text = _user.DisplayName;
	tokenLabel.text = [NSString stringWithFormat:@"%d", _user.Tokens];
}

@end
