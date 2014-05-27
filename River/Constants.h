//
//  Constants.h
//  River
//
//  Created by Matthew Gardner on 4/25/14.
//  Copyright (c) 2014 mdg. All rights reserved.
//

#ifndef River_Constants_h
#define River_Constants_h

// Web Connection
#define kRiverWebProtocol                                       @"http"
#define kRiverWebHost                                           @"partymix.herokuapp.com"
#define kSPWebProtocol											@"https"
#define kSPWebHost												@"ws.spotify.com"
#define kSPWebVersion											@"1"

//>>newGroup
// String groupId
// String userId

//>>addSong
// String groupId
// String userId
// String songId
// String title
// String artist
// Integer points

//>play
// Marks a song as playing
// String groupId
// String songId

//>>deleteSong
// Removes song from Q, pts from song distributed
// String groupId
// String songId

//>>joinGroup
// String groupId
// String userId

//>>getGroupMates
// Will also return user points
// String groupId

//>>getGroupSongs
// Returns queue of songs sorted by points with all associated info
// String groupId

//>>getUserPoints
// String groupId
// String userId

//>>newUser
// Enforces uniqueness for username
// String userId

// Song Lifecycle:
// Added to Q, Points can be added by users,
// mark as playing when top of list. Delete when finished playing.

// REST Endpoints
#define kRiverRESTNewGroup                                      @"newGroup"
#define kRiverRESTAddSong                                       @"addSong"
#define kRiverRESTPlay                                          @"play"
#define kRiverRESTDeleteSong                                    @"deleteSong"
#define kRiverRESTJoinGroup                                     @"joinGroup"
#define kRiverRESTGetGroupMates                                 @"getGroupMates"
#define kRiverRESTGetGroupSongs                                 @"getGroupSongs"
#define kRiverRESTGetUserPoints                                 @"getUserPoints"
#define kRiverRESTNewUser                                       @"newUser"

#define kSPLookup												@"lookup"
#define kSPLookupExtrasAlbum									@"albumdetail"
#define kSPLookupExtrasTrack									@"track"
#define kSPSearchTracks											[NSString stringWithFormat:@"search/%@/track", kSPWebVersion]
#define kSPSearchArtists										[NSString stringWithFormat:@"search/%@/artist", kSPWebVersion]
#define kSPSearchAlbums											[NSString stringWithFormat:@"search/%@/album", kSPWebVersion]

// Color Scheme
#define kRiverLightBlue                                         [UIColor colorWithRed:0.000 green:0.663 blue:0.898 alpha:1.000]
#define kRiverDarkBlue											[UIColor colorWithRed:0.246 green:0.413 blue:0.482 alpha:1.000]
//#define kRiverBGLightGray_80									[UIColor colorWithRed:0.246 green:0.413 blue:0.482 alpha:0.700]
//#define kRiverBGLightGray_80									[UIColor colorWithRed:0.000 green:0.663 blue:0.898 alpha:0.600]
#define kRiverBGLightGray_60									[UIColor colorWithWhite:0.863 alpha:0.600]
#define kRiverBGLightGray                                       [UIColor colorWithWhite:0.863 alpha:1.000]
#define kRiverFGDarkGray										[UIColor colorWithWhite:0.121 alpha:1.000]

#define kGothamLight											@"Gotham-Light"
#define kGothamLightItalic										@"Gotham-LightItalic"
#define kGothamMedium											@"Gotham-Medium"
#define kGothamBook												@"Gotham-Book"
#define kGothamBookItalic										@"Gotham-BookItalic"
#define kGothamBold												@"Gotham-Bold"
#define kHelveticaNeueCondensedBold								@"HelveticaNeue-CondensedBold"

#define kHostSongsSelected										0
#define kHostMembersSelected									1

#define kSearchResultsSongs										0
#define kSearchResultsArtists									1
#define kSearchResultsAlbums									2

#endif
