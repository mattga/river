//
//  SPArtistsXMLParser.h
//  CollabStream
//
//  Created by Matthew Gardner on 1/31/14.
//  Copyright (c) 2014 mdg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Elements.h"

@interface SPArtistsXMLParser : NSXMLParser <NSXMLParserDelegate> {
    NSMutableDictionary *artistDict;
    NSString *_idType;
    enum Elements state;
    bool END_OF_ELEMENT;
}

- (id)initWithData:(NSData *)data outputArray:(NSMutableArray *)array;

@property (retain, strong) NSMutableArray *artistResults;
@property (retain, strong) NSMutableString *elementContentString;

@end
