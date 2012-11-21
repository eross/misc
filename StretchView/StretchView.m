#import "StretchView.h"

@implementation StretchView

- (id)initWithFrame:(NSRect)frameRect
{
	int i;
	NSPoint p;
	if ((self = [super initWithFrame:frameRect]) != nil) {
		// seed the random num generator
		srandom(time(NULL));
		
		//create a path object
		path = [[NSBezierPath alloc] init];
		[path setLineWidth:3.0];
		p = [self randomPoint];
		[path moveToPoint: p];
		for(i=0;i < 15;i++)
		{
			p = [self randomPoint];
			[path lineToPoint: p];
		}
		[path closePath];
	}
	return self;
}

- (void)drawRect:(NSRect)rect
{
	NSRect bounds = [self bounds];
	[[NSColor greenColor] set];
	[NSBezierPath fillRect:bounds];
	
	// draw in white
	[[NSColor whiteColor] set];
	[path stroke];
	if (image)
	{
		NSRect imageRect;
		
		imageRect.origin = NSZeroPoint;
		imageRect.size = [image size];
		
		[image drawInRect:imageRect
				 fromRect:imageRect
				operation:NSCompositeSourceOver
				 fraction:opacity];
	}
}

- (NSPoint)randomPoint
{
	NSPoint result;
	NSRect r;
	int width, height;
	r = [self bounds];
	width = round(r.size.width);
	height = round(r.size.height);
	result.x = (random() % width) + r.origin.x;
	result.y = (random() % height) + r.origin.y;
	return result;
}

- (void)dealloc
{
	[path release];
	[image release];
	[super dealloc];
}

-(void)mouseDown:(NSEvent*)event
{
	NSPoint p = [event locationInWindow];
	downPoint = [self convertPoint:p fromView:nil];
	currentPoint = downPoint;
	NSLog(@"click: %@",event);
}

- (void)setImage:(NSImage *)newImage
{
	[newImage retain];
	[image release];
	image = newImage;
	[self setNeedsDisplay:YES];
}

- (void)setOpacity:(float)x
{
	opacity = x;
	[self setNeedsDisplay:YES];
}

@end
