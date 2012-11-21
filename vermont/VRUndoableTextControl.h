/*
 Vermont Recipes
 VRUndoableTextControl.h
 Copyright © 2002 Bill Cheeseman. All rights reserved.

 Comments like "r1s5.1" refer to a Recipe and Step in Vermont Recipes, on the Web at www.stepwise.com/Articles/VermontRecipes, and available in expanded form as Cocoa Recipes for Mac OS X - The Vermont Recipes (Peachpit Press 2002, www.peachpit.com).
*/

/*
 This formal protocol is adopted by subclasses of controls having text cells to bring "live" undo and redo to text-based user controls. These subclasses include VRUndoableTextField, VRUndoableForm, and VRUndoableTableView. These subclasses also include the VRUndoableTextControl.include file for their implementation parts.

 The subclasses that adopt this protocol are identical in every respect except that each has a different superclass. This allows you to make any kind of text-based user control capable of "live" undo and redo selectively, so that, for example, some text fields are undoable and others are not, simply by declaring the type of one as VRUndoableTextField and the type of the other as NSTextField.
*/

@protocol VRUndoableTextControl

// The isEditing and isUndoing variables are declared as static variables in the implementation part of an undoable text control subclass (in the include file), but they are exposed publicly in this method.

- (BOOL) isEditing; // r9s5
	// Tests whether an undoable text cell is currently being edited. It can be tested, for example, in the action methods of undoable text controls to make sure the action methods are executed even if the value entered in the field is identical to the value stored in the model object. An action method connected to an undoable text field must always be executed, to guarantee that its accessor method is called and registers an undo action in order to clear the "live" redo stack when a pending edit in an undoable text control is committed. (This sometimes results in an action being placed in the undo stack that has no apparent effect.)
- (BOOL) isUndoing; // r11s12
	// Tests whether an undoable text cell is currently being undone. It can be tested, for example, in the control:textShouldEndEditing: method of an undoable table view to determine whether values are being set by undoing live editing. This information can be used to suspend tests on the validity of data entered in a cell, because such tests are unnecessary when restoring values that have previously passed muster.

@end
