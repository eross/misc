/*
Copyright (c) 2004, Flying Meat Inc.
All rights reserved. 
*/
#import "VPPlugin.h"

@implementation VPPlugin

+ (VPPlugin*) plugin {
    return [[[self alloc] init] autorelease];
}

- (void) setPluginManager:(id<VPPluginManager>)aPluginManager {
    manager = aPluginManager;
}

- (id<VPPluginManager>) pluginManager {
    return manager;
}

- (void) willRegister {
    
}

- (void) didRegister {
    
}

@end
