#import "MyCustView.h"

@implementation MyCustView

- (void)awakeFromNib
{
	mouseClicked = NO;
	npoint = NSMakePoint(250,250);
}
- (void)mouseDown:(NSEvent *)e {
	NSLog(@"******Got Mouse down event*******\n");
	NSPoint locn = [e locationInWindow];
	NSLog(@"Raw:   %f, %f\n",locn.x, locn.y);
	NSPoint local_locn = [self convertPoint:locn fromView:nil];
	NSLog(@"Local: %f, %f\n",local_locn.x, local_locn.y);
	[self setNeedsDisplay:YES];
	mouseClicked = YES;

}

- (void)drawRect:(NSRect)rect
{
	if(mouseClicked)
	{
		//Revisit: move this into its own object for different dist algorithms
		npoint.x = random() % (long)rect.size.width;
		if(npoint.x < 10)
			npoint.x = 10;
		
		npoint.y = random() % (long)rect.size.height;
		if(npoint.y < 10)
			npoint.y = 10;
		
		mouseClicked = NO;
	}
	NSBezierPath *path;
	NSLog(@"*****drawRect()*****\n");
	NSLog(@"Point: %f, %f\n", npoint.x, npoint.y);
	
	[[NSColor redColor] setStroke ];
	path = [NSBezierPath bezierPath];
	[path moveToPoint:NSMakePoint(npoint.x - 10, npoint.y - 10)];
	[path lineToPoint:NSMakePoint(npoint.x - 10, npoint.y + 10)];
	[path lineToPoint:NSMakePoint(npoint.x + 10, npoint.y + 10)];
	[path lineToPoint:NSMakePoint(npoint.x + 10, npoint.y - 10)];	
	[path lineToPoint:NSMakePoint(npoint.x - 10, npoint.y - 10)];
	
	[path closePath];
	[path stroke];
}
@end
