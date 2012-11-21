/*

File: XMLReader.m
Abstract: Uses NSXMLParser to extract the contents of an XML file and map it
Objective-C model objects.

Version: 1.7

Disclaimer: IMPORTANT:  This Apple software is supplied to you by Apple Inc.
("Apple") in consideration of your agreement to the following terms, and your
use, installation, modification or redistribution of this Apple software
constitutes acceptance of these terms.  If you do not agree with these terms,
please do not use, install, modify or redistribute this Apple software.

In consideration of your agreement to abide by the following terms, and subject
to these terms, Apple grants you a personal, non-exclusive license, under
Apple's copyrights in this original Apple software (the "Apple Software"), to
use, reproduce, modify and redistribute the Apple Software, with or without
modifications, in source and/or binary forms; provided that if you redistribute
the Apple Software in its entirety and without modifications, you must retain
this notice and the following text and disclaimers in all such redistributions
of the Apple Software.
Neither the name, trademarks, service marks or logos of Apple Inc. may be used
to endorse or promote products derived from the Apple Software without specific
prior written permission from Apple.  Except as expressly stated in this notice,
no other rights or licenses, express or implied, are granted by Apple herein,
including but not limited to any patent rights that may be infringed by your
derivative works or by other works in which the Apple Software may be
incorporated.

The Apple Software is provided by Apple on an "AS IS" basis.  APPLE MAKES NO
WARRANTIES, EXPRESS OR IMPLIED, INCLUDING WITHOUT LIMITATION THE IMPLIED
WARRANTIES OF NON-INFRINGEMENT, MERCHANTABILITY AND FITNESS FOR A PARTICULAR
PURPOSE, REGARDING THE APPLE SOFTWARE OR ITS USE AND OPERATION ALONE OR IN
COMBINATION WITH YOUR PRODUCTS.

IN NO EVENT SHALL APPLE BE LIABLE FOR ANY SPECIAL, INDIRECT, INCIDENTAL OR
CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE
GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
ARISING IN ANY WAY OUT OF THE USE, REPRODUCTION, MODIFICATION AND/OR
DISTRIBUTION OF THE APPLE SOFTWARE, HOWEVER CAUSED AND WHETHER UNDER THEORY OF
CONTRACT, TORT (INCLUDING NEGLIGENCE), STRICT LIABILITY OR OTHERWISE, EVEN IF
APPLE HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

Copyright (C) 2008 Apple Inc. All Rights Reserved.

*/

#import "XMLReader.h"

static NSUInteger parsedEarthquakesCounter;

@implementation XMLReader

@synthesize currentEarthquakeObject = _currentEarthquakeObject;
@synthesize contentOfCurrentEarthquakeProperty = _contentOfCurrentEarthquakeProperty;

// Limit the number of parsed earthquakes to 50. Otherwise the application runs very slowly on the device.
#define MAX_EARTHQUAKES 50

- (void)parserDidStartDocument:(NSXMLParser *)parser
{
    parsedEarthquakesCounter = 0;
}

- (void)parseXMLFileAtURL:(NSURL *)URL parseError:(NSError **)error
{	
    NSXMLParser *parser = [[NSXMLParser alloc] initWithContentsOfURL:URL];
    // Set self as the delegate of the parser so that it will receive the parser delegate methods callbacks.
    [parser setDelegate:self];
    // Depending on the XML document you're parsing, you may want to enable these features of NSXMLParser.
    [parser setShouldProcessNamespaces:NO];
    [parser setShouldReportNamespacePrefixes:NO];
    [parser setShouldResolveExternalEntities:NO];
    
    [parser parse];
    
    NSError *parseError = [parser parserError];
    if (parseError && error) {
        *error = parseError;
    }
    
    [parser release];
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    if (qName) {
        elementName = qName;
    }

    // If the number of parsed earthquakes is greater than MAX_ELEMENTS, abort the parse.
    // Otherwise the application runs very slowly on the device.
    if (parsedEarthquakesCounter >= MAX_EARTHQUAKES) {
        [parser abortParsing];
    }
    
    if ([elementName isEqualToString:@"entry"]) {
        
        parsedEarthquakesCounter++;
        
        // An entry in the RSS feed represents an earthquake, so create an instance of it.
        self.currentEarthquakeObject = [[Earthquake alloc] init];
        // Add the new Earthquake object to the application's array of earthquakes.
        [(id)[[UIApplication sharedApplication] delegate] performSelectorOnMainThread:@selector(addToEarthquakeList:) withObject:self.currentEarthquakeObject waitUntilDone:YES];
        return;
    }
        
    if ([elementName isEqualToString:@"link"]) {
        NSString *relAtt = [attributeDict valueForKey:@"rel"];
        if ([relAtt isEqualToString:@"alternate"]) {
            NSString *link = [attributeDict valueForKey:@"href"];
            link = [NSString stringWithFormat:@"http://earthquake.usgs.gov/%@", link];
            self.currentEarthquakeObject.webLink = link;
        }
    } else if ([elementName isEqualToString:@"title"]) {
        // Create a mutable string to hold the contents of the 'title' element.
        // The contents are collected in parser:foundCharacters:.
        self.contentOfCurrentEarthquakeProperty = [NSMutableString string];
        
    } else if ([elementName isEqualToString:@"updated"]) {
        // Create a mutable string to hold the contents of the 'updated' element.
        // The contents are collected in parser:foundCharacters:.
        self.contentOfCurrentEarthquakeProperty = [NSMutableString string];
        
    } else if ([elementName isEqualToString:@"georss:point"]) {
        // Create a mutable string to hold the contents of the 'georss:point' element.
        // The contents are collected in parser:foundCharacters:.
        self.contentOfCurrentEarthquakeProperty = [NSMutableString string];
    } else {
        // The element isn't one that we care about, so set the property that holds the 
        // character content of the current element to nil. That way, in the parser:foundCharacters:
        // callback, the string that the parser reports will be ignored.
        self.contentOfCurrentEarthquakeProperty = nil;
    }
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{     
    if (qName) {
        elementName = qName;
    }
    
    if ([elementName isEqualToString:@"title"]) {
        self.currentEarthquakeObject.title = self.contentOfCurrentEarthquakeProperty;
        
    } else if ([elementName isEqualToString:@"updated"]) {
        self.currentEarthquakeObject.eventDateString = self.contentOfCurrentEarthquakeProperty;
        
    } else if ([elementName isEqualToString:@"georss:point"]) {
        self.currentEarthquakeObject.geoRSSPoint = self.contentOfCurrentEarthquakeProperty;
    }
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    if (self.contentOfCurrentEarthquakeProperty) {
        // If the current element is one whose content we care about, append 'string'
        // to the property that holds the content of the current element.
        [self.contentOfCurrentEarthquakeProperty appendString:string];
    }
}

@end
