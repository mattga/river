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
#define kRiverWebHost                                           @"54.191.119.187"
#define kRiverWebPath											@"api"
#define kRiverWebVersion										@"v1"

#define kSPWebProtocol											@"https"
#define kSPWebHost												@"api.spotify.com"
#define kSPWebVersion											@"v1"

// REST Web API
#define kRiverGet												@"GET"
#define kRiverPost												@"POST"
#define kRiverPut												@"PUT"
#define kRiverDelete											@"DELETE"

#define kRiverRESTUser											@"UserRest"
#define kRiverRESTRoom											@"RoomRest"
#define kRiverRESTSong											@"SongRest"

#define kRiverActionPlaySong									@"Play"
#define kRiverActionAddSong										@"AddSong"
#define kRiverActionJoinRoom									@"JoinRoom"

#define kRiverStatusOK											0
#define kRiverStatusNotFound									1
#define kRiverStatusAlreadyExists								2
#define kRiverStatusError										3

#define kSPRESTAlbums											@"albums"
#define kSPRESTArtists											@"artists"
#define kSPRESTSearch											@"search"

// Color Scheme
#define kRiverLightBlue                                         [UIColor colorWithRed:0.000 green:0.663 blue:0.898 alpha:1.000]
#define kRiverDarkBlue											[UIColor colorWithRed:0.246 green:0.413 blue:0.482 alpha:1.000]
#define kRiverBGLightGray                                       [UIColor colorWithWhite:0.863 alpha:1.000]
#define kRiverFGDarkGray										[UIColor colorWithWhite:0.121 alpha:1.000]
#define kRiverFGDarkGray_70										[UIColor colorWithWhite:0.121 alpha:0.700]
#define kRiverFGDarkGray_65										[UIColor colorWithWhite:0.121 alpha:0.650]
#define kRiverFGDarkGray_60										[UIColor colorWithWhite:0.121 alpha:0.600]
#define kRiverFGDarkGray_55										[UIColor colorWithWhite:0.121 alpha:0.550]
#define kRiverFGDarkGray_50										[UIColor colorWithWhite:0.121 alpha:0.500]

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

#define kSideMenuShare											1
#define kSideMenuHost											2
#define kSideMenuJoin											3
#define kSideMenuCreate											4
#define kSideMenuSettings										5

#define kRiverAlbumArtLarge										280
#define kRiverAlbumArtMedium									140
#define kRiverAlbumArtSmall										60

#endif
