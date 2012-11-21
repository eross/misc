/*
Copyright (c) 2004, Flying Meat Inc.
All rights reserved. 
*/

/**
The plugin api for VP is pretty easy to use.  The easiest way to get started is
to subclass VPPlugin, and then when didRegister is called, add a menu item to
VoodooPad by using some code like this:
 
id <VPPluginManager> pluginManager = [self pluginManager];

[pluginManager addPluginsMenuTitle:@"My Super Plugin"
                withSuperMenuTitle:@"Cool Plugins"  // this may be nil if you
                                                 // don't want a super menu
                            target:self // what's going to be called when the
                                     // plugin gets selected?
                            action:@selector(doSuperPluginStuff:) // what selector to use?
                     keyEquivalent:@"" // should we have a keybinding?
         keyEquivalentModifierMask:0]; // what mask to use for the binding?
 
and then implement:
 
- (void) doSuperPluginStuff:(id<VPWindowController>)windowController
 
}

And go on your merry way.  If your plugin is going to be doing alot of
processing, then you might want to thread it-  Check out VPHTMLExport's
exportToPathViaThread: method for a standard way to give feedback while you are
doing this.

Also, you can call the plugin via applescript a well-  Here's a useless example:

tell application "VoodooPad"
    set p to {propertyOne:"someValue", propertyTwo:"SomeOtherValue"}
    tell window 1 to use plugin named "Word Count" with properties p
end tell

So, for this example (in VPSuperPlugin.m) there's a method named:

- (void) doWordCount:(id<VPWindowController>)windowController;

This is called when the "Word Count" menu is selected.  It's applescript version
is named:

- (void) doWordCountViaAppleScript:(id<VPWindowController>)windowController 
                    withProperties:(NSDictionary*)d;
                    
You don't ever need to register this method- when it is called via applescript
the method "doWordCount:" is transmorgified into "doWordCountViaAppleScript:withProperties:"
and if impelemented it will be called.  Otherwise it just calls "doWordCount:"
like it would be if it was called via the menu.

Kind of neat, eh?
*/


#import <Cocoa/Cocoa.h>

// pass in -DDEBUG to gcc in development builds to see some output when you 
// don't feel like using a debugger.

#ifdef DEBUG
    #define debug(...) NSLog(__VA_ARGS__)
#else
    #define debug(...)
#endif

@protocol VPPluginManager;
@protocol VPTaskManager;

@interface VPPlugin : NSObject {
    id<VPPluginManager> manager;
}

/*
    This will create an instance of our plugin.  You really shouldn't need to
    worry about this at all.
*/
+ (VPPlugin*) plugin;

/*
    This gets called right before the plugin manager registers your plugin.
    I'm honestly not sure what you would use it for, but it seemed like a good
    idea at the time.
*/
- (void) willRegister;

/*
    didRegister is called right after your plugin is all ready to go as far as
    VoodooPad is concerned.  At this point, a call to [self pluginManager] will
    return the plugin manager, and you can do things like add menus and such.
*/
- (void) didRegister;

/*
    These two methods just let you set and retrieve the plugin manager.
    You probably shouldn't ever call setPluginManager, since that is really only
    of use to VoodooPad to get you up and going.
*/
- (void) setPluginManager:(id<VPPluginManager>)aPluginManager;
- (id<VPPluginManager>) pluginManager;

@end


/**
    VPData is the class that holds a page or url in VoodooPad.  It's got little
    bits of information that you might want.
*/
@protocol VPData <NSObject>

/**
    returns YES if this object represents a URL, and NO if it represents a page.
*/
- (BOOL) isURL;

/**
    returns a NSDate that represents the last time this vpdata was modified.
*/
- (NSDate*) modifiedDate;

/**
    returns a url (as a string) that this object represents.  Only useful if
    isURL returns YES.
*/
- (NSString *) url;

/**
    returns a string representing the title or alias of this page/url.
*/
- (NSString *) title;

/**
    returns the key for this vpdata.  This is always lowercase.  This can be
    thought of as the "primary key" in database terms for this ... row.
*/
- (NSString *) key;

