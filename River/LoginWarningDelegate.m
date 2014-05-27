//
//  LoginWarningDelegate.m
//  River
//
//  Created by Matthew Gardner on 3/1/14.
//  Copyright (c) 2014 mdg. All rights reserved.
//

#import "LoginWarningDelegate.h"
#import "CocoaLibSpotify.h"

@implementation LoginWarningDelegate

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [[[NSBundle mainBundle] loadNibNamed:@"LoginWarning" owner:self options:nil] firstObject];
}

@end
