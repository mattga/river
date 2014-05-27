//
//  RiverAlertView.m
//  River
//
//  Created by Matthew Gardner on 5/26/14.
//  Copyright (c) 2014 mdg. All rights reserved.
//

#import "RiverAlertView.h"

@implementation RiverAlertView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (RiverAlertView*)initWithContents:(NSString *)nibName
{
    
    RiverAlertView *newAlert = nil;
    
    NSArray *views = [[NSBundle mainBundle] loadNibNamed:nibName owner:self options:nil];
    if(views != NULL && views.count > 0)
    {
        newAlert = (RiverAlertView *)[views objectAtIndex:0];
    }
    
    return newAlert;
	
}

- (IBAction)cancelPressed:(id)sender {
	[self removeFromSuperview];
}

- (IBAction)okPressed:(id)sender {
}

@end
