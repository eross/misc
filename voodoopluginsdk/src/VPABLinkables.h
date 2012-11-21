/*
Copyright (c) 2004, Flying Meat Inc.
All rights reserved. 
*/
#import <Foundation/Foundation.h>
#import <AddressBook/AddressBook.h>
#import <VPPlugin/VPPlugin.h>


@interface VPABLinkables : VPPlugin <VPURLHandler> {
    IBOutlet NSPanel *choiceWindow;
    IBOutlet NSButton *emailButton;
    IBOutlet NSButton *openAddressButton;
    IBOutlet NSButton *cancelButton;
    
    NSString *url;
}

- (NSString *)url;
- (void)setUrl:(NSString *)newUrl;
- (NSString*) getEmailAddressForURL:(NSString *)url;

- (IBAction) sendEmail:(id)sender;
- (IBAction) sendInstantMessage:(id)sender;
- (IBAction) openInAddressBook:(id)sender;
- (IBAction) cancel:(id)sender;

@end
