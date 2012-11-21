#import "MyDocument.h"
#import "Person.h"
#import "PreferenceController.h"

@implementation MyDocument

- (id)init
{
    self = [super init];
    if (self) {
		employees = [[NSMutableArray alloc] init];
		NSNotificationCenter *nc;
		nc = [NSNotificationCenter defaultCenter];
		[nc addObserver:self
			   selector:@selector(handleColorChange:)
				   name:@"BNRColorChanged"
				 object:nil];
		NSLog(@"Registered with notification center");
    }
    return self;
}

- (void)startObservingPerson:(Person *)person
{
	[person addObserver:self
			 forKeyPath:@"personName"
				options:NSKeyValueObservingOptionOld
				 context:NULL];
	
	[person addObserver:self
			 forKeyPath:@"expectedRaise"
				options:NSKeyValueObservingOptionOld
				context:NULL];
}

- (void)stopObservingPerson:(Person *)person
{
	[person removeObserver:self forKeyPath:@"personName"];
	[person removeObserver:self forKeyPath:@"expectedRaise"];
}

- (void)insertObject:(Person *)p inEmployeesAtIndex:(int)index
{
	// Add the inverse of this operation to the undo stack
	NSUndoManager *undo = [self undoManager];
	[[undo prepareWithInvocationTarget:self] removeObjectFromEmployeesAtIndex:index];
	if (![undo isUndoing]) {
		[undo setActionName:@"Insert Person"];
	}
	
	// Add the Person to the array
	[self startObservingPerson:p];
	[employees insertObject:p atIndex:index];
}

- (void)removeObjectFromEmployeesAtIndex:(int)index
{
	Person *p = [employees objectAtIndex:index];
	
	// Add the inverse of this operation to the undo stack
	NSUndoManager *undo = [self undoManager];
	[[undo prepareWithInvocationTarget:self] insertObject:p inEmployeesAtIndex:index];
	if (![undo isUndoing]) {
		[undo setActionName:@"Delete Person"];
	}
	
	// Remove the Person from the array
	[self stopObservingPerson:p];
	[employees removeObjectAtIndex:index];
}

- (void)setEmployees:(NSMutableArray *)array
{
	if (array == employees)
		return;
	
	NSEnumerator *e = [employees objectEnumerator];
	Person *person;
	while (person = [e nextObject]) {
		[self stopObservingPerson:person];
	}
	
	[employees release];
	[array retain];
	employees = array;
	
	e = [employees objectEnumerator];
	while (person = [e nextObject]) {
		[self startObservingPerson:person];
	}
}

- (void)changeKeyPath:(NSString *)keyPath
			 ofObject:(id)obj
			  toValue:(id)newValue
{
	// setValue:forKeyPath: will cause the key-value observing method
	// to be called, which takes care of the undo stuff
	[obj setValue:newValue forKeyPath:keyPath];
}

- (void)observeValueForKeyPath:(NSString *)keyPath
					  ofObject:(id)object
						change:(NSDictionary *)change
					   context:(void *)context
{
	NSUndoManager *undo = [self undoManager];
	id oldValue = [change objectForKey:NSKeyValueChangeOldKey];
	NSLog(@"oldValue = %@", oldValue);
	[[undo prepareWithInvocationTarget:self] changeKeyPath:keyPath
												  ofObject:object
												   toValue:oldValue];
	[undo setActionName:@"Edit"];
}

- (NSString *)windowNibName
{
	return @"MyDocument";
}

- (void)windowControllerDidLoadNib:(NSWindowController *) aController
{
	NSData *colorAsData;
    [super windowControllerDidLoadNib:aController];
	colorAsData = [[NSUserDefaults standardUserDefaults] objectForKey:BNRTableBgColorKey];
	
	// Because of a Cocoa bug introduced in 10.3.0, this change
	// doesn't become visible on some systems until after a row has
	// been added to the table view
	[tableView setBackgroundColor: [NSKeyedUnarchiver unarchiveObjectWithData:colorAsData]];
}

- (NSData *)dataRepresentationOfType:(NSString *)aType
{
	// End editing
	[personController commitEditing];
	
	// Create an NSData object from the employees array
	return [NSKeyedArchiver archivedDataWithRootObject:employees];
}

- (BOOL)loadDataRepresentation:(NSData *)data ofType:(NSString *)aType
{
	NSLog(@"About to read data of type %@", aType);
	NSMutableArray *newArray;
	newArray = [NSKeyedUnarchiver unarchiveObjectWithData:data];
	
	if (newArray == nil) {
		return NO;
	} else {
		[self setEmployees:newArray];
		return YES;
	}
}

- (void)handleColorChange:(NSNotification *)note
{
	NSLog(@"Received notification: %@", note);
	PreferenceController *sender = [note object];
	NSColor *newColor = [sender tableBgColor];
	
	// Due to bug in 10.3.0, this change will not be visible
	// on some systems unless the table view has at least one row.
	[tableView setBackgroundColor:newColor];
	[tableView setNeedsDisplay:YES];
}

- (void)remove:(id)sender
{
	NSArray *selectedPeople = [personController selectedObjects];
	
	// Run an alert panel
	int choice = NSRunAlertPanel(@"Delete",
								 @"Do you really want to delete %d records?",
								 @"Delete", @"Cancel", nil,
								 [selectedPeople count]);
	
	// If the user chose Delete, tell the array controller to
	// delete the people
	if (choice == NSAlertDefaultReturn) {
		[personController remove:sender];
	}
}

- (void)dealloc
{
	[self setEmployees:nil];
	
	NSNotificationCenter *nc;
	nc = [NSNotificationCenter defaultCenter];
	[nc removeObserver:self];
	NSLog(@"Unregistered with notification center: %@", [self fileName]);
	
	[super dealloc];
}

@end
