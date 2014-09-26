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
#define kRiverWebPath											@"api/v1"

#define kSPWebProtocol											@"https"
#define kSPWebHost												@"api.spotify.com"
#define kSPWebVersion											@"v1"

// REST Web API
#define kRiverGet												@"GET"
#define kRiverPost												@"POST"
#define kRiverPut												@"PUT"
#define kRiverDelete											@"DELETE"

#define kRiverWebApiUser										@"User"
#define kRiverWebApiRoom										@"Room"
#define kRiverWebApiSong										@"Song"

#define kRiverWebApiActionAuthenticate							@"Authenticate"

#define kRiverActionPlaySong									@"Play"
#define kRiverActionAddSong										@"AddSong"
#define kRiverActionJoinRoom									@"JoinRoom"

#define kRiverWebApiVerbGet										@"GET"
#define kRiverWebApiVerbPost									@"POST"
#define kRiverWebApiVerbPut										@"PUT"
#define kRiverWebApiVerbDelete									@"DELETE"

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
#define kRiverDarkGray											[UIColor colorWithRed:0.180 green:0.227 blue:0.243 alpha:1.000]
#define kRiverWhite												[UIColor whiteColor]

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