/**
    get the page data as an attributed string.
*/
- (NSMutableAttributedString*) dataAsAttributedString;

/**
    pass an attributed string to the vpdata, and it will set it as the page data.
*/
- (void) setDataAsAttributedString:(NSAttributedString*) s;

/**
    is the page encrypted?
*/
- (BOOL) isEncrypted;

/**
    Add an object to the vpdata with a unique key.
    Make sure anything you put in here for the object can be serialized out to
    a plist file.
*/
- (void) setExtraObject:(id)obj forKey:(NSString*)aKey;

/**
    Return an object for the given key.  See setExtraObject:forKey: above.
*/
- (id) extraObjectForKey:(NSString*)aKey;

- (void) removeExtraObjectForKey:(NSString*)aKey;


@end

/**
    VPPluginDocument represents a VoodooPad document.  You can use it to pull
    out vpdatas, and do other sorts of nifty things.
*/

@protocol VPPluginDocument <NSObject>

/**
    returns the number of VPData objects in this document
*/
- (int) numberOfVPDatas;

/**
    Grab a VPData for the given key.  If it doesn't exist, then it returns nil.
*/
- (id<VPData>) vpDataForKey:(NSString*)key;

/**
    Grab a VPData for the given alias/title.  If it doesn't exist, then it
    returns nil.
*/
- (id<VPData>) vpDataForAlias:(NSString*)vpdAlias;

/**
    Get an array of all the keys for the VPData objects in this document.
*/
- (NSArray *)keys;

/**
    tell the document to markup the string, like it would in a VPWindowController
*/
- (void) markupAttributedString:(NSMutableAttributedString*)string;

/**
    returns the file path of the document
*/
- (NSString*) fileName;

/*
    tells the document to ask all the window controllers to "commit" it's data.
    this has to be done before you pull the data out of the document, or else you
    might get some older pages.
*/
- (void) synchronizeDocs;

/**
    tell the document to open up a page with the title.  It may or may not exist
    yet.
*/
- (void) openPageWithTitle:(NSString *)title;

/**
    Have to document create and return a new page/VPData object with the given
    key
*/
- (id<VPData>) createNewVPDataWithKey:(NSString*)key;

@end

/**
    the VPURLHandler protocol is what you would implement if you wanted to add
    additional url's and links and such to a VoodooPad document.  For instance,
    if you wanted to add AddressBook integration, you could poll the address
    book data, and add keys to the open documents by way of
    VPPluginManager's addLinkable:withURL: method.
    
    You add a VPURLHandler to VoodooPad by calling VPPluginManager's 
    registerURLHandler:
    
    Check out VPABLinkables for an example.
*/

@protocol VPURLHandler 

/**
    You might get asked by VoodooPad if you can handle a type of url, if you
    can, then return YES here, otherwise return NO
 */
- (BOOL) canHandleURL:(NSString*)url;

/**
    This is called when VoodooPad wants you to handle a url that should be open,
    return YES if you took care of it, NO otherwise.
*/
- (BOOL) handleURL:(NSString*)url;

@end

/**
    VPWindowController represents a window with a document page in it.  This is
    the interface that is passed to you when you register a selector to be 
    called from the plugin menu.
*/

@protocol VPPluginWindowController <NSObject>

/**
    returns the NSTextView that is in this particular window controller's window
*/
- (NSTextView*) textView;

/**
    returns the window for this VPWindowController
*/
- (NSWindow*) window;

/**
    Sets the status for the window- the little NSTextField at the bottom of the
    window.
*/
- (void) setStatus:(NSString*)message;

/**
    return the key for the VPData of the page that the window is displaying
*/
- (NSString*) key;

/**
    return the VPPluginDocument for this VPWindowController
*/
- (id<VPPluginDocument>) document;
@end



/**
    VPPluginManager is what sets up the plugis, and gives an interface to the
    application for plugin authors.
*/

@protocol VPPluginManager <NSObject>

