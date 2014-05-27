//
//  SPTracksXMLParser.h
//  CollabStream
//
//  Created by Matthew Gardner on 1/31/14.
//  Copyright (c) 2014 mdg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Elements.h"

@interface SPTracksXMLParser : NSXMLParser <NSXMLParserDelegate> {
    NSMutableDictionary *trackDict;
    NSString *_idType;
    enum Elements state;
    bool END_OF_ELEMENT;
}

- (id)initWithData:(NSData *)data outputArray:(NSMutableArray *)array;

@property (retain, strong) NSMutableArray *trackResults;
@property (retain, strong) NSMutableString *elementContentString;

@end
