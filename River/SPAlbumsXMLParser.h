//
//  SpotifyAlbumsXMLParser.h
//  CollabStream
//
//  Created by Matthew Gardner on 1/27/14.
//  Copyright (c) 2014 mdg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Elements.h"

@interface SPAlbumsXMLParser : NSXMLParser <NSXMLParserDelegate> {
    NSMutableDictionary *albumDict;
    NSString *_idType;
    enum Elements state;
    bool END_OF_ELEMENT;
}

- (id)initWithData:(NSData *)data outputArray:(NSMutableArray *)array;

@property (retain, strong) NSMutableArray *albumResults;
@property (retain, strong) NSMutableString *elementContentString;

- (NSString *)fetchAlbumArtForURL:(NSString *)url;

@end
