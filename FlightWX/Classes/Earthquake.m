/*

File: Earthquake.m
Abstract: The model class that stores the information about an earthquake.

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

#import "Earthquake.h"

@interface Earthquake()
- (void)getMagnitudeAndLocationFromTitle:(NSString *)wholeTitle;
@end

@implementation Earthquake

@synthesize webLink = _webLink;
@synthesize magnitude = _magnitude;
@synthesize title = _title;
@synthesize location = _location;
@synthesize geoRSSPoint = _geoRSSPoint;
@synthesize eventDateString = _eventDateString;

- (NSString *)description
{
    // Override of -[NSObject description] to print a meaningful representation of self.
    return [NSString stringWithFormat:@"%@ %@", self.location, self.magnitude];
}

- (NSString *)formattedDate
{
    // You could use an NSDateFormatter to return a user-friendly representation
    // of the date.
    return self.eventDateString;
}

- (void)setTitle:(NSString *)newTitle
{
    [newTitle retain];
    [_title release];
    _title = newTitle;
    
    // The location and magnitude of the earthquake are parsed from the title.
    [self getMagnitudeAndLocationFromTitle:_title];
}

- (NSString *)locationAndMagnitude:(NSString **)outMagnitude inString:(NSString *)wholeTitle
{
	// <title>M 3.6, Virgin Islands region<title/>,
	// Pull out the magnitude and the title using a scanner.
			
	NSScanner *scanner = [NSScanner scannerWithString:wholeTitle];
	static NSString *magnitudeSeparator = @", ";
	NSString *magnitude = nil;
	[scanner scanUpToString:@" " intoString:nil]; // Scan past the "M " before the number.
    // Scan from the space up to the comma separator, which gives us the magnitude.
	BOOL foundSpace = [scanner scanUpToString:magnitudeSeparator intoString:&magnitude];
	if (foundSpace && magnitude && outMagnitude) {
		// If we found the pattern, set the outMagnitude argument to this method to the value we found.
		*outMagnitude = magnitude;
	}
	
	NSString *title = nil;
    // Scan from after the locaion of the separator up to the end of the string.
    // That gives us the location of the earthquake.
	[scanner setScanLocation:[scanner scanLocation] + [magnitudeSeparator length]];
	BOOL foundTitle = [scanner scanUpToString:@"" intoString:&title];
	if (foundTitle && title) {
		// Virgin Islands region
		return [title capitalizedString];
	}
	
    // Failed to find the location and magnitude of the earthquake.
	return nil;
}

- (void)getMagnitudeAndLocationFromTitle:(NSString *)wholeTitle
{
    NSString *magnitude = nil;
    NSString *location = [self locationAndMagnitude:&magnitude inString:wholeTitle];
    
    self.magnitude = magnitude;
    self.location = location;
}

@end
