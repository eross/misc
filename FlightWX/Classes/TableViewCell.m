/*

File: TableViewCell.m
Abstract: Custom table cell.

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

#import "TableViewCell.h"

static UIImage *magnitude2Image = nil;
static UIImage *magnitude3Image = nil;
static UIImage *magnitude4Image = nil;
static UIImage *magnitude5Image = nil;

@interface TableViewCell()
- (UILabel *)newLabelWithPrimaryColor:(UIColor *)primaryColor selectedColor:(UIColor *)selectedColor fontSize:(CGFloat)fontSize bold:(BOOL)bold;
@end

@implementation TableViewCell

@synthesize earthquakeLocationLabel = _earthquakeLocationLabel;
@synthesize earthquakeDateLabel = _earthquakeDateLabel;
@synthesize earthquakeMagnitudeLabel = _earthquakeMagnitudeLabel;
@synthesize magnitudeImageView = _magnitudeImageView;

+ (void)initialize
{
    // The magnitude images are cached as part of the class, so they need to be
    // explicitly retained.
    magnitude2Image = [[UIImage imageNamed:@"2.0.png"] retain];
    magnitude3Image = [[UIImage imageNamed:@"3.0.png"] retain];
    magnitude4Image = [[UIImage imageNamed:@"4.0.png"] retain];
    magnitude5Image = [[UIImage imageNamed:@"5.0.png"] retain];
}

- (id)initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithFrame:frame reuseIdentifier:reuseIdentifier]) {
        UIView *myContentView = self.contentView;
        
        // Add an image view to display a waveform image of the earthquake.
		self.magnitudeImageView = [[UIImageView alloc] initWithImage:magnitude2Image];
		[myContentView addSubview:self.magnitudeImageView];
        [self.magnitudeImageView release];
        
        // A label that displays the location of the earthquake.
        self.earthquakeLocationLabel = [self newLabelWithPrimaryColor:[UIColor blackColor] selectedColor:[UIColor whiteColor] fontSize:14.0 bold:YES]; 
		self.earthquakeLocationLabel.textAlignment = UITextAlignmentLeft; // default
		[myContentView addSubview:self.earthquakeLocationLabel];
		[self.earthquakeLocationLabel release];
        
        // A label that displays the date of the earthquake.
        self.earthquakeDateLabel = [self newLabelWithPrimaryColor:[UIColor blackColor] selectedColor:[UIColor lightGrayColor] fontSize:10.0 bold:NO];
		self.earthquakeDateLabel.textAlignment = UITextAlignmentLeft; // default
		[myContentView addSubview:self.earthquakeDateLabel];
		[self.earthquakeDateLabel release];
        
        // A label that displays the magnitude of the earthquake.
        self.earthquakeMagnitudeLabel = [self newLabelWithPrimaryColor:[UIColor blackColor] selectedColor:[UIColor whiteColor] fontSize:24.0 bold:YES];
		self.earthquakeMagnitudeLabel.textAlignment = UITextAlignmentRight;
		[myContentView addSubview:self.earthquakeMagnitudeLabel];
		[self.earthquakeMagnitudeLabel release];
        
        // Position the magnitudeImageView above all of the other views so
        // it's not obscured. It's a transparent image, so any views
        // that overlap it will still be visible.
        [myContentView bringSubviewToFront:self.magnitudeImageView];
    }
    return self;
}

- (Earthquake *)quake
{
    return _quake;
}

// Rather than using one of the standard UITableViewCell content properties like 'text',
// we're using a custom property called 'quake' to populate the table cell. Whenever the
// value of that property changes, we need to call [self setNeedsDisplay] to force the
// cell to be redrawn.
- (void)setQuake:(Earthquake *)newQuake
{
    [newQuake retain];
    [_quake release];
    _quake = newQuake;
    
    self.earthquakeLocationLabel.text = newQuake.location;
    self.earthquakeDateLabel.text = newQuake.formattedDate;
    self.earthquakeMagnitudeLabel.text = newQuake.magnitude;
    self.magnitudeImageView.image = [self imageForMagnitude:newQuake.magnitude];
    
    [self setNeedsDisplay];
}

- (UIImage *)imageForMagnitude:(NSString *)magnitude
{
	CGFloat magnitudeFloat = [magnitude floatValue];
	
	if (magnitudeFloat >= 5.0) {
		return magnitude5Image;
	}
	if (magnitudeFloat >= 4.0) {
		return magnitude4Image;
	}
	if (magnitudeFloat >= 3.0) {
		return magnitude3Image;
	}
	if (magnitudeFloat >= 2.0) {
		return magnitude2Image;
	}
	return nil;
}

- (void)layoutSubviews {
    
#define LEFT_COLUMN_OFFSET 10
#define LEFT_COLUMN_WIDTH 200
	
#define MIDDLE_COLUMN_OFFSET 180
#define MIDDLE_COLUMN_WIDTH 100
		
#define UPPER_ROW_TOP 4
#define LOWER_ROW_TOP 28
    
    [super layoutSubviews];
    CGRect contentRect = self.contentView.bounds;
	
	// In this example we will never be editing, but this illustrates the appropriate pattern
    if (!self.editing) {
		
        CGFloat boundsX = contentRect.origin.x;
		CGRect frame;
        
        // Place the location label.
		frame = CGRectMake(boundsX + LEFT_COLUMN_OFFSET, UPPER_ROW_TOP, LEFT_COLUMN_WIDTH, 20);
		self.earthquakeLocationLabel.frame = frame;
        
        // Place the date label.
		frame = CGRectMake(boundsX + LEFT_COLUMN_OFFSET, LOWER_ROW_TOP, LEFT_COLUMN_WIDTH, 14);
		self.earthquakeDateLabel.frame = frame;
        
        // Place the waveform image.
        UIImageView *imageView = self.magnitudeImageView;
        frame = [imageView frame];
		frame.origin.x = boundsX + MIDDLE_COLUMN_OFFSET;
		frame.origin.y = 0;
 		imageView.frame = frame;
        
        // Place the magnitude label.
        CGSize magnitudeSize = [self.earthquakeMagnitudeLabel.text sizeWithFont:self.earthquakeMagnitudeLabel.font forWidth:MIDDLE_COLUMN_WIDTH lineBreakMode:UILineBreakModeTailTruncation];
        CGFloat magnitudeX = frame.origin.x + imageView.frame.size.width + 8.0;
        frame = CGRectMake(magnitudeX, UPPER_ROW_TOP, magnitudeSize.width, magnitudeSize.height);
        self.earthquakeMagnitudeLabel.frame = frame;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
	/*
	 Views are drawn most efficiently when they are opaque and do not have a clear background, so in newLabelForMainText: the labels are made opaque and given a white background.  To show selection properly, however, the views need to be transparent (so that the selection color shows through).  
     */
	[super setSelected:selected animated:animated];
	
	UIColor *backgroundColor = nil;
	if (selected) {
	    backgroundColor = [UIColor clearColor];
	} else {
		backgroundColor = [UIColor whiteColor];
	}
    
	self.earthquakeLocationLabel.backgroundColor = backgroundColor;
	self.earthquakeLocationLabel.highlighted = selected;
	self.earthquakeLocationLabel.opaque = !selected;
	
	self.earthquakeDateLabel.backgroundColor = backgroundColor;
	self.earthquakeDateLabel.highlighted = selected;
	self.earthquakeDateLabel.opaque = !selected;
	
	self.earthquakeMagnitudeLabel.backgroundColor = backgroundColor;
	self.earthquakeMagnitudeLabel.highlighted = selected;
	self.earthquakeMagnitudeLabel.opaque = !selected;
}

- (UILabel *)newLabelWithPrimaryColor:(UIColor *)primaryColor selectedColor:(UIColor *)selectedColor fontSize:(CGFloat)fontSize bold:(BOOL)bold
{
	/*
        Create and configure a label.
    */

    UIFont *font;
    if (bold) {
        font = [UIFont boldSystemFontOfSize:fontSize];
    } else {
        font = [UIFont systemFontOfSize:fontSize];
    }
    
    /*
        Views are drawn most efficiently when they are opaque and do not have a clear background, so set these defaults.  To show selection properly, however, the views need to be transparent (so that the selection color shows through).  This is handled in setSelected:animated:.
    */
	UILabel *newLabel = [[UILabel alloc] initWithFrame:CGRectZero];
	newLabel.backgroundColor = [UIColor whiteColor];
	newLabel.opaque = YES;
	newLabel.textColor = primaryColor;
	newLabel.highlightedTextColor = selectedColor;
	newLabel.font = font;
	
	return newLabel;
}

@end
