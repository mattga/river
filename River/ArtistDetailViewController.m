//
//  ArtistDetailTableViewController.m
//  River
//
//  Created by Matthew Gardner on 3/10/14.
//  Copyright (c) 2014 mdg. All rights reserved.
//

#import "ArtistDetailViewController.h"
#import "SPAlbumsXMLParser.h"
#import "GlobalVars.h"
#import "AlbumDetailViewController.h"

@interface ArtistDetailViewController ()

@end

@implementation ArtistDetailViewController
@synthesize artist;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
	[self.artistLabel setText:[artist objectForKey:@"artist_name"]];
	
    [self fetchAlbumsForURI:[artist objectForKey:@"artist_href"]];
}

- (void)viewDidAppear:(BOOL)animated {
	// Set footer labels
	[self.userLabel setText:[[RiverAuthAccount sharedAuth] currentUser].userId];
	[self.roomLabel setText:[GlobalVars getVar].memberedRoom.roomID];
	[self.tokenLabel setText:[NSString stringWithFormat:@"%d", [[RiverAuthAccount sharedAuth] currentUser].tokens]];
    
	[super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)fetchAlbumsForURI:(NSString*)uri {
	[RiverAuthAccount authorizedRESTCall:kSPLookup withParams:@{@"extras" : kSPLookupExtrasAlbum, @"uri" : uri} callback:^(NSData *response, NSError *err) {
		
		SPAlbumsXMLParser *parser = [[SPAlbumsXMLParser alloc] initWithData:response outputArray:_albums];
		[parser setDelegate:parser];
		if(![parser parse])
			NSLog(@"%@", [[parser parserError] description]);
		
		NSLog(@"%@", _albums);
		
		[albumsTVC.tableView reloadData];
	}];
}

- (IBAction)backPressed:(id)sender {
	[self.navigationController popViewControllerAnimated:YES];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	if ([segue.identifier isEqualToString:@"embedArtistAlbums"]) {
		albumsTVC = segue.destinationViewController;
		
		_albums = [[NSMutableArray alloc] init];
		
		[albumsTVC setAlbums:_albums];
	} else if ([segue.identifier isEqualToString:@"albumDetailSegue"]) {
		[(AlbumDetailViewController*)segue.destinationViewController setAlbum:[_albums objectAtIndex:[(NSIndexPath*)sender row]]];
	}
}


@end
