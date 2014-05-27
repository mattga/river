//
//  SPArtistsXMLParser.m
//  CollabStream
//
//  Created by Matthew Gardner on 1/31/14.
//  Copyright (c) 2014 mdg. All rights reserved.
//

#import "SPArtistsXMLParser.h"

@implementation SPArtistsXMLParser

- (id)init {
    self = [super init];
    if (self) {
        // Custom initialization
    }
    
    return self;
}

- (id)initWithData:(NSData *)data outputArray:(NSMutableArray *)array {
    self.artistResults = array;
    [self.artistResults removeAllObjects];
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
    
    switch(state) {
        case NONE:
            if([elementName isEqualToString:@"artist"]) {
                state = ARTIST; // next state
                artistDict = [[NSMutableDictionary alloc] init];
                NSString *artistHref = [attributeDict valueForKey:@"href"];
                if (artistHref != nil)
					[artistDict setObject:artistHref forKey:@"artist_href"];
                [_artistResults addObject:artistDict];
            }
            break;
        case ARTIST:
            if([elementName isEqualToString:@"name"])
                state = ARTIST_NAME; // next state
            break;
        case ARTIST_NAME:
            if([elementName isEqualToString:@"popularity"])
                state = POPULARITY; // next state
            break;
        case POPULARITY:
        default:
            state = NONE; // done
            break;
    }
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
    
//    NSLog(@"%@", _elementContentString);
    
    switch(state) {
        case ARTIST:
            // No value to parse
            break;
        case ARTIST_NAME:
            if(!END_OF_ELEMENT)
                [artistDict setObject:[NSString stringWithString:_elementContentString] forKey:@"artist_name"];
            break;
        case POPULARITY:
            if(!END_OF_ELEMENT)
                [artistDict setObject:[NSString stringWithString:_elementContentString] forKey:@"popularity"];
            break;
        case NONE:
        default:
            break;
    }
    END_OF_ELEMENT = NO;
}
@end
