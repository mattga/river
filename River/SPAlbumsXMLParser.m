//
//  SpotifyAlbumsXMLParser.m
//  CollabStream
//
//  Created by Matthew Gardner on 1/27/14.
//  Copyright (c) 2014 mdg. All rights reserved.
//

#import "SPAlbumsXMLParser.h"

//static NSMutableArray *albumResults;

@implementation SPAlbumsXMLParser

- (id)init {
    self = [super init];
    if (self) {
        // Custom initialization
    }
    
    return self;
}

- (id)initWithData:(NSData *)data outputArray:(NSMutableArray *)array {
    self.albumResults = array;
    [self.albumResults removeAllObjects];
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
    
	if([elementName isEqualToString:@"album"]) {
		state = ALBUM; // next state
		albumDict = [[NSMutableDictionary alloc] init];
		NSString *albumHref = [attributeDict valueForKey:@"href"];
		if(albumHref != nil)
			[albumDict setObject:albumHref forKey:@"album_href"];
		[_albumResults addObject:albumDict];
	} else if([elementName isEqualToString:@"name"] && state == ALBUM)
		state = ALBUM_NAME; // next state
	else if([elementName isEqualToString:@"artist"]) {
		state = ARTIST; // next state
		NSString *artistHref = [attributeDict valueForKey:@"href"];
		if(artistHref != nil)
			[albumDict setObject:artistHref forKey:@"artist_href"];
	} else if([elementName isEqualToString:@"name"] && state == ARTIST)
		state = ARTIST_NAME; // next state
	else if([elementName isEqualToString:@"id"]) {
		state = _ID; // next state
		_idType = [attributeDict valueForKey:@"type"];
		if(_idType == nil)
			_idType = @""; // In case no id type is provided
	} else if ([elementName isEqualToString:@"released"])
		state = ALBUM_RELEASED; // next state
	else if([elementName isEqualToString:@"id"]) {
		state = _ID; // next state
		_idType = [attributeDict valueForKey:@"type"];
		if(_idType == nil)
			_idType = @""; // In case no id type is provided
	} else if([elementName isEqualToString:@"popularity"])
		state = POPULARITY; // next state
	else if([elementName isEqualToString:@"availability"])
		state = AVAILABILITY;
	else if([elementName isEqualToString:@"availability"])
		state = AVAILABILITY;
	else if([elementName isEqualToString:@"territories"])
		state = TERRITORIES;
	else
		state = NONE;

}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    if([elementName isEqualToString:@"album"])
        state = NONE;
    else
        END_OF_ELEMENT = YES; // used to inform (void)parser:foundCharacters: to not set dict values to the new line values from XML
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
//    NSString *chars = @"Value:";
//    chars = [chars stringByAppendingString:string];
//    NSLog(@"%@",chars);

    [_elementContentString appendString:string];
    
    switch(state) {
        case ALBUM:
            // No value to parse
            break;
        case ALBUM_NAME:
            if(!END_OF_ELEMENT)
                [albumDict setObject:[NSString stringWithString:_elementContentString] forKey:@"album_name"];
            break;
        case ARTIST:
            // No value to parse
            break;
        case ARTIST_NAME:
            if(!END_OF_ELEMENT)
                [albumDict setObject:[NSString stringWithString:_elementContentString] forKey:@"artist_name"];
            break;
        case ALBUM_RELEASED:
            if(!END_OF_ELEMENT)
               [albumDict setObject:[NSString stringWithString:_elementContentString] forKey:@"album_released"];
            break;
        case _ID:
            if(!END_OF_ELEMENT)
                [albumDict setObject:[NSString stringWithString:_elementContentString] forKey:[@"id_type=" stringByAppendingString:_idType]];
            break;
        case POPULARITY:
            if(!END_OF_ELEMENT)
                [albumDict setObject:[NSString stringWithString:_elementContentString] forKey:@"popularity"];
            break;
        case AVAILABILITY:
            // No value to parse
            break;
        case TERRITORIES:
            if(!END_OF_ELEMENT)
                [albumDict setObject:[NSString stringWithString:_elementContentString] forKey:@"available_territores"];
            break;
        case NONE:
        default:
            break;
    }
    END_OF_ELEMENT = NO;
}

- (NSString *)fetchAlbumArtForURL:(NSString *)url {
    NSString *post = @"https://embed.spotify.com/oembed/?url=";
    post = [post stringByAppendingString:url];
    
    //    NSLog(@"Posting query: %@", post);
    
    // Create the request.
    NSURLRequest *theRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:post]
                                                cachePolicy:NSURLRequestUseProtocolCachePolicy
                                            timeoutInterval:60.0];
    
    // Create the connection with the request and start loading the data.
    NSURLResponse* response = nil;
    NSData* data = [NSURLConnection sendSynchronousRequest:theRequest returningResponse:&response error:nil];
    
    NSString* dataAsString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    NSRange endRange = [dataAsString rangeOfString:@"\",\"provider_name"];
    NSInteger end = endRange.location;
    NSString *artURL = [dataAsString substringToIndex:end];
    
    NSRange startRange = [artURL rangeOfString:@"\"thumbnail_url\":\""];
    NSInteger start = startRange.location + startRange.length;
    artURL = [[artURL substringFromIndex:start] stringByReplacingOccurrencesOfString:@"\\/" withString:@"/"];
    
    
    return artURL;
}

@end
