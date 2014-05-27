//
//  RoomMemberTableViewCell.h
//  River
//
//  Created by Matthew Gardner on 5/5/14.
//  Copyright (c) 2014 mdg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"

@interface RoomMemberTableViewCell : UITableViewCell

@property (strong, nonatomic) User *user;

@property (weak, nonatomic) IBOutlet UIImageView *userImageVIew;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *tokenLabel;

- (void)setMember:(User*)user;

@end
