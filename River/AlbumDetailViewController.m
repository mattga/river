//
//  AlbumDetailViewController.m
//  River
//
//  Created by Matthew Gardner on 3/10/14.
//  Copyright (c) 2014 mdg. All rights reserved.
//

#import "AlbumDetailViewController.h"
#import "SPTracksXMLParser.h"
#import "GlobalVars.h"
#import "TrackDetailViewController.h"

@interface AlbumDetailViewController ()

@end

@implementation AlbumDetailViewController

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
	// Do any additional setup after loading the view.
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
	
	[self prepareLabels];
	
    // Fetch album art
    NSURL *url = [NSURL URLWithString:[RiverAuthAccount fetchAlbumArtForURL:[_album objectForKey:@"album_href"]]];
    NSLog(@"Fetching album art for url %@", url);
    [_albumArtImage setImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:url]]];
    
	[self fetchTracksForURI:[_album objectForKey:@"album_href"]];
	
    [super viewDidAppear:animated];
}

- (void)prepareLabels {
	UIFont *gothamBook18 = [UIFont fontWithName:kGothamBook size:18.0f];
	UIFont *gothamBook24 = [UIFont fontWithName:kGothamBook size:24.0f];
	
	NSString *album = [_album objectForKey:@"album_name"];
	NSString *artist = [_album objectForKey:@"artist_name"];
	NSString *string = [NSString stringWithFormat:@"%@\n%@\n", album, artist];
	NSMutableAttributedString *attrText = [[NSMutableAttributedString alloc] initWithString:string];
	
	[attrText addAttribute:NSFontAttributeName value:gothamBook24 range:NSMakeRange(0, album.length)];
	[attrText addAttribute:NSFontAttributeName value:gothamBook18 range:NSMakeRange(album.length + 1, artist.length)];
	
	[_albumInfoLabel setAttributedText:attrText];
	
	// Set footer labels
	[self.userLabel setText:[[RiverAuthAccount sharedAuth] currentUser].userId];
	[self.roomLabel setText:[GlobalVars getVar].memberedRoom.roomID];
	[self.tokenLabel setText:[NSString stringWithFormat:@"%d", [[RiverAuthAccount sharedAuth] currentUser].tokens]];
}

- (void)fetchTracksForURI:(NSString*)uri {
	[RiverAuthAccount authorizedRESTCall:kSPLookup withParams:@{@"extras" : kSPLookupExtrasTrack, @"uri" : uri} callback:^(NSData *response, NSError *err) {
		
		SPTracksXMLParser *parser = [[SPTracksXMLParser alloc] initWithData:response outputArray:_tracks];
		[parser setDelegate:parser];
		if(![parser parse])
			NSLog(@"%@", [[parser parserError] description]);
		
		NSLog(@"%@", _tracks);
		
		[tracksTVC.tableView reloadData];
	}];
}

- (IBAction)backPressed:(id)sender {
	[self.navigationController popViewControllerAnimated:YES];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	if ([segue.identifier isEqualToString:@"embedAlbumTracks"]) {
		tracksTVC = segue.destinationViewController;
		
		_tracks = [[NSMutableArray alloc] init];
		
		[tracksTVC setTracks:_tracks];
	} else if ([segue.identifier isEqualToString:@"trackDetailSegue"]) {
		[(TrackDetailViewController*)segue.destinationViewController setTrack:[_tracks objectAtIndex:[(NSIndexPath*)sender row]]];
	}
}

@end
