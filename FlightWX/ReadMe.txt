 ### SeismicXML  ###

===========================================================================
DESCRIPTION:

The SeismicXML sample application demonstrates how to use NSXMLParser to parse XML documents.
When you launch the application it fetches and parses an RSS feed from the USGS that provides data on 
recent earthquakes around the world. It displays the location, date, and magnitude of each earthquake, 
along with a color-coded graphic that indicates the severity of the earthquake.

The XML parsing occurs on a background thread and updates the earthquakes table view each time an 
earthquake is found in the XML document. The XMLReader class includes extensive comments that
describe how to use NSXMLParser.

===========================================================================
BUILD REQUIREMENTS

Mac OS X 10.5.3, Xcode 3.1, iPhone OS 2.0

===========================================================================
RUNTIME REQUIREMENTS

Mac OS X 10.5.3, iPhone OS 2.0

===========================================================================
PACKAGING LIST

SeismicXMLAppDelegate.h
SeismicXMLAppDelegate.m
The controller for the application.

AppDelegateMethods.h
An interface that provides some method declarations so other classes can use methods in AppDelegate.

Earthquake.h
Earthquake.m
The model class that stores the information about an earthquake.

RootViewController.h
RootViewController.m
A UITableViewController subclass that manages the table view.

TableViewCell.h
TableViewCell.m
A custom table cell.

XMLReader.h
XMLReader.m
Uses NSXMLParser to build the model objects.

CHANGES FROM PREVIOUS VERSIONS

Version 1.7
- Updated for and tested with iPhone OS 2.0. First public release.

Version 1.6
- Updated for GM release.
- Fixed a memory leak in SeismicXMLAppDelegate.m.

Version 1.5
- Updated for Beta 7.
- Fixed memory leaks in XMLReader.m.
- Now uses the SystemConfiguration framework to determine if the RSS feed provider is available and displays a message in the table view if it's not.

Version 1.4
- Updated for Beta 6.
- Added LSRequiresIPhoneOS key to Info.plist
- The custom table view cell add subviews to its content view rather than drawing them directly.

Version 1.3
- Updated for Beta 5.
- Removed the XML-to-Objective-C object mapping to simplify the sample.
- Moved the XML parsing to a background thread.

Version 1.2
- Updated for Beta 4.
- Now uses NSXMLParser to parse XML.
- Removed unused XML parsing classes.

Version 1.1
- Updated for Beta 3.
- Updated table view API.
- Add icon and replaced Default.png file.
- Removed unit tests.
- Removed unused framework.

===========================================================================
Copyright (C) 2008 Apple Inc. All rights reserved.