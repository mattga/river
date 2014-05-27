//
//  SPTracksXMLParser.m
//  CollabStream
//
//  Created by Matthew Gardner on 1/31/14.
//  Copyright (c) 2014 mdg. All rights reserved.
//

/*
 Stores XML Track element as a dictionary with he following keys:
 
 track_name
 track_href
 track_number
 artist_name
 artist_href
 album_name
 album_href
 album_released
 album_available_territories
 type
 length
 popularity
 
 */

#import "SPTracksXMLParser.h"

@implementation SPTracksXMLParser

- (id)init {
    self = [super init];
    if (self) {
        // Custom initialization
    }
    
    return self;
}

- (id)initWithData:(NSData *)data outputArray:(NSMutableArray *)array {
	
	_trackResults = array;
	[_trackResults removeAllObjects];
	
    return [super initWithData:data];
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName attributes:(NSDictionary *)attributeDict {
    //    NSLog(@"%@", elementName);
    //    int i = 0;
    //    for(NSObject* o in [attributeDict allKeys])
    //        NSLog(@"%d. %@",i,o);
    //    i = 0;
    //    for(NSObject* o in [attributeDict allValues])
    //        NSLog(@"%d. %@",i,o);
    
    _elementContentString = [[NSMutableString alloc] init];
    
    if([elementName isEqualToString:@"track"]) {
        state = TRACK; // next state
        trackDict = [[NSMutableDictionary alloc] init];
        NSString *attribute = [attributeDict valueForKey:@"href"];
		if (attribute != nil)
			[trackDict setObject:attribute forKey:@"track_href"];
        [_trackResults addObject:trackDict];
    } else if(state == TRACK && [elementName isEqualToString:@"name"]) {
        state = TRACK_NAME;
    } else if([elementName isEqualToString:@"artist"]) {
        state = ARTIST;	
        NSString *artistHref = [attributeDict valueForKey:@"href"];
        if(artistHref != nil)
            [trackDict setObject:artistHref forKey:@"artist_href"];
    } else if(state == ARTIST && [elementName isEqualToString:@"name"]) {
        state = ARTIST_NAME; // next state
    } else if([elementName isEqualToString:@"available"]) {
        state = TRACK_AVAILABLE;
    } else if([elementName isEqualToString:@"disc-number"]) {
        state = DISC_NUMBER;
    } else if([elementName isEqualToString:@"id"]) {
        state = _ID; // next state
        _idType = [attributeDict valueForKey:@"type"];
        if(_idType == nil)
            _idType = @""; // In case no id type is provided
    } else if([elementName isEqualToString:@"album"]) {
        state = ALBUM; // next state
        NSString *albumHref = [attributeDict valueForKey:@"href"];
        if(albumHref != nil)
            [trackDict setObject:albumHref forKey:@"album_href"];
    } else if(state == ALBUM && [elementName isEqualToString:@"name"]) {
        state = ALBUM_NAME; // next state
    } else if([elementName isEqualToString:@"released"]) {
        state = ALBUM_RELEASED; // next state
    } else if([elementName isEqualToString:@"availability"]) {
        state = ALBUM_AVAILABILITY;
    } else if([elementName isEqualToString:@"territories"]) {
        state = ALBUM_TERRITORIES;
    } else if([elementName isEqualToString:@"track-number"]) {
        state = TRACK_NUMBER;
    } else if([elementName isEqualToString:@"length"]) {
        state = LENGTH;
    } else if([elementName isEqualToString:@"popularity"]) {
        state = POPULARITY; // next state
    } else {
        state = NONE; // done
    }
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    if([elementName isEqualToString:@"track"])
        state = NONE;
    else
        END_OF_ELEMENT = YES; // used to inform parser:foundCharacters: to not set dict values to the new line values from XML
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    //    NSString *chars = @"Value:";
    //    chars = [chars stringByAppendingString:string];
    //    NSLog(@"%@",chars);
    
    [_elementContentString appendString:string];
    
    switch(state) {
        case TRACK:
            // No value to parse
            break;
        case TRACK_NAME:
            if(!END_OF_ELEMENT)
                [trackDict setObject:[NSString stringWithString:_elementContentString] forKey:@"track_name"];
            break;
        case ARTIST:
            // No value to parse
            break;
        case ARTIST_NAME:
            if(!END_OF_ELEMENT)
                [trackDict setObject:[NSString stringWithString:_elementContentString] forKey:@"artist_name"];
            break;
        case TRACK_AVAILABLE:
            if(!END_OF_ELEMENT)
                [trackDict setObject:[NSString stringWithString:_elementContentString] forKey:@"track_available"];
            break;
        case DISC_NUMBER:
            if(!END_OF_ELEMENT)
                [trackDict setObject:[NSString stringWithString:_elementContentString] forKey:@"disc_number"];
            break;
        case _ID:
            if(!END_OF_ELEMENT)
                [trackDict setObject:[NSString stringWithString:_elementContentString] forKey:[@"id_type=" stringByAppendingString:_idType]];
            break;
        case ALBUM:
            // No value to parse
            break;
        case ALBUM_NAME:
            if(!END_OF_ELEMENT)
                [trackDict setObject:[NSString stringWithString:_elementContentString] forKey:@"album_name"];
            break;
        case ALBUM_RELEASED:
            if(!END_OF_ELEMENT)
                [trackDict setObject:[NSString stringWithString:_elementContentString] forKey:@"album_released"];
            break;
        case ALBUM_AVAILABILITY:
            // No value to parse
            break;
        case ALBUM_TERRITORIES:
            if(!END_OF_ELEMENT)
                [trackDict setObject:[NSString stringWithString:_elementContentString] forKey:@"album_available_territores"];
            break;
        case TRACK_NUMBER:
            if(!END_OF_ELEMENT)
                [trackDict setObject:[NSString stringWithString:_elementContentString] forKey:@"track_number"];
            break;
        case LENGTH:
            if(!END_OF_ELEMENT)
                [trackDict setObject:[NSString stringWithString:_elementContentString] forKey:@"length"];
            break;
        case POPULARITY:
            if(!END_OF_ELEMENT)
                [trackDict setObject:[NSString stringWithString:_elementContentString] forKey:@"popularity"];
            break;
        case NONE:
        default:
            break;
    }
    END_OF_ELEMENT = NO;
}

@end
