#import "GlissView.h"
#import <GLUT/glut.h>

@implementation GlissView

- (id)initWithFrame:(NSRect)frameRect
		pixelFormat:(NSOpenGLPixelFormat *)pixFmt
{
	self = [super initWithFrame:frameRect pixelFormat:pixFmt];
	[self prepare];
	return self;
}

- (id)initWithCoder:(NSCoder *)c
{
	self = [super initWithCoder:c];
	[self prepare];
	return self;
}

- (void)prepare
{
	NSLog(@"prepare");
    float mat[4];
    NSOpenGLContext *glcontext;
    GLfloat ambient[] = {0.2, 0.2, 0.2, 1.0}; 
    GLfloat diffuse[] = {1.0, 1.0, 1.0, 1.0};
	
    // The GL context must be active for these functions to have an effect
    glcontext = [self openGLContext];
    [glcontext makeCurrentContext];
    
    // Configure the view
    glShadeModel(GL_SMOOTH);
    glEnable(GL_LIGHTING);
    glEnable(GL_DEPTH_TEST);
    
    // Add some ambient lighting.
    glLightModelfv(GL_LIGHT_MODEL_AMBIENT, ambient);
    
    // Initialize the light
    glLightfv(GL_LIGHT0, GL_DIFFUSE, diffuse);
    // and switch it on.
    glEnable(GL_LIGHT0);
    
    // Set the properties of the material under ambient light
    mat[0] = 0.1;
    mat[1] = 0.1;
    mat[2] = 0.7;
    mat[3] = 1.0;
    glMaterialfv(GL_FRONT, GL_AMBIENT, mat);
    
    // Set the properties of the material under diffuse light
    mat[0] = 0.2;
    mat[1] = 0.6;
    mat[2] = 0.1;
    glMaterialfv(GL_FRONT, GL_DIFFUSE, mat);	   
}

// Called when the view resizes
- (void)reshape
{
	NSLog(@"reshaping");
    NSRect rect = [self bounds];
    glViewport(0,0, rect.size.width, rect.size.height);
    glMatrixMode(GL_PROJECTION);
    glLoadIdentity();
    gluPerspective(60.0,
                   rect.size.width/rect.size.height,
                   0.2, 7);
}
- (void)awakeFromNib
{
    [self changeParameter:self];
}

- (IBAction)changeParameter:(id)sender
{
    lightX = [[sliderMatrix cellWithTag:LIGHT_X_TAG] floatValue];
    theta = [[sliderMatrix cellWithTag:THETA_TAG] floatValue];
    radius = [[sliderMatrix cellWithTag:RADIUS_TAG] floatValue];
    [self setNeedsDisplay:YES];
}

- (void)drawRect:(NSRect)r
{
    GLfloat lightPosition[] = {lightX, 1, 3, 0.0};
    
    // Clear the background
    glClearColor (0.2, 0.4, 0.1, 0.0);
    glClear(GL_COLOR_BUFFER_BIT |
            GL_DEPTH_BUFFER_BIT);
    
    // Set the view point
    glMatrixMode(GL_MODELVIEW);
    glLoadIdentity();
    gluLookAt(radius * sin(theta), 0,  radius * cos(theta), 0, 0, 0, 0, 1, 0);
    
    // Put the light in place
    glLightfv(GL_LIGHT0, GL_POSITION, lightPosition);
    
    // Draw the stuff
    glTranslatef(0, 0, 0);
    glutSolidTorus(0.3, 0.9, 35, 31);
    glTranslatef(0, 0, -1.2);
    glutSolidCone(1, 1, 17, 17);
    glTranslatef(0, 0, 0.6);
    glutSolidTorus(0.3, 1.8, 35, 31);
    
    // Flush to screen
    glFinish();
}

@end