/**
    Add a key to the open documents, with the url to open when it's clicked on
*/
- (void) addLinkable:(NSString*)linkable withURL:(NSString*)theURL;

/**
    Let the application know to reindex the linkables- you need to do this after
    adding one or more linkables via addLinkable:withURL:
*/
- (void) reindexLinkables;

/**
    Add a menu item to the plugins menu.
    menuTitle: This is the label the menu that will call your plugin will use.
    superMenuTitle: This is the super menu that the menuTitle will be nested 
                    under.  If this is nil, then it is put directly under the
                    plugins menu.
    target: the object to call on.
    action: the selector to use on the target.
    keyEquivalent: The keyEquivalent for the nsmenuitem
    keyEquivalentModifierMask: the mask to be used for the keyEquivalent
*/
- (BOOL) addPluginsMenuTitle:(NSString*)menuTitle
          withSuperMenuTitle:(NSString*)superMenuTitle
                      target:(id)target
                      action:(SEL)selector
               keyEquivalent:(NSString*)keyEquivalent
   keyEquivalentModifierMask:(unsigned int)mask;

/**
    Sometimes we have a plugin that we don't want showing up in the plugin menu,
    but we still want it to be called from applescript.  Use this to register
    a name to be called via applescript, which normally happens automaticly 
    when we use addPluginsMenuTitle:withSuperMenuTitle:etc...
*/
- (BOOL) registerPluginAppleScriptName:(NSString*)asName
                                target:(id)target
                                action:(SEL)action;

/**
    Register a VPURLHandler (see VPURLHandler above for more info)
*/
- (BOOL) registerURLHandler:(id<VPURLHandler>)handler;

/**
    grab VoodooPad's task manager, which is used to give feedback to the user
    for long operations.
*/
- (id <VPTaskManager>) taskManager;

@end


@protocol VPPluginActivity <NSObject>
- (void) cancel:(id)sender;
@end


// a convenience macro to get the VPTaskManager.
#define VPTasks [[self pluginManager] taskManager]

/**
    The task manager is what you would use to set a visual progress indicator
    for the users when doing long operations- like the HTML export.
*/

@protocol VPTaskManager <NSObject>

/**
    Add some sort of object to the VPTaskManager that represents a long 
    activity.
*/
- (void) addActivity:(id<VPPluginActivity>)sender;

/**
    Set the status for an activity.
*/
- (void) setStatus:(NSString*) statusText forActivity:(id<VPPluginActivity>)activity;

/**
    remove an activity.
*/
- (void) removeActivity:(id<VPPluginActivity>)sender;

@end



@interface NSTextView (VPTextViewAdditions)

/**
 Keeps track of undo for replacing chars.
*/
- (void)fmReplaceCharactersInRange:(NSRange)range withAttributedString:(NSAttributedString *)string;

@end

@interface NSMutableAttributedString (VPMutableAttributedStringAdditions)
// just trust that this is there for now.
- (NSMutableArray*) componentsSeparatedByNewline;
@end


@interface NSString (VPStringAdditions) 

/**
    return what the "key" would be for a given string.  It's not always just
    lowercase...
*/
- (NSString*) vpkey;

// this is done to get around a bug in 10.2
// http://developer.apple.com/qa/qa2001/qa1202.html
- (NSString*) trim;


- (NSString*) fmStringByAddingPercentEscapes;
- (NSString*) fmFilenameFriendlyString;
- (NSString*) escapeForHTMLString;

// thanks buzz! 
// http://www.scifihifi.com/weblog/software/NSString+Templating.html
- (NSString *) stringByParsingTagsWithStartDelimeter: (NSString *) startDelim endDelimeter: (NSString *) endDelim usingObject: (id) object;
- (NSString *) stringByEscapingQuotes;
- (NSString *) stringByEscapingCharactersInSet: (NSCharacterSet *) set usingString: (NSString*) escapeString;


- (NSString*) prettyStringWithDictionary:(NSDictionary*) d;
- (NSString*) prettyStringWithDictionary:(NSDictionary*)d escapeAsXML:(BOOL) escape;

@end
